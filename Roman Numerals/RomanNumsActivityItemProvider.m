//
//  RomanNumsActivityItemProvider.m
//  Roman Numerals
//
//  Created by Robert Clarke on 17/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "RomanNumsActivityItemProvider.h"

@implementation RomanNumsActivityItemProvider

- (id)initWithRomanText:(NSString *)romanText arabicText:(NSString *)arabicText romanToArabic:(BOOL)romanToArabic
{
    NSString *placeHolder = @"";
    
    if (romanToArabic) {
        placeHolder = [NSString stringWithFormat:@"%@ = %@", romanText, arabicText];
    } else {
        placeHolder = [NSString stringWithFormat:@"%@ = %@", arabicText, romanText];
    }
    
    self = [super initWithPlaceholderItem:placeHolder];
    
    if (self) {
        _arabicString = arabicText;
        _romanString = romanText;
        _romanToArabic = romanToArabic;
    }
    
    return self;
}

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return [NSString stringWithFormat:@"%@ #romannumsapp", self.placeholderItem];
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return self.placeholderItem;
    return self.placeholderItem;
}

@end
