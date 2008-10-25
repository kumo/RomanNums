//
//  Converter.h
//  Roman
//
//  Created by Rob on 25/10/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Converter : NSObject {

}

+ (NSString *)convertToArabic:(NSString *) roman;
+ (NSString *)convertToRoman:(NSString *) arabic;

@end
