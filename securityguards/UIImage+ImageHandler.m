//
//  UIImage+ImageHandler.m
//  securityguards
//
//  Created by hadoop user account on 2/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UIImage+ImageHandler.h"

@implementation UIImage (ImageHandler)

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scaleSize,image.size.height*scaleSize)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(reSize);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

@end
