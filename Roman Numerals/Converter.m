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

- (id)init
{
	self = [super init];
	self.romanCalculationValues = [NSArray arrayWithObjects:
								   @"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I", nil];
    self.arabicCalculationValues = [NSArray arrayWithObjects:
                                    @"1000", @"900", @"500", @"400", @"100", @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
	self.performConversionCheck = NO;
	self.conversionResult = Valid; // used if no conversion check
	return self;
}

- (void)convertToArabic:(NSString *) roman {
	arabicResult = [self performConversionToArabic:roman];
 	if (performConversionCheck) {
		calculatedRomanValue = [self performConversionToRoman:arabicResult];
        
		//debugLog(@"Roman given is %@ and roman calculated is %@", roman, calculatedRomanValue);
        
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
	}
}

- (void)convertToRoman:(NSString *) arabic archaic:(bool) archaic {
	if (archaic == YES) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int largeNumberMode = [[defaults valueForKey:kLargeNumberPresentationKey] intValue];

        if (largeNumberMode == 2) {
            romanResult = [self performOverlineConversionToRoman:arabic];
        } else {
            romanResult = [self performOldConversionToRoman:arabic];
        }
	} else {
		romanResult = [self performConversionToRoman:arabic];
	}
	
	if (performConversionCheck) {
		calculatedArabicValue = [self performConversionToArabic:romanResult];
		
		//debugLog(@"Arabic given is %@ and arabic calculated is %@", arabic, calculatedArabicValue);
        
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
	int i;
	for (i = 0; i < arrayCount; i++)
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
    
	NSString *greeting;
	if (result == 0) {
		greeting = @"";
	} else {
		greeting = [[NSString alloc] initWithFormat:@"%d", result];
	}
	
	return greeting;
}

- (NSString *)performConversionToRoman:(NSString *) arabic {
    int arabicLabelValue = [arabic intValue];
	
    NSArray *romanCharacterCalculationValues = [NSArray arrayWithObjects:
                                            @"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"ⅠX", @"V", @"ⅠV", @"Ⅰ", nil];

    NSString *romanValue = nil;
	
	NSMutableString *resultString = [NSMutableString stringWithCapacity:128];
	
	int arrayCount = [romanCalculationValues count];
	// We need to iterate through all of the roman values
	int i;
	for (i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [romanCharacterCalculationValues objectAtIndex:i];
		// along with the corresponding arabic value
		int arabicValue = [[arabicCalculationValues objectAtIndex:i] intValue];
		
		// Let's div and mod the arabic string
		int div = arabicLabelValue / arabicValue;
		//int mod = arabicLabelValue % arabicValue;
		
		//debugLog(@"Checking: %i", arabicValue);
		//debugLog(@"div: %i", div);
		//debugLog(@"mod: %i", mod);
		
		if (div > 0)
		{
			int j = 0;
			for (j = 0; j < div; j++)
			{
				//debugLog(@"Should add: %@ to string", romanValue);
				[resultString appendFormat: romanValue];
				arabicLabelValue = arabicLabelValue - arabicValue;
			}
			//debugLog(@"String is now: %@", resultString);
		}
	}
    
    NSString *result = [[NSString alloc] initWithFormat:@"%@", resultString];
	
    return result;
}

- (NSString *)performOverlineConversionToRoman:(NSString *) arabic {
    // Steps:
    //   - is the number over 999? If so get the thousands and add bars on top
    //   - calculate less than 1000
    //   - combine the two together
    
    int arabicLabelValue = [arabic intValue];
    NSString *overlineRoman = nil;
    NSString *normalRoman = nil;
    
    if (arabicLabelValue < 1000) {
        normalRoman = [self performConversionToRoman:arabic];
        return normalRoman;
    } else {
        int normalArabic = arabicLabelValue % 1000;
        normalRoman = [self performConversionToRoman:[NSString stringWithFormat:@"%d", normalArabic]];

        int overlineArabic = (arabicLabelValue - normalArabic) / 1000;
        overlineRoman = [self performConversionToRoman:[NSString stringWithFormat:@"%d", overlineArabic]];
        
        // FIXME: implement a faster method or that also draws a single line
        NSString *convertedOverline = @"";
        for (int i=0; i<[overlineRoman length]; i++) {
            unichar character = [overlineRoman characterAtIndex:i];
            
            convertedOverline = [NSString stringWithFormat:@"%@%@%@", convertedOverline, [NSString stringWithCharacters:&character length:1], @"\u0304"];
            
        }
        
        return [NSString stringWithFormat:@"%@  %@", convertedOverline, normalRoman];
    }
}

- (NSString *)performOldConversionToRoman:(NSString *) arabic {
	NSArray *largeRomanCalculationValues = [NSArray arrayWithObjects:
                                            @"CCCCCIↃↃↃↃↃ CCCCCCIↃↃↃↃↃↃↃ ", @"IↃↃↃↃↃↃ ", @"CCCCCIↃↃↃↃↃ IↃↃↃↃↃↃ ", @"CCCCCIↃↃↃↃↃ ",
                                            @"CCCCIↃↃↃↃ CCCCCIↃↃↃↃↃ ", @"IↃↃↃↃↃ ", @"CCCCIↃↃↃↃ IↃↃↃↃↃ ", @"CCCCIↃↃↃↃ ",
                                            @"CCCIↃↃↃ CCCCIↃↃↃↃ ", @"IↃↃↃↃ ", @"CCCIↃↃↃ IↃↃↃↃ ", @"CCCIↃↃↃ ",
                                            @"ↂ CCCIↃↃↃ ", @"IↃↃↃ ", @"ↂ IↃↃↃ ", @"ↂ ",
                                            @"ↀ ↂ ", @"ↀ ↀ ↂ ", @"ↁ ", @"ↀ ↁ ", @"ↀ ",
                                            @"C ↀ ", @"Ⅾ ", @"C Ⅾ ", @"C",
                                            @"ⅩC", @"Ⅼ", @"ⅩⅬ", @"Ⅹ", @"Ⅸ", @"V", @"Ⅳ", @"Ⅰ", nil];
	NSArray *largeArabicCalculationValues = [NSArray arrayWithObjects:
                                             @"90000000", @"50000000", @"40000000", @"10000000",
                                             @"9000000", @"5000000", @"4000000", @"1000000",
                                             @"900000", @"500000", @"400000", @"100000",
                                             @"90000", @"50000", @"40000", @"10000",
                                             @"9000", @"8000", @"5000", @"4000", @"1000",
                                             @"900", @"500", @"400", @"100",
                                             @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
    
    int arabicLabelValue = [arabic intValue];
	
    NSString *romanValue = nil;
	
	NSMutableString *resultString = [NSMutableString stringWithCapacity:128];
	
	int arrayCount = [largeRomanCalculationValues count];
	// We need to iterate through all of the roman values
	int i;
	for (i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [largeRomanCalculationValues objectAtIndex:i];
		// along with the corresponding arabic value
		int arabicValue = [[largeArabicCalculationValues objectAtIndex:i] intValue];
		
		// Let's div and mod the arabic string
		int div = arabicLabelValue / arabicValue;
		//int mod = arabicLabelValue % arabicValue;
		
		//debugLog(@"Checking: %i", arabicValue);
		//debugLog(@"div: %i", div);
		//debugLog(@"mod: %i", mod);
		
		if (div > 0)
		{
			int j = 0;
			for (j = 0; j < div; j++)
			{
				//debugLog(@"Should add: %@ to string", romanValue);
				[resultString appendFormat: romanValue];
				arabicLabelValue = arabicLabelValue - arabicValue;
			}
			//debugLog(@"String is now: %@", resultString);
		}
	}
    
	NSString *result;
	
	// strip any final spaces from the result string
	if ([resultString length] > 0) {
		if ([[resultString substringFromIndex: [resultString length] - 1] isEqualToString:@" "]) {
			result = @"";
            
			if ([resultString length] > 1) {
				result = [[NSString alloc] initWithString:[resultString substringToIndex: [resultString length] - 1]];
			}
		} else {
			result = [[NSString alloc] initWithFormat:@"%@", resultString];
		}
	} else {
		result = @"";
	}
	
	return result;
}


- (NSString *)performOldConversionToArabic:(NSString *) roman {
	return @"";
}


@end
