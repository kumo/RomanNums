//
//  RomanViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "RomanViewController.h"
#import "Converter.h"
#import "UIImage+Colours.h"
#import "RomanNumsActivityItemProvider.h"

@interface RomanViewController ()

@end

@implementation RomanViewController

// @synthesize romanLabel, arabicLabel;

@synthesize converter, string;
@synthesize buttons;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.converter = [[Converter alloc] init];

    // Prepare gestures
    for (UIButton *button in self.buttons) {
        UIGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [button addGestureRecognizer:touchGesture];
        
        [button setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateHighlighted];
    }
    
    UIGestureRecognizer *longTouchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.buttonDelete addGestureRecognizer:longTouchGesture];

    [self.buttonDelete setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // set the keyboard order
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int keyboardType = [[defaults valueForKey:kKeyboardPresentationKey] intValue];
    
    if (keyboardType == 0) {
        [self setButtonTitles:@[@"C", @"D", @"Ⅰ", @"L", @"M", @"V", @"X"]];
    } else if (keyboardType == 1) {
        [self setButtonTitles:@[@"M", @"D", @"C", @"L", @"X", @"V", @"Ⅰ"]];
    } else {
        [self setButtonTitles:@[@"Ⅰ", @"V", @"X", @"L", @"C", @"D", @"M"]];
    }
    
	self.converter.performConversionCheck = [defaults boolForKey:kAutoCorrectKey];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];
    
    [self.tabBarController.navigationItem setTitle:@"Roman to Arabic"];
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *) sender {
    UIButton *button = (UIButton *)sender.view;
    
    [self updateRomanString: [button currentTitle]];
}

- (IBAction)handleLongPressGesture:(UIGestureRecognizer *) sender {
    self.string = @"";
    self.romanLabel.text = @"";
    self.arabicLabel.text = @"";
}

#pragma mark - Conversion methods

- (void)convertYear:(NSString *)input {
	[self.converter convertToArabic:input];
    
	//debugLog(@"conversion result is %d", converter.conversionResult);
	if (self.converter.conversionResult == Ignored)
	{
		[UIView beginAnimations:@"movement" context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationRepeatCount:3];
		CGPoint center = self.romanLabel.center;
		
		center.x += 10;
		self.romanLabel.center = center;
		
		center.x -= 10;
		self.romanLabel.center = center;
		
		[UIView commitAnimations];
	} else if (converter.conversionResult == Converted) {
		NSString *result = self.converter.arabicResult;
		self.arabicLabel.text = result;
		
		[UIView beginAnimations:@"switch" context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.romanLabel cache:YES];
		[UIView setAnimationDuration:0.3f];
		result = self.converter.calculatedRomanValue;
		self.romanLabel.text = result;
		
		[UIView commitAnimations];
        
        [self.arabicLabel setAccessibilityValue:self.arabicLabel.text];
	} else {
		NSString *result = self.converter.arabicResult;
		self.arabicLabel.text = result;
		
		self.romanLabel.text = input;
        [self.arabicLabel setAccessibilityValue:self.arabicLabel.text];
	}
}

- (void)updateRomanString:(NSString *) text  {
	self.string = [self.romanLabel text];
	
    NSString *romanLabelString = self.string;
    
    if (romanLabelString == Nil) {
        romanLabelString = @"";
    }
    
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

#pragma mark - UI methods

- (void)setButtonTitles:(NSArray *)titles {
    for (int i=0; i<7; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:5001 + i];
        NSString *title = [titles objectAtIndex:i];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
}

- (IBAction)shareButton:(id)sender {
    // Show different text for each service, see http://www.albertopasca.it/whiletrue/2012/10/objective-c-custom-uiactivityviewcontroller-icons-text/
    RomanNumsActivityItemProvider *activityItemProvider = [[RomanNumsActivityItemProvider alloc] initWithRomanText:self.romanLabel.text arabicText:self.arabicLabel.text romanToArabic:YES];
    
    NSArray *itemsToShare = @[activityItemProvider];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
