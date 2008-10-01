//
//  ArabicViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "ArabicViewController.h"


@implementation ArabicViewController

@synthesize romanLabel;
@synthesize arabicLabel;
@synthesize string;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}
*/

- (void)convertYear {
	
    self.string = arabicLabel.text;
	
    int arabicLabelValue = [string intValue];

	NSArray *arabicValues = [NSArray arrayWithObjects:
					  @"1000", @"900", @"500", @"400", @"100", @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
	NSArray *romanValues = [NSArray arrayWithObjects:
					   @"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I", nil];
	
    NSString *romanValue = @"";

	NSMutableString *resultString = [NSMutableString stringWithCapacity:128];

	NSMutableString *str = [NSMutableString stringWithCapacity:128];
	[str appendString: @" made longer"];
	NSLog(@"String is now: %@", str);
	
	int arrayCount = [romanValues count];
    int i = 0;
	// We need to iterate through all of the roman values
	for (i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [romanValues objectAtIndex:i];
		// along with the corresponding arabic value
		int arabicValue = [[arabicValues objectAtIndex:i] intValue];
		
		// Let's div and mod the arabic string
		int div = arabicLabelValue / arabicValue;
		int mod = arabicLabelValue % arabicValue;
		
		NSLog(@"Checking: %i", arabicValue);
		NSLog(@"div: %i", div);
		NSLog(@"mod: %i", mod);
		
		if (div > 0)
		{
			int j = 0;
			for (j = 0; j < div; j++)
			{
				NSLog(@"Should add: %@ to string", romanValue);
				[resultString appendFormat: romanValue];
				arabicLabelValue = arabicLabelValue - arabicValue;
			}
			NSLog(@"String is now: %@", resultString);
		}
	}
    
    NSString *romanResult = [[NSString alloc] initWithFormat:@"%@", resultString];
    romanLabel.text = romanResult;
    [romanResult release];
}

- (IBAction)buttonPressed:(id)sender {
    self.string = arabicLabel.text;
	
    NSString *arabicLabelString = string;

	if ([[sender currentTitle] isEqualToString: @"delete"]) {
		if ([arabicLabelString length] > 0) {
			NSString *newLabelString = [[NSString alloc] initWithString:[arabicLabelString substringToIndex: [arabicLabelString length] - 1]];
			arabicLabel.text = newLabelString;
			[newLabelString release];
			[self convertYear];
		}
	}	
	else if ([arabicLabelString length] < 4) {
		NSString *newLabelString = [[NSString alloc] initWithFormat:@"%@%@", arabicLabelString, [sender currentTitle]];
		arabicLabel.text = newLabelString;
		[newLabelString release];
		[self convertYear];
    }
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [romanLabel release];
    [arabicLabel release];
    [string release];
	[super dealloc];
}


@end
