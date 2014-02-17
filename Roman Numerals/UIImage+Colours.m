//
//  UIImage+Colours.m
//  Roman Numerals
//
//  Created by Robert Clarke on 16/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "UIImage+Colours.h"

@implementation UIImage (Colours)

+ (UIImage *)imageWithColour:(UIColor *)colour {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [colour CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithDarkHighlight {
    UIColor *darkHighlightColour = [UIColor colorWithRed:0.754 green:0.759 blue:0.799 alpha:1.000];

    return [self imageWithColour:darkHighlightColour];
}

+ (UIImage *)imageWithLightHighlight {
    UIColor *lightHighlightColour = [UIColor colorWithRed:0.969 green:0.969 blue:0.973 alpha:1.000];
    
    return [self imageWithColour:lightHighlightColour];
}

@end
