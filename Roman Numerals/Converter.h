//
//  Converter.h
//  Roman
//
//  Created by Rob on 25/10/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	Valid = 0,
	Ignored,
	Converted
} ConversionResult;

@interface Converter : NSObject {
	BOOL		performConversionCheck;
	
	ConversionResult		conversionResult;
	
	NSString	*romanResult;
	NSString	*arabicResult;
	
	NSString	*calculatedRomanValue;
	NSString	*calculatedArabicValue;
	
	NSArray		*arabicCalculationValues;
	NSArray		*romanCalculationValues;
}

- (void)convertToArabic:(NSString *) roman;
- (void)convertToRoman:(NSString *) arabic archaic:(bool) archaic;
- (NSString *)performConversionToArabic:(NSString *) roman;
- (NSString *)performConversionToRoman:(NSString *) arabic;
- (NSString *)performSimpleConversionToRoman:(NSString *) arabic;
- (NSString *)performOldConversionToRoman:(NSString *) arabic;
- (NSString *)performOldConversionToArabic:(NSString *) roman;

@property (nonatomic) BOOL performConversionCheck;
@property (nonatomic) ConversionResult conversionResult;
@property (nonatomic, retain) NSString *romanResult;
@property (nonatomic, retain) NSString *arabicResult;
@property (nonatomic, retain) NSString *calculatedRomanValue;
@property (nonatomic, retain) NSString *calculatedArabicValue;
@property (nonatomic, retain) NSArray *arabicCalculationValues;
@property (nonatomic, retain) NSArray *romanCalculationValues;

@end
