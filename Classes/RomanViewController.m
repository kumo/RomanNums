//
//  RomanViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "RomanViewController.h"


@implementation RomanViewController

@synthesize textField;
@synthesize label;
@synthesize string;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (IBAction)convertYear:(id)sender {
	
    self.string = textField.text;
	
    NSString *nameString = string;
    if ([nameString length] == 0) {
        nameString = @"2008";
    }
	int length = [nameString length];
	
    NSString *romanValue = @"";
	NSArray *arabicValues = [NSArray arrayWithObjects:
					  @"1000", @"900", @"500", @"400", @"100", @"90", @"50", @"40", @"10", @"9", @"5", @"4", @"1", nil];
	NSArray *romanValues = [NSArray arrayWithObjects:
					   @"m", @"cm", @"d", @"cd", @"c", @"xc", @"l", @"xl", @"x", @"ix", @"v", @"iv", @"i", nil];
	
	NSMutableString *editableString = [NSMutableString stringWithFormat: @"%@", nameString];
	
	int result = 0;
	int arrayCount = [romanValues count];
    int i = 0;
	for (i = 0; i < arrayCount; i++)
	{
		romanValue = [romanValues objectAtIndex:i];
		NSString *arabicValue = [arabicValues objectAtIndex:i];
		
		while ([editableString rangeOfString:romanValue
									 options:(NSCaseInsensitiveSearch)].length > 0) {
		NSRange suffixRange = [editableString rangeOfString:romanValue
										   options:(NSCaseInsensitiveSearch)];
		
		if (suffixRange.length > 0) {
			result = result + [arabicValue intValue];
			[editableString replaceCharactersInRange:suffixRange withString: @""];
		}
		}
	}
    
   /* for (i = 0; i < itemCount; i++)
    {
        itemValue = [[values objectAtIndex:i] intValue];
        
        while (deflate >= itemValue)
        {
            romanValue = [romanValue stringByAppendingString:[pairs objectForKey:[values objectAtIndex:i]]];
            deflate -= itemValue;
        }
    }*/
    
    NSString *greeting = [[NSString alloc] initWithFormat:@"The year is %@ [%d chars]! (%d)", nameString, length, result];
    label.text = greeting;
    [greeting release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == textField) {
        [textField resignFirstResponder];
    }
    return YES;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
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
    [textField release];
    [label release];
    [string release];
	[super dealloc];
}


@end
