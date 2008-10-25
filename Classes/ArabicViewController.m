//
//  ArabicViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "ArabicViewController.h"
#import "Converter.h"

@implementation ArabicViewController

@synthesize romanLabel;
@synthesize arabicLabel;
@synthesize string;
@synthesize converter;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}
*/

- (void)viewDidLoad {
	converter = [[Converter alloc] init];
}

- (void)convertYear {
	[converter convertToRoman:arabicLabel.text];
	if (converter.inputLooksCorrect) {
		NSString *result = converter.romanResult;
		romanLabel.text = result;
		[result release];
	}
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
	[converter release];
	[super dealloc];
}


@end
