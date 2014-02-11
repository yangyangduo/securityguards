//
//  UnitControlPanel.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitControlPanel.h"
#import "UIColor+MoreColor.h"
#import "UIColor+HexColor.h"
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
    
    NSMutableArray *displayedDevices;
    
    /*
     * if device count has changed that
     * we should to change the frame(height) of tblControlItems
     * and also need to change contentSize fo self.superView (UIScrollView)
     *
     * else we should not to do there.
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

- (instancetype)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.height, CONTROL_ITEM_HEIGHT * deviceCount)];
    if (self) {
        // Initialization code
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point andUnit:(Unit *)unit {
    [self setDisplayedDevicesForUnit:unit];
    [self calculateDeviceCount];
    self = [self initWithPoint:point];
    if(self) {
        _unit_ = unit;
    }
    return self;
}

- (void)initDefaults {
    displayedDevices = [NSMutableArray array];
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
    
    Device *device = [displayedDevices objectAtIndex:indexPath.row];
    
    UILabel *detailTextLabel = (UILabel *)[cell viewWithTag:DETAIL_TEXT_LABEL_TAG];
    detailTextLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    // set device display name
    cell.textLabel.text = device.name;
    
    // set device display image
    if(device.isAirPurifierPower) {
        cell.imageView.image = [UIImage imageNamed:@"icon_power"];
        if(device.status == 0) {
            detailTextLabel.textColor = [UIColor appBlue];
        }
    } else if(device.isAirPurifierLevel) {
        cell.imageView.image = [UIImage imageNamed:@"icon_level"];
    } else if(device.isAirPurifierModeControl) {
        cell.imageView.image = [UIImage imageNamed:@"icon_control_mode"];
    } else if(device.isAirPurifierSecurity) {
        if(device.status == 0 || device.status == 2) {
            detailTextLabel.textColor = [UIColor appBlue];
        }
        cell.imageView.image = [UIImage imageNamed:@"icon_security"];
    } else if(device.isCamera) {
        cell.imageView.image = [UIImage imageNamed:@"icon_camera"];
    } else {
        
    }
    
    // set device state for detail text label
    if(device.isCamera) {
        [self detailTextLabelForCell:cell].text = NSLocalizedString(@"view", @"");
    } else {
        [self detailTextLabelForCell:cell].text = [DeviceUtils statusAsStringFor:device];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.unit == nil || self.delegate == nil) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    Device *device = [displayedDevices objectAtIndex:indexPath.row];
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
                if(device.status == item.deviceState) {
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
        if(buttonIndex < operations.count) {
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

- (void)calculateDeviceCount {
    int oldDeviceCount = deviceCount;
    deviceCount = displayedDevices == nil ? 0 : displayedDevices.count;
    deviceCountChanged = oldDeviceCount != deviceCount;
}

- (void)setUnit:(Unit *)unit {
    _unit_ = unit;
    [self setDisplayedDevicesForUnit:_unit_];
    [self calculateDeviceCount];
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

- (void)setDisplayedDevicesForUnit:(Unit *)unit {
    [displayedDevices removeAllObjects];
    if(unit == nil) return;
    
    for(int i=0; i<unit.zones.count; i++) {
        Zone *zone = [unit.zones objectAtIndex:i];
//      begin if
        if(zone.isMasterZone) {
            for(int j=0; j<zone.devices.count; j++) {
                Device *device = [zone.devices objectAtIndex:j];
                if(device.isAirPurifier) {
                    [displayedDevices addObject:device];
                }
            }
        } else {
            for(int j=0; j<zone.devices.count; j++) {
                Device *device = [zone.devices objectAtIndex:j];
                if(device.isCamera) {
                    [displayedDevices addObject:device];
                }
            }
        }
//      end if
    }
}

@end
