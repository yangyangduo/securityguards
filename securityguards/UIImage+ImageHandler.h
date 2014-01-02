//
//  UIImage+ImageHandler.h
//  securityguards
//
//  Created by hadoop user account on 2/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageHandler)
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
