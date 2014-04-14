//
//  UnitSettingStep4ViewController.h
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ToPortalViewController.h"

static NSString * const FamilyGuardsHotSpotName = @"Family-Guard";

@interface UnitSettingStep4ViewController : ToPortalViewController<UITextFieldDelegate>

- (BOOL)detectionFamilyGuardsWifiExists;

@end
