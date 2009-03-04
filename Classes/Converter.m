//
//  Converter.m
//  Roman
//
//  Created by Rob on 25/10/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "Converter.h"


@implementation Converter

@synthesize performConversionCheck, arabicResult, romanResult, calculatedRomanValue, calculatedArabicValue, romanCalculationValues, arabicCalculationValues, conversionResult;


- (void) dealloc {
	[romanCalculationValues release];
	[arabicCalculationValues release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	self.romanCalculationValues = [NSArray arrayWithObjects:
								   @"m", @"d", @"c", @"l", @"x", @"vi", @"v", @"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I", nil];
	 self.arabicCalculationValues = [NSArray arrayWithObjects:
									  @"1000000", @"500000", @"100000", @"50000", @"10000", @"6000", @"5000", @"1000", @"900", @"500", @"400", @"100", @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
	self.performConversionCheck = NO;
	self.conversionResult = Valid; // used if no conversion check
	return self;
}

- (void)convertToArabic:(NSString *) roman {
	arabicResult = [self performConversionToArabic:roman];
 	if (performConversionCheck) {
		calculatedRomanValue = [self performConversionToRoman:arabicResult];
	
		//NSLog(@"Roman given is %@ and roman calculated is %@", roman, calculatedRomanValue);

		NSString *choppedString = @"";
		
		if ([roman length] > 1) {
			choppedString = [[NSString alloc] initWithString:[roman substringToIndex: [roman length] - 1]];
		}

		if ([roman isEqualToString:calculatedRomanValue]) {
			self.conversionResult = Valid;
		} else if ([calculatedRomanValue isEqualToString:choppedString]) {
			self.conversionResult = Ignored;
		} else {
			self.conversionResult = Converted;	
		}
		
		[choppedString release];
	}
}

- (void)convertToRoman:(NSString *) arabic {
	romanResult = [self performConversionToRoman:arabic];
	if (performConversionCheck) {
		calculatedArabicValue = [self performConversionToArabic:romanResult];
		
		//NSLog(@"Arabic given is %@ and arabic calculated is %@", arabic, calculatedArabicValue);

		if ([arabic isEqualToString:calculatedArabicValue]) {
			self.conversionResult = Valid;
		} else {
			self.conversionResult = Ignored;	
		}
	}
}

- (NSString *)performConversionToArabic:(NSString *) roman {
	
	NSMutableString *editableString = [NSMutableString stringWithFormat: @"%@", roman];
	
	int result = 0;
    NSString *romanValue = nil;
	
	int arrayCount = [romanCalculationValues count];
	// We need to iterate through all of the roman values
	for (int i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [romanCalculationValues objectAtIndex:i];
		// along with the corresponding arabic value
		NSString *arabicValue = [arabicCalculationValues objectAtIndex:i];
		
		// Search for the roman value from the start of the string
		NSRange suffixRange = [editableString rangeOfString:romanValue
													options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
		// if the length is above 0 then it has been found
		while (suffixRange.length > 0) {
			// so add the corresponding arabic value,
			result = result + [arabicValue intValue];
			// remove the range found from the string
			[editableString replaceCharactersInRange:suffixRange withString: @""];
			// and search again
			suffixRange = [editableString rangeOfString:romanValue
												options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
		}
	}
    
    NSString *greeting = [[NSString alloc] initWithFormat:@"%d", result];
	return greeting;
}

- (NSString *)performConversionToRoman:(NSString *) arabic {
    int arabicLabelValue = [arabic intValue];
	
    NSString *romanValue = nil;
	
	NSMutableString *resultString = [NSMutableString stringWithCapacity:128];
	
	int arrayCount = [romanCalculationValues count];
	// We need to iterate through all of the roman values
	for (int i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [romanCalculationValues objectAtIndex:i];
		// along with the corresponding arabic value
		int arabicValue = [[arabicCalculationValues objectAtIndex:i] intValue];
		
		// Let's div and mod the arabic string
		int div = arabicLabelValue / arabicValue;
		//int mod = arabicLabelValue % arabicValue;
		
		//NSLog(@"Checking: %i", arabicValue);
		//NSLog(@"div: %i", div);
		//NSLog(@"mod: %i", mod);
		
		if (div > 0)
		{
			int j = 0;
			for (j = 0; j < div; j++)
			{
				//NSLog(@"Should add: %@ to string", romanValue);
				[resultString appendFormat: romanValue];
				arabicLabelValue = arabicLabelValue - arabicValue;
			}
			//NSLog(@"String is now: %@", resultString);
		}
	}
    
    NSString *result = [[NSString alloc] initWithFormat:@"%@", resultString];
	
    return result;
}

@end
