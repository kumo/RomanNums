//
//  RomanViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "RomanViewController.h"
#import "Converter.h"
#import "QuartzCore/QuartzCore.h"

@implementation RomanViewController

@synthesize romanLabel, arabicLabel;
@synthesize buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven;
@synthesize string;
@synthesize converter;
@synthesize lastAcceleration;
@synthesize iPhoneImage;

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

	[UIAccelerometer sharedAccelerometer].delegate = self;
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
		[result release];
		
		[input release];
		[UIView commitAnimations];
	} else {
		NSString *result = converter.arabicResult;
		arabicLabel.text = result;
		[result release];
		
		romanLabel.text = input;
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

// Ensures the shake is strong enough on at least two axes before declaring it a shake.
// "Strong enough" means "greater than a client-supplied threshold" in G's.
static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	if (self.lastAcceleration) {
		if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.9)) {
			histeresisExcited = YES;
			
			/* SHAKE DETECTED. DO HERE WHAT YOU WANT. */
			NSLog(@"shaking detected");
			NSString *newInputString = @"";
			[self convertYear:newInputString];
			
			CABasicAnimation* bloom = [CABasicAnimation animationWithKeyPath:@"opacity"];
			bloom.fromValue = [NSNumber numberWithFloat:0.0];
			bloom.toValue = [NSNumber numberWithFloat:1.0];
			bloom.duration = 0.2;
			bloom.autoreverses = NO;
			//bloom.repeatCount = 1e100;
			bloom.delegate = self;
			bloom.fillMode = kCAFillModeForwards;
			bloom.removedOnCompletion = NO;
			[iPhoneImage.layer addAnimation:bloom forKey:@"bloom"];			
			
		} else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
			histeresisExcited = NO;

			CABasicAnimation* bloom = [CABasicAnimation animationWithKeyPath:@"opacity"];
			bloom.fromValue = [NSNumber numberWithFloat:1.0];
			bloom.toValue = [NSNumber numberWithFloat:0.0];
			bloom.duration = 0.8;
			bloom.autoreverses = NO;
			//bloom.repeatCount = 1e100;
			bloom.delegate = self;
			bloom.fillMode = kCAFillModeForwards;
			bloom.removedOnCompletion = NO;
			[iPhoneImage.layer addAnimation:bloom forKey:@"bloom"];			
			
		}
	}
	
	self.lastAcceleration = acceleration;
}

@end
