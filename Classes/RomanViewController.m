//
//  RomanViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "RomanViewController.h"


@implementation RomanViewController

@synthesize romanLabel;
@synthesize arabicLabel;
@synthesize string;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (void)convertYear {
	
    self.string = romanLabel.text;
	
    NSString *nameString = string;
    if ([nameString length] == 0) {
        nameString = @"2008";
    }

	NSArray *arabicValues = [NSArray arrayWithObjects:
					  @"1000", @"900", @"500", @"400", @"100", @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
	NSArray *romanValues = [NSArray arrayWithObjects:
					   @"m", @"cm", @"d", @"cd", @"c", @"xc", @"l", @"xl", @"x", @"ix", @"v", @"iv", @"i", nil];
	
	NSMutableString *editableString = [NSMutableString stringWithFormat: @"%@", nameString];
	
	int result = 0;
    NSString *romanValue = @"";
	
	int arrayCount = [romanValues count];
    int i = 0;
	// We need to iterate through all of the roman values
	for (i = 0; i < arrayCount; i++)
	{
		// Get the roman value at position i
		romanValue = [romanValues objectAtIndex:i];
		// along with the corresponding arabic value
		NSString *arabicValue = [arabicValues objectAtIndex:i];
		
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
    arabicLabel.text = greeting;
    [greeting release];
}

- (IBAction)buttonPressed:(id)sender {
    self.string = romanLabel.text;
	
    NSString *romanLabelString = string;

	if ([[sender currentTitle] isEqualToString: @"delete"]) {
		if ([romanLabelString length] > 0) {
			NSString *newLabelString = [[NSString alloc] initWithString:[romanLabelString substringToIndex: [romanLabelString length] - 1]];
			romanLabel.text = newLabelString;
			[newLabelString release];
			[self convertYear];
		}
	}	
	else if ([romanLabelString length] < 14) {
		NSString *newLabelString = [[NSString alloc] initWithFormat:@"%@%@", romanLabelString, [sender currentTitle]];
		romanLabel.text = newLabelString;
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
