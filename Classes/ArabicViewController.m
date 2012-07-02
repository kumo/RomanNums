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
#import "ContactMenu_iPhone.h"

@implementation ArabicViewController

@synthesize romanLabel, arabicLabel, archaicButton, buttonDelete, iPhoneImage;
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

- (IBAction)showInfo:(id)sender {
    ContactMenu_iPhone *myViewController = [[ContactMenu_iPhone alloc] initWithNibName:@"ContactMenu_iPhone" bundle:nil];
    
    [self presentModalViewController:myViewController animated:YES];
    [myViewController release];
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
        
        NSMutableString *str = [NSMutableString stringWithString:romanLabel.text];
        for (NSInteger i=1; i<[str length]; i+=3)
            [str insertString:@". " atIndex:i];
        [romanLabel setAccessibilityValue:str];

	}
}

- (IBAction)buttonPressed:(id)sender {
	if (isTouchingDelete == YES) {
		debugLog(@"invalidating delete timer");
		if (deleteTimer != nil) {
			[deleteTimer invalidate];
			deleteTimer = nil;
		}
	}
	
    [self updateArabicString:[sender currentTitle]];
}

- (void) updateArabicString:(NSString *) text  {
	self.string = arabicLabel.text;
	
    NSString *arabicLabelString = string;
	
	if ([text isEqualToString: @"delete"]) {
		if ([arabicLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[arabicLabelString substringToIndex: [arabicLabelString length] - 1]];
			[self convertYear:newInputString];
		}
	}	
	else if ([arabicLabelString length] < 6) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", arabicLabelString, text];
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
	
    debugLog(@"{arabic: motion ended event ");
	
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

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if ((action == @selector(paste:)) && (isTouchingRoman == NO)) {
		return YES;
	} else if ((action == @selector(copy:)) && (isTouchingRoman == YES)) {
		return YES;
	}
	//debugLog(@"menu sender %d", sender);
	return NO;
}

- (void)paste:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	
	if (pasteboard.numberOfItems > 0) {
		debugLog(@"there are %d items in pasteboard", pasteboard.numberOfItems);
		
		[self replaceArabicString:[pasteboard.string copy]];
	}
}

- (void)copy:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	
	pasteboard.string = romanLabel.text;
	debugLog(@"copying %@ to clipboard", romanLabel.text);
}


- (void)replaceArabicString:(NSString *)text {
	self.string = arabicLabel.text;
	
	[self convertYear:text];
}

// --- delete repeat

- (IBAction)deleteButtonStartPressed:(id)sender {
	isTouchingDelete = YES;
	deleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(startDeleteTrigger:) userInfo:nil repeats:NO];
	debugLog(@"starting delete timer");
}

- (void)startDeleteTrigger:(NSTimer *) timer {
	[deleteTimer invalidate];
	
	deleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(triggerDelete:) userInfo:nil repeats:YES];
}

- (void)triggerDelete:(NSTimer *) timer {
	debugLog(@"deleting char");
	[self updateArabicString:@"delete"];
}

@end
