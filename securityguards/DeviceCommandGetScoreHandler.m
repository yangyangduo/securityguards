//
// Created by Zhao yang on 3/4/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceCommandGetScoreHandler.h"
#import "XXEventSubscriptionPublisher.h"
#import "UnitManager.h"
#import "ScoreChangedEvent.h"

@implementation DeviceCommandGetScoreHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandGetScore class]]) {
        DeviceCommandGetScore *getScoreCommand = (DeviceCommandGetScore *)command;
        Unit *unit = [[UnitManager defaultManager] findUnitByIdentifier:getScoreCommand.masterDeviceCode];
        if(unit != nil) {
            unit.score.score = getScoreCommand.score;
            unit.score.rankings = getScoreCommand.rankings;
            unit.score.scoreDate = getScoreCommand.scoreTime;

            ScoreChangedEvent *event = [[ScoreChangedEvent alloc] init];
            event.score = unit.score;

            [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
        } else {
#ifdef DEBUG
            //NSLog(@"[DEVICE COMMAND GET SCORE HANDLER] Can't find unit for %@", getScoreCommand.masterDeviceCode);
#endif
        }
    }
}

@end