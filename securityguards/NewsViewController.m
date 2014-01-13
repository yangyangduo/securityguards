//
//  NewsViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Extension.h"
#import "NewsCell.h"
#import "NewsService.h"
#import "NewsFileManager.h"

#define WATTING_SECONDS 1.5f
#define Refresh_TIME_DIFFERENCE_MINUTES 60

@interface NewsViewController ()

@end

@implementation NewsViewController {
    PullTableView *tblNews;
    NSMutableArray *allNews;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    [super initDefaults];
    allNews = [NSMutableArray array];
}

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"news_drawer_title", @"");
    self.view.backgroundColor = [UIColor appGray];
    
    tblNews = [[PullTableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStylePlain];
    tblNews.backgroundColor = [UIColor clearColor];
    tblNews.backgroundView = nil;
    tblNews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblNews.pullTextColor = [UIColor lightGrayColor];
    tblNews.delegate = self;
    tblNews.dataSource = self;
    tblNews.pullDelegate = self;
    [self.view addSubview:tblNews];
}

- (void)setUp {
    [super setUp];
    
    NSDate *lastUpdateTime = nil;
    NSArray *news = [[NewsFileManager fileManager] readFromDisk:&lastUpdateTime];
    if(news != nil) {
        tblNews.pullLastRefreshDate = lastUpdateTime;
        [allNews addObjectsFromArray:news];
        [tblNews reloadData];
    }
    
    if(lastUpdateTime != nil) {
        NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        NSTimeInterval minutes = timeDifference / 60;
        if(minutes < Refresh_TIME_DIFFERENCE_MINUTES) {
            return;
        }
    }
    
    [self getTopNews];
    tblNews.pullTableIsRefreshing = YES;
}

#pragma mark -
#pragma mark News Service

- (void)getTopNews {
    NewsService *service = [[NewsService alloc] init];
    [service getTopNewsWithSuccess:@selector(getNewsSuccess:) failed:@selector(getNewsFailed:) target:self callback:nil];
}

- (void)getMoreNews {
    if(allNews != nil && allNews.count > 0) {
        NewsService *service = [[NewsService alloc] init];
        News *lastNews = [allNews lastObject];
        [service getMoreNewsWithTimeline:lastNews.createTime success:@selector(getNewsSuccess:) failed:@selector(getNewsFailed:) target:self callback:@"appendNews"];
    }
}

- (void)getNewsSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            if([json intForKey:@"i"] == 1) {
                NSArray *arr = [json arrayForKey:@"m"];
                
                BOOL isAppendNews = NO;
                if(resp.callbackObject != nil
                   && [resp.callbackObject isKindOfClass:[NSString class]]
                   && [@"appendNews" isEqualToString:resp.callbackObject]) {
                    isAppendNews = YES;
                }
                
                if(!isAppendNews) {
                    [allNews removeAllObjects];
                }
                
                NSMutableArray *indexPaths = [NSMutableArray array];
                int lastIndex = allNews.count;
                if(arr == nil || arr.count == 0) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
                } else {
                    for(int i=0; i<arr.count; i++) {
                        NSDictionary *dic = [arr objectAtIndex:i];
                        [allNews addObject:[[News alloc] initWithJson:dic]];
                        if(isAppendNews) {
                            [indexPaths addObject:[NSIndexPath indexPathForRow:lastIndex + i inSection:0]];
                        }
                    }
                }
                
                [self cancelRefresh];
                [self cancelLoadMore];
                
                if(!isAppendNews) {
                    [tblNews reloadData];
                    NSDate *now = [NSDate date];
                    tblNews.pullLastRefreshDate = now;
                    [[NewsFileManager fileManager] saveToDisk:allNews lastUpdateTime:now];
                } else {
                    [tblNews beginUpdates];
                    [tblNews insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [tblNews endUpdates];
                }
                return;
            }
        }
    }
    [self getNewsFailed:resp];
}

- (void)getNewsFailed:(RestResponse *)resp {
    [self cancelRefresh];
    [self cancelLoadMore];
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode == 1004)) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 165;
    } else {
        return 75;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allNews == nil ? 0 : allNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *cellTopNewsIdentifier = @"cellTopNewsIdentifier";
    
    News *news = [allNews objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    
    if(indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellTopNewsIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTopNewsIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.frame = CGRectMake(0, 0, cell.bounds.size.width, 165);
            UIImageView *imgNews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 160)];
            imgNews.tag = 888;
            
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, imgNews.bounds.size.height - 30, 320, 30)];
            titleView.tag = 889;
            titleView.backgroundColor = [UIColor colorWithRed:255 green:251 blue:240 alpha:0.6];
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 260, 26)];
            lblTitle.tag = 300;
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.font = [UIFont boldSystemFontOfSize:13];
            lblTitle.textColor = [UIColor darkGrayColor];
            [titleView addSubview:lblTitle];
            [imgNews addSubview:titleView];
            
            [cell addSubview:imgNews];
        }
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:888];
        UILabel *lblNewsTitle = (UILabel *)[[cell viewWithTag:889] viewWithTag:300];
        [imgView setImageWithURL:[[NSURL alloc] initWithString:news.imageUrl] placeholderImage:[UIImage imageNamed:@"test"]];
        lblNewsTitle.text = news.title;
    } else {
        NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(newsCell == nil) {
            newsCell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSDate *newsDate = [NSDate dateWithTimeIntervalMillisecondSince1970:news.createTime];
        [newsCell setContent:news.title];
        [newsCell setCreateTime:[XXDateFormatter dateToString:newsDate format:@"MM-dd HH:mm:ss"]];
    
        cell = newsCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    News *news = [allNews objectAtIndex:indexPath.row];
    
    NewsDetailViewController *newsDetailViewController = [[NewsDetailViewController alloc] initWithNews:news];
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Pull Table View Delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(tblNews.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:WATTING_SECONDS];
        return;
    }
    [self getTopNews];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if(tblNews.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:WATTING_SECONDS];
        return;
    }
    [self getMoreNews];
}

- (void)cancelRefresh {
    tblNews.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    tblNews.pullTableIsLoadingMore = NO;
}

@end
