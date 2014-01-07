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
#import "CameraViewController.h"
#import "UnitManager.h"
#import "DeviceOperationItem.h"
#import "Shared.h"
#import "DeviceUtils.h"

#define DETAIL_TEXT_LABEL_TAG 888
#define CONTROL_ITEM_HEIGHT 44

@implementation UnitControlPanel {
    UITableView *tblControlItems;
    
    /*
     * if device count has changed that
     * we should to change the frame(height) tblControlItems
     * and also need to change contentSize fo self.superView (UIScrollView)
     */
    int deviceCount;
    BOOL deviceCountChanged;
}

@synthesize delegate;
@synthesize unit = _unit_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.height, CONTROL_ITEM_HEIGHT * deviceCount)];
    if (self) {
        // Initialization code
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point andUnit:(Unit *)unit {
    [self calculateDeviceCountForUnit:unit];
    self = [self initWithPoint:point];
    if(self) {
        _unit_ = unit;
    }
    return self;
}

- (void)initDefaults {
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
    return deviceCount;
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
        detailTextLabel.backgroundColor = [UIColor clearColor];
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
    
    Zone *zone = [_unit_.zones objectAtIndex:0];
    Device *device = [zone.devices objectAtIndex:indexPath.row];
    
    // set device display name
    cell.textLabel.text = device.name;
    
    // set device display image
    if(device.isAirPurifierPower) {
        cell.imageView.image = [UIImage imageNamed:@"icon_power"];
    } else if(device.isAirPurifierLevel) {
        cell.imageView.image = [UIImage imageNamed:@"icon_level"];
    } else if(device.isAirPurifierModeControl) {
        cell.imageView.image = [UIImage imageNamed:@"icon_level"];
    } else if(device.isAirPurifierSecurity) {
        cell.imageView.image = [UIImage imageNamed:@"icon_security"];
    } else if(device.isCamera) {
        cell.imageView.image = [UIImage imageNamed:@"icon_camera"];
    } else {
    }
    
    // set device state for detail text label
    if(device.isCamera) {
        [self detailTextLabelForCell:cell].text = NSLocalizedString(@"view", @"");
    } else {
        [self detailTextLabelForCell:cell].text = [DeviceUtils stateAsStringFor:device];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.unit == nil || self.delegate == nil) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    Zone *zone = [self.unit.zones objectAtIndex:0];
    Device *device = [zone.devices objectAtIndex:indexPath.row];
    if(device.isCamera) {
        CameraViewController *cameraViewController = [[CameraViewController alloc] init];
        cameraViewController.cameraDevice = device;
        [[[Shared shared].app topViewController] presentViewController:cameraViewController animated:YES completion:^{}];
    } else {
        NSArray *operations = [DeviceUtils operationsListFor:device];
        if(operations != nil && operations.count > 0) {
            XXActionSheet *actionSheet = [[XXActionSheet alloc] init];
            [actionSheet setParameter:operations forKey:@"deviceOperations"];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            actionSheet.title = NSLocalizedString(@"please_select", @"");
            actionSheet.delegate = self;
            for(int i=0; i<operations.count; i++) {
                DeviceOperationItem *item = [operations objectAtIndex:i];
                if(device.state == item.deviceState) {
                    actionSheet.destructiveButtonIndex = i;
                }
                [actionSheet addButtonWithTitle:item.displayName];
            }
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"")];
            UIViewController *viewController = (UIViewController *)self.delegate;
            [actionSheet showInView:viewController.view];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet isKindOfClass:[XXActionSheet class]]) {
        XXActionSheet *aSheet = (XXActionSheet *)actionSheet;
        NSArray *operations = [aSheet parameterForKey:@"deviceOperations"];
        if(buttonIndex != operations.count) {
            DeviceOperationItem *item = [operations objectAtIndex:buttonIndex];
            NSLog(@"[%@] - [%@]", item.displayName, item.commandString);
return;
            [DeviceUtils executeOperationItem:item];
        }
    }
}

#pragma mark -
#pragma mark UI Methods

- (void)refreshWithUnit:(Unit *)unit {
    self.unit = unit;
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

- (void)calculateDeviceCountForUnit:(Unit *)unit {
    int oldDeviceCount = deviceCount;
    if(unit == nil) {
        deviceCount = 0;
    } else {
        if(unit.zones.count == 0) {
            deviceCount = 0;
        } else {
            Zone *zone = [unit.zones objectAtIndex:0];
            deviceCount = (int)zone.devices.count;
        }
    }
    deviceCountChanged = oldDeviceCount != deviceCount;
}

- (void)setUnit:(Unit *)unit {
    _unit_ = unit;
    [self calculateDeviceCountForUnit:_unit_];
    if(tblControlItems != nil) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, CONTROL_ITEM_HEIGHT * deviceCount);
        tblControlItems.frame = self.bounds;
        [tblControlItems reloadData];
        if(deviceCountChanged && self.delegate != nil && [self.delegate respondsToSelector:@selector(unitControlPanelSizeChanged:)] ) {
            [self.delegate unitControlPanelSizeChanged:self];
        }
    }
}

@end
