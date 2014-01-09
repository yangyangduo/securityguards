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
#import "NewsCell.h"

#define WATTING_SECONDS 1.5f

@interface NewsViewController ()

@end

@implementation NewsViewController {
    PullTableView *tblNews;
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
    tblNews.pullLastRefreshDate = [NSDate date];
    [self.view addSubview:tblNews];
}

- (void)setUp {
    [super setUp];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *cellTopNewsIdentifier = @"cellTopNewsIdentifier";
    
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
            lblTitle.font = [UIFont systemFontOfSize:12];
            lblTitle.textColor = [UIColor darkGrayColor];
            [titleView addSubview:lblTitle];
            [imgNews addSubview:titleView];
            
            [cell addSubview:imgNews];
        }
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:888];
        UILabel *lblNewsTitle = (UILabel *)[[cell viewWithTag:889] viewWithTag:300];
        
        [imgView setImageWithURL:[[NSURL alloc] initWithString:@"http://d.hiphotos.baidu.com/image/w%3D2048/sign=fc97483737fae6cd0cb4ac613b8b0e24/728da9773912b31bdbed64298418367adab4e129.jpg"] placeholderImage:[UIImage imageNamed:@"test"]];
        lblNewsTitle.text = @"又发现一起净化器爆炸事件";
        
//        Clear memory cache
//        [[SDImageCache sharedImageCache] clearMemory];
//        [[SDImageCache sharedImageCache] clearDisk];
    } else {
        NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(newsCell == nil) {
            newsCell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell = newsCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsDetailViewController *newsDetailViewController = [[NewsDetailViewController alloc] init];
    
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
    NSLog(@"refresh table ...");
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if(tblNews.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:WATTING_SECONDS];
        return;
    }
    NSLog(@"load more table ...");
}

- (void)refresh {
    
}

- (void)loadMore {
    
}

- (void)cancelRefresh {
    tblNews.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    tblNews.pullTableIsLoadingMore = NO;
}

@end
