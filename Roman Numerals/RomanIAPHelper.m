//
//  RomanIAPHelper.m
//  Roman Numerals
//
//  Created by Robert Clarke on 26/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "RomanIAPHelper.h"

@implementation RomanIAPHelper

+ (RomanIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RomanIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      kCalculatorPurchaseKey,
                                      kCalendarPurchaseKey,
                                      kCrosswordPurchaseKey,
                                      kProPurchaseKey,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
