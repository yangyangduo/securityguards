//
//  Merchandise.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Merchandise.h"

@implementation Merchandise

@synthesize identifier;
@synthesize name = _name_;
@synthesize shortIntroduce;
@synthesize htmlIntroduce;
@synthesize merchandiseColors = _merchandiseColors_;
@synthesize merchandiseModels = _merchandiseModels_;
@synthesize merchandisePictures = _merchandisePictures_;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.name = [json noNilStringForKey:@"ti"];
        self.shortIntroduce = [json noNilStringForKey:@"su"];
        self.htmlIntroduce = [json noNilStringForKey:@"des"];
        
        NSArray *_models_ = [json arrayForKey:@"prs"];
        NSArray *_colors_ = [json arrayForKey:@"cos"];
        
        NSDictionary *_pictures_ = [json dictionaryForKey:@"pic"];
        
        if(_models_ != nil) {
            for(int i=0; i<_models_.count; i++) {
                NSDictionary *_json_ = [_models_ objectAtIndex:i];
                [self.merchandiseModels addObject:[[MerchandiseModel alloc] initWithJson:_json_]];
            }
        }
        
        if(_colors_ != nil) {
            for(int i=0; i<_colors_.count; i++) {
                NSDictionary *_json_ = [_colors_ objectAtIndex:i];
                [self.merchandiseColors addObject:[[MerchandiseColor alloc] initWithJson:_json_]];
            }
        }
        
        if(_pictures_ != nil) {
            [self.merchandisePictures addObject:[[MerchandisePictures alloc] initWithJson:_pictures_]];
        }
        
    }
    return self;
}

- (MerchandiseModel *)merchandiseModelForName:(NSString *)name {
    if([XXStringUtils isBlank:name]) return nil;
    if(self.merchandiseModels == nil) return nil;
    for(int i=0; i<self.merchandiseModels.count; i++) {
        MerchandiseModel *model = [self.merchandiseModels objectAtIndex:i];
        if([name isEqualToString:model.name]) {
            return model;
        }
    }
    return nil;
}

- (MerchandiseColor *)merchandiseColorForName:(NSString *)color {
    if([XXStringUtils isBlank:color]) return nil;
    if(self.merchandiseColors == nil) return nil;
    for(int i=0; i<self.merchandiseColors.count; i++) {
        MerchandiseColor *mColor = [self.merchandiseColors objectAtIndex:i];
        if([color isEqualToString:mColor.name]) {
            return mColor;
        }
    }
    return nil;
}

- (MerchandiseColor *)defaultMerchandiseColor {
    if(self.merchandiseColors == nil || self.merchandiseColors.count == 0) return nil;
    return [self.merchandiseColors objectAtIndex:0];
}

- (MerchandiseModel *)defaultMerchandiseModel {
    if(self.merchandiseModels == nil || self.merchandiseModels.count == 0) return nil;
    return [self.merchandiseModels objectAtIndex:0];
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    return json;
}

- (NSMutableArray *)merchandisePictures {
    if(_merchandisePictures_ == nil) {
        _merchandisePictures_ = [NSMutableArray array];
    }
    return _merchandisePictures_;
}

- (NSMutableArray *)merchandiseModels {
    if(_merchandiseModels_ == nil) {
        _merchandiseModels_ = [NSMutableArray array];
    }
    return _merchandiseModels_;
}

- (NSMutableArray *)merchandiseColors {
    if(_merchandiseColors_ == nil) {
        _merchandiseColors_ = [NSMutableArray array];
    }
    return _merchandiseColors_;
}

@end



@implementation MerchandiseModel

@synthesize name;
@synthesize price;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.name = [json noNilStringForKey:@"mod"];
        self.price = [json numberForKey:@"pri"].floatValue;
    }
    return self;
}

@end


@implementation MerchandisePictures

@synthesize bigImage;
@synthesize smallImage;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.bigImage = [json noNilStringForKey:@"bp"];
        self.smallImage = [json noNilStringForKey:@"sp"];
    }
    return self;
}

@end

@implementation MerchandiseColor

@synthesize name;
@synthesize picture;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.name = [json noNilStringForKey:@"nam"];
        self.picture = [json noNilStringForKey:@"pi"];
    }
    return self;
}

@end












