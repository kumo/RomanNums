//
//  Converter.h
//  Roman
//
//  Created by Rob on 25/10/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Converter : NSObject {
	BOOL		performConversionCheck;
	
	BOOL		inputLooksCorrect;
	NSString	*romanResult;
	NSString	*arabicResult;
	
	NSString	*calculatedRomanValue;
	NSString	*calculatedArabicValue;
	
	NSArray		*arabicCalculationValues;
	NSArray		*romanCalculationValues;
}

- (void)convertToArabic:(NSString *) roman;
- (void)convertToRoman:(NSString *) arabic;
- (NSString *)performConversionToArabic:(NSString *) roman;
- (NSString *)performConversionToRoman:(NSString *) arabic;

@property (nonatomic) BOOL performConversionCheck;
@property (nonatomic) BOOL inputLooksCorrect;
@property (nonatomic, retain) NSString *romanResult;
@property (nonatomic, retain) NSString *arabicResult;
@property (nonatomic, retain) NSString *calculatedRomanValue;
@property (nonatomic, retain) NSString *calculatedArabicValue;
@property (nonatomic, retain) NSArray *arabicCalculationValues;
@property (nonatomic, retain) NSArray *romanCalculationValues;

@end
