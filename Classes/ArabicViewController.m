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

- (void)convertYear:(NSString *)input {
	[converter convertToRoman:input];
	
	if (converter.conversionResult == Ignored)
	{
		[UIView beginAnimations:@"movement" context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationRepeatCount:3];
		CGPoint center = arabicLabel.center;
		
		center.x += 10;
		arabicLabel.center = center;
		
		center.x -= 10;
		arabicLabel.center = center;
		
		[UIView commitAnimations];
	} else {
		NSString *result = converter.romanResult;
		romanLabel.text = result;
		[result release];
		
		arabicLabel.text = input;
		[input release];
	}
}

- (IBAction)buttonPressed:(id)sender {
    self.string = arabicLabel.text;
	
    NSString *arabicLabelString = string;

	if ([[sender currentTitle] isEqualToString: @"delete"]) {
		if ([arabicLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[arabicLabelString substringToIndex: [arabicLabelString length] - 1]];
			[self convertYear:newInputString];
		}
	}	
	else if ([arabicLabelString length] < 8) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", arabicLabelString, [sender currentTitle]];
		[self convertYear:newInputString];
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
