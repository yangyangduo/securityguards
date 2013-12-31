//
//  UnitSelectionDrawerView.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitSelectionDrawerView.h"
#import "UIColor+MoreColor.h"
#import "UnitManager.h"
#import "UIDevice+SystemVersion.h"

@implementation UnitSelectionDrawerView {
    NSMutableArray *units;
    UITableView *tblUnits;
}

@synthesize weakRootViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appBlue];
    
    tblUnits = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 160, 0, 160, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblUnits.delegate = self;
    tblUnits.dataSource = self;
    tblUnits.backgroundColor = [UIColor clearColor];
    
    [self addSubview:tblUnits];
}

- (void)refresh {
    if(units == nil) {
        units = [NSMutableArray array];
    } else {
        [units removeAllObjects];
    }
    [units addObjectsFromArray:[UnitManager defaultManager].units];
    [tblUnits reloadData];
    Unit *currentUnit = [UnitManager defaultManager].currentUnit;
    if(currentUnit != nil) {
        int currentUnitIndex = -1;
        for(int i=0; i<units.count; i++) {
            Unit *u = [units objectAtIndex:i];
            if([currentUnit.identifier isEqualToString:u.identifier]) {
                currentUnitIndex = i;
                break;
            }
        }
        if(currentUnitIndex != -1 && tblUnits != nil) {
            [tblUnits selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentUnitIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return units == nil ? 0 : units.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIDevice systemVersionIsMoreThanOrEuqal7] ? 64 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appLightBlue];
        cell.imageView.image = [UIImage imageNamed:@"icon_unit"];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    }
    Unit *unit = [units objectAtIndex:indexPath.row];
    cell.textLabel.text = unit.name;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 64 : 44)];
    headView.backgroundColor = [UIColor appGray];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 160, 44)];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.text = NSLocalizedString(@"select_unit", @"");
    [headView addSubview:lblTitle];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Unit *unit = [units objectAtIndex:indexPath.row];
    [[UnitManager defaultManager] changeCurrentUnitTo:unit.identifier];
    if(self.weakRootViewController != nil) {
        [self.weakRootViewController showCenterView:YES];
    } else {
#ifdef DEBUG
        NSLog(@"[UNIT SELECTION VIEW] Weak root view controller is nil.");
#endif
    }
}

@end
