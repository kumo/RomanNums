//
//  ArabicViewController.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import "ArabicViewController.h"
#import "Converter.h"
#import "QuartzCore/QuartzCore.h"

@implementation ArabicViewController

@synthesize romanLabel, arabicLabel, archaicButton, iPhoneImage;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	// needed for shaking detection
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
	// needed for shaking detection
	return YES;
}

- (void)convertYear:(NSString *)input {
	[converter convertToRoman:input archaic:archaicMode];
	
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
	else if ([arabicLabelString length] < 6) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", arabicLabelString, [sender currentTitle]];
		[self convertYear:newInputString];
    }
}

- (IBAction)archaicButtonPressed:(id)sender {
	archaicMode = !archaicMode;
	
	archaicButton.selected = archaicMode;
	
	NSString *arabicLabelCopy = [[NSString alloc] initWithString:arabicLabel.text];
	[self convertYear: arabicLabelCopy];
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

	if ([arabicLabel.text isEqualToString:@""]) {
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
	
    NSLog(@"{arabic: motion ended event ");
	
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"{shaken state ");
		NSLog(@"shook?");
		[self clearDisplay];
    }
    else {
        NSLog(@"{not shaken state ");           
    }
}

@end
