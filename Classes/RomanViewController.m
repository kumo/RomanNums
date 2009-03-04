//
//  RomanViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "RomanViewController.h"
#import "Converter.h"

@implementation RomanViewController

@synthesize romanLabel, arabicLabel, webView;
@synthesize buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven;
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

- (void)setButtonTitles:(NSArray *)titles {
	NSArray *buttons = [NSArray arrayWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven, nil];
	
	for (int i=0; i<7; i++) {
		UIButton *button = [buttons objectAtIndex:i];
		NSString *title = [titles objectAtIndex:i];
		
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitle:title forState:UIControlStateHighlighted];
	}
		
}

- (void)viewDidLoad {
	// set the keyboard order
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *keyboardType = [defaults stringForKey:@"keyboard_type"];
	
	if ([keyboardType isEqualToString:@"numeric_smallest"])
	{
		[self setButtonTitles:[NSArray arrayWithObjects:
							   @"I", @"V", @"X", @"L", @"C", @"D", @"M", nil]];
	} else if ([keyboardType isEqualToString:@"numeric_largest"]) {
		[self setButtonTitles:[NSArray arrayWithObjects:
							   @"M", @"D", @"C", @"L", @"X", @"V", @"I", nil]];
	} else {
		[self setButtonTitles:[NSArray arrayWithObjects:
							   @"C", @"D", @"I", @"L", @"M", @"V", @"X", nil]];
	}
	
	// setup converter
	converter = [[Converter alloc] init];
	BOOL autocorrection = [defaults boolForKey:@"correction"];
	converter.performConversionCheck = autocorrection;
}

- (void)convertYear:(NSString *)input {
	[converter convertToArabic:input];
	
	NSLog(@"conversion result is %d", converter.conversionResult);
	if (converter.conversionResult == Ignored)
	{
		[UIView beginAnimations:@"movement" context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationRepeatCount:3];
		CGPoint center = romanLabel.center;
		
		center.x += 10;
		romanLabel.center = center;
		
		center.x -= 10;
		romanLabel.center = center;
		
		[UIView commitAnimations];
	} else if (converter.conversionResult == Converted) {
		NSString *result = converter.arabicResult;
		arabicLabel.text = result;
		[result release];
		
		[UIView beginAnimations:@"switch" context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:romanLabel cache:YES];
		[UIView setAnimationDuration:0.3f];
		result = converter.calculatedRomanValue;
		romanLabel.text = result;

		NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>body, html {font-weight: bold; font-family: helvetica; font-size: 55pt;} div {line-height: 38px; position: absolute; top: 0px;}</style></head><body style='background-color: transparent'><font size='130px'><span style='text-decoration: none; border-top: 5px solid black;'>%@</span></font></body></html>", result];
		[webView loadHTMLString:htmlString baseURL:nil];
		
		[result release];
		
		[input release];
		[UIView commitAnimations];
	} else {
		NSString *result = converter.arabicResult;
		arabicLabel.text = result;
		[result release];
		
		romanLabel.text = input;

		NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>body, html {font-weight: bold; font-family: helvetica; font-size: 55pt;} div {line-height: 38px; position: absolute; top: 0px;}</style></head><body style='background-color: transparent'><font size='130px'><span style='text-decoration: none; border-top: 5px solid black;'>%@</span></font></body></html>", input];
		[webView loadHTMLString:htmlString baseURL:nil];
		
		[input release];
	}
}

- (IBAction)buttonPressed:(id)sender {
    self.string = romanLabel.text;
	
    NSString *romanLabelString = string;
	
	if ([[sender currentTitle] isEqualToString: @"delete"]) {
		if ([romanLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[romanLabelString substringToIndex: [romanLabelString length] - 1]];
			[self convertYear:newInputString];
		}
	}	
	else if ([romanLabelString length] < 14) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", romanLabelString, [sender currentTitle]];
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
