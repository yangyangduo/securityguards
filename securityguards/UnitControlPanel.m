//
//  UnitControlPanel.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitControlPanel.h"
#import "UIColor+MoreColor.h"
#import "UIDevice+SystemVersion.h"

#define DETAIL_TEXT_LABEL_TAG 888
#define CONTROL_ITEMS_COUNT 4

@implementation UnitControlPanel {
    UITableView *tblControlItems;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.height, 44 * CONTROL_ITEMS_COUNT)];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    tblControlItems = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    tblControlItems.delegate = self;
    tblControlItems.dataSource = self;
    tblControlItems.scrollEnabled = NO;
    tblControlItems.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblControlItems.backgroundColor = [UIColor clearColor];
    [self addSubview:tblControlItems];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CONTROL_ITEMS_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appYellow];
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        }
        
        UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 150, 7, 120, 29)];
        detailTextLabel.tag = DETAIL_TEXT_LABEL_TAG;
        detailTextLabel.textColor = [UIColor appBlue];
        detailTextLabel.textAlignment = NSTextAlignmentRight;
        detailTextLabel.font = [UIFont systemFontOfSize:16.f];
        [cell addSubview:detailTextLabel];
        
        UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 2, cell.bounds.size.width, 2)];
        imgLine.image = [UIImage imageNamed:@"line_dashed_h"];
        [cell addSubview:imgLine];
        
        UIImageView *imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 20, 7.3f, 3.5f, 27.5f)];
        imgLine2.image = [UIImage imageNamed:@"line_dashed_v"];
        [cell addSubview:imgLine2];
    }
    
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor appDarkGray];
    } else {
        cell.backgroundView.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor appDarkGray];
    }
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon_power"];
            cell.textLabel.text = @"电源";
            [self detailTextLabelForCell:cell].text = @"开启";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"icon_level"];
            cell.textLabel.text = @"档位";
            [self detailTextLabelForCell:cell].text = @"开启";
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"icon_security"];
            cell.textLabel.text = @"安防";
            [self detailTextLabelForCell:cell].text = @"开启";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // do some thing here
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UILabel *)detailTextLabelForCell:(UITableViewCell *)cell {
    if(cell != nil) {
        UIView *view = [cell viewWithTag:DETAIL_TEXT_LABEL_TAG];
        if(view != nil && [view isKindOfClass:[UILabel class]]) {
            return (UILabel *)view;
        }
    }
    return nil;
}

@end
