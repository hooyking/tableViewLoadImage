//
//  UIImage+HKKit.m
//  tableViewLoadImage
//
//  Created by hooyking on 2020/7/10.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "UIImage+HKKit.h"

@implementation UIImage (HKKit)

- (UIImage *)drawImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
