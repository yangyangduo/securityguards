//
//  CurrentUnitChangedEvent.h
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "EventNameContants.h"

@interface CurrentUnitChangedEvent : XXEvent

@property (strong, nonatomic, readonly) NSString *unitIdentifier;

- (id)initWithCurrentIdentifier:(NSString *)identifier;

@end
