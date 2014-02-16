//
//  UIImage+Colours.h
//  Roman Numerals
//
//  Created by Robert Clarke on 16/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Colours)

+ (UIImage *)imageWithColour:(UIColor *)colour;
+ (UIImage *)imageWithDarkHighlight;
+ (UIImage *)imageWithLightHighlight;

@end
