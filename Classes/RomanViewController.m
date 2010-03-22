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
}

- (BOOL)canBecomeFirstResponder {
	// needed for shaking detection
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)convertYear:(NSString *)input {
	[converter convertToArabic:input];
	
	//debugLog(@"conversion result is %d", converter.conversionResult);
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

- (void) updateRomanString: (NSString *) text  {
	self.string = romanLabel.text;
	
    NSString *romanLabelString = string;

	if ([text isEqualToString: @"delete"]) {
		if ([romanLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[romanLabelString substringToIndex: [romanLabelString length] - 1]];
			[self convertYear:newInputString];
		}
	}	
	else if ([romanLabelString length] < 14) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", romanLabelString, text];
		[self convertYear:newInputString];
    }
}

- (IBAction)buttonPressed:(id)sender {
    [self updateRomanString: [sender currentTitle]];
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

- (void) clearDisplay {
	/* SHAKE DETECTED. DO HERE WHAT YOU WANT. */
	CABasicAnimation* bloom = [CABasicAnimation animationWithKeyPath:@"opacity"];
	bloom.fromValue = [NSNumber numberWithFloat:0.0];
	bloom.toValue = [NSNumber numberWithFloat:1.0];
	//bloom.repeatCount = 1e100;
	bloom.fillMode = kCAFillModeForwards;
	bloom.autoreverses = YES;
	
	if ([romanLabel.text isEqualToString:@""]) {
		bloom.duration = 0.8;
	} else {
		bloom.delegate = self; // keep the delegate so that we can flip after
		bloom.duration = 0.3;
	}
	bloom.removedOnCompletion = YES;
	[iPhoneImage.layer addAnimation:bloom forKey:@"bloom"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[UIView setAnimationDuration:0.8f];
	
	NSString *newInputString = @"";
	[self convertYear:newInputString];
	
	[UIView commitAnimations];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    debugLog(@"{roman: motion ended event ");
	
    if (motion == UIEventSubtypeMotionShake) {
        debugLog(@"{shaken state ");
		debugLog(@"shook?");
		[self clearDisplay];
    }
    else {
        debugLog(@"{not shaken state ");           
    }
}

// --- copy and paste

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSUInteger numTaps = [[touches anyObject] tapCount];
	
	debugLog(@"number of touches = %d", numTaps);
	
	if (numTaps > 1) {
		UITouch *touch = [touches anyObject];
		
		if ([touch view] == romanLabel) {
			debugLog(@"touched the roman label");
			isTouchingRoman = YES;
		} else if ([touch view] == arabicLabel) {
			debugLog(@"touched the arabic label");
			isTouchingRoman = NO;
		} else {
			debugLog(@"touched something ... but what?");
			return;
		}
		
		debugLog(@"should show copy/paste menu");
		UIMenuController *menu = [UIMenuController sharedMenuController];
		[menu setTargetRect:[touch view].frame inView:self.view];
		[menu setMenuVisible:YES animated:YES];
		
		debugLog(@"menu width %f, visible %d", menu.menuFrame.size.width, menu.menuVisible);
		if ([self isFirstResponder]) {
			debugLog(@"first");
		} else {
			debugLog(@"not first");
			
		}
	}
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
	if ((action == @selector(paste:)) && (isTouchingRoman == YES)) {
		return YES;
	} else if ((action == @selector(copy:)) && (isTouchingRoman == NO)) {
		return YES;
	}
	debugLog(@"menu sender %d", sender);
	return NO;
}

- (void)paste:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	
	if (pasteboard.numberOfItems > 0) {
		debugLog(@"there are %d items in pasteboard", pasteboard.numberOfItems);
		
		[self replaceRomanString:[pasteboard.string copy]];
	}
}

- (void)copy:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	
	pasteboard.string = arabicLabel.text;
	debugLog(@"copying %@ to clipboard", arabicLabel.text);
}

- (void) replaceRomanString: (NSString *) text  {
	self.string = romanLabel.text;
	
	[self convertYear:text];
}

@end
