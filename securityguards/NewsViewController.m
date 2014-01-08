//
//  NewsViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "NewsCell.h"

@interface NewsViewController ()

@end

@implementation NewsViewController {
    UITableView *tblNews;
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
    
    tblNews = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStylePlain];
    tblNews.backgroundColor = [UIColor clearColor];
    tblNews.backgroundView = nil;
    tblNews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblNews.delegate = self;
    tblNews.dataSource = self;
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
            [cell addSubview:imgNews];
        }
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:888];
        imgView.image = [UIImage imageNamed:@"test"];
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

@end
