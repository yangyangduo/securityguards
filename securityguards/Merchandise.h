//
//  Merchandise.h
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"

@class MerchandiseModel;
@class MerchandiseColor;

@interface Merchandise : Entity

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortIntroduce;
@property (nonatomic, strong) NSString *htmlIntroduce;
@property (nonatomic, strong) NSMutableArray *merchandiseModels;
@property (nonatomic, strong) NSMutableArray *merchandiseColors;
@property (nonatomic, strong) NSMutableArray *merchandisePictures;

- (MerchandiseColor *)merchandiseColorForName:(NSString *)color;
- (MerchandiseModel *)merchandiseModelForName:(NSString *)name;

- (MerchandiseModel *)defaultMerchandiseModel;
- (MerchandiseColor *)defaultMerchandiseColor;

@end


@interface MerchandiseColor : Entity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *picture;

@end

@interface MerchandiseModel : Entity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float price;

@end

@interface MerchandisePictures : Entity

@property (nonatomic, strong) NSString *bigImage;
@property (nonatomic, strong) NSString *smallImage;

@end
