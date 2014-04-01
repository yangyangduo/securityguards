//
//  UnitSettingStep4ViewController.h
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"

static NSString *FamilyGuardsHotSpotName = @"Family-Guard";

@interface UnitSettingStep4ViewController : NavigationViewController<UITextFieldDelegate>

- (BOOL)detectionFamilyGuardsWifiExists;

@end
