//
//  Contact.m
//  securityguards
//
//  Created by Zhao yang on 2/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.name = [json noNilStringForKey:@"name"];
        self.phoneNumber = [json noNilStringForKey:@"tel"];
        self.address = [json noNilStringForKey:@"del"];
    }
    return self;
}

@end
