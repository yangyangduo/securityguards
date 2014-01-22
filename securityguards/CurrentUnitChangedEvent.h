//
//  CurrentUnitChangedEvent.h
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "EventNameContants.h"

typedef NS_ENUM(NSUInteger, TriggeredBy) {
    TriggeredByReadDisk,
    TriggeredByGetUnitsCommand,
    TriggeredByManual,
};

@interface CurrentUnitChangedEvent : XXEvent

@property (strong, nonatomic, readonly) NSString *unitIdentifier;
@property (nonatomic) TriggeredBy triggeredSource;

- (id)initWithCurrentIdentifier:(NSString *)identifier triggeredBy:(TriggeredBy)triggerdBy;

@end
