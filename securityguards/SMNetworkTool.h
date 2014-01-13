//
//  SMNetworkTool.h
//  SmartHome
//
//  Created by Zhao yang on 10/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface SMNetworkTool : NSObject

+ (NSString *)getLocalIp;
+ (NSString *)ssidForCurrentWifi;

@end
