//
//  RomanNumsActivityItemProvider.h
//  Roman Numerals
//
//  Created by Robert Clarke on 17/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RomanNumsActivityItemProvider : UIActivityItemProvider <UIActivityItemSource>

@property (nonatomic, copy) NSString *romanString;
@property (nonatomic, copy) NSString *arabicString;

@property (nonatomic) BOOL romanToArabic;

- (id)initWithRomanText:(NSString *)romanText arabicText:(NSString *)arabicText romanToArabic:(BOOL)romanToArabic;

@end
