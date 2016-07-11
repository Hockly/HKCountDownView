//
//  UIImage+HKExtension.m
//  HKCountDownView
//
//  Created by Mac on 16/7/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIImage+HKExtension.h"

@implementation UIImage (HKExtension)
- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *newImage;
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    CGRect imageRect=CGRectMake(0, 0, targetSize.width, targetSize.height);
    [self drawInRect:imageRect];
    newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
