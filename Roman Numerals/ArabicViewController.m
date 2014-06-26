//
//  ArabicViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "ArabicViewController.h"
#import "Converter.h"
#import "UIImage+Colours.h"
#import "RomanNumsActivityItemProvider.h"

@interface ArabicViewController ()

@end

@implementation ArabicViewController

// @synthesize romanLabel, arabicLabel;
// @synthesize buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven, buttonDelete;

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
    
    archaicMode = NO;
    lockedMode = NO;
    [self prepareLargeNumbersKey];
    [self.buttonArchaic setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateHighlighted];
    [self.buttonArchaic setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateSelected];
    [self.buttonArchaic setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateNormal];

    [self.buttonArchaic setHighlighted:archaicMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.converter.performConversionCheck = NO;
    
    [self prepareLargeNumbersKey];
    
    [self convertYear:_arabicLabel.text];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];

    [self.tabBarController.navigationItem setTitle:@"Roman Nums"];
}

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        _arabicLabel.center = CGPointMake(_arabicLabel.center.x, _arabicLabel.center.y + 40);
        _romanLabel.center = CGPointMake(_romanLabel.center.x, _romanLabel.center.y + 40);
    }
}

- (void)prepareLargeNumbersKey
{
    // set the keyboard order
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    largeNumberMode = [[defaults valueForKey:kLargeNumberPresentationKey] intValue];
    
    if (largeNumberMode == 0) {
        [self.buttonArchaic setTitle:@"MM" forState:UIControlStateNormal];
        [self.buttonArchaic setTitle:@"MM" forState:UIControlStateSelected];
        [self.buttonArchaic setTitle:@"MM" forState:UIControlStateHighlighted];
    } else if (largeNumberMode == 1) {
        [self.buttonArchaic setTitle:@"ↀↀ" forState:UIControlStateNormal];
        [self.buttonArchaic setTitle:@"ↀↀ" forState:UIControlStateSelected];
        [self.buttonArchaic setTitle:@"ↀↀ" forState:UIControlStateHighlighted];
    } else {
        [self.buttonArchaic setTitle:@"Ⅱ̅" forState:UIControlStateNormal];
        [self.buttonArchaic setTitle:@"Ⅱ̅" forState:UIControlStateSelected];
        [self.buttonArchaic setTitle:@"Ⅱ̅" forState:UIControlStateHighlighted];
    }

    self.buttonArchaic.selected = archaicMode;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *) sender {
    UIButton *button = (UIButton *)sender.view;
    
    //NSLog(@"tapped %@", [button currentTitle]);
    
    //NSLog(@"Before conversion, roman: %@, arabic: %@", _romanLabel.text, _arabicLabel.text);
    if (button.tag == -99) {
        [self updateArabicString: @"delete"];
    } else {
        [self updateArabicString: [button currentTitle]];
    }
}

- (IBAction)handleLongPressGesture:(id)sender {
    //NSLog(@"long pressing delete");
    self.string = @"";
    _romanLabel.text = @"";
    _arabicLabel.text = @"";
}

- (void)convertYear:(NSString *)input {
	[converter convertToRoman:input archaic:archaicMode];
	
	if (converter.conversionResult == Ignored)
	{
		[UIView beginAnimations:@"movement" context:nil];
		[UIView setAnimationDuration:0.1f];
		[UIView setAnimationRepeatCount:3];
		CGPoint center = _arabicLabel.center;
		
		center.x += 10;
		_arabicLabel.center = center;
		
		center.x -= 10;
		_arabicLabel.center = center;
		
		[UIView commitAnimations];
	} else {
		NSString *result = converter.romanResult;
		_romanLabel.text = result;
		
		_arabicLabel.text = input;
        
        NSMutableString *str = [NSMutableString stringWithString:_romanLabel.text];
        for (NSInteger i=1; i<[str length]; i+=3)
            [str insertString:@". " atIndex:i];
        [_romanLabel setAccessibilityValue:str];
        
        if ([str isEqualToString:@""]) {
            lockedMode = NO;
            //NSLog(@"unblocking locked mode");
            _buttonArchaic.selected = NO;
        }
        
	}
}

- (void) updateArabicString:(NSString *) text  {
	self.string = _arabicLabel.text;
	
    NSString *arabicLabelString = string;
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL autoSwitch = [defaults boolForKey:kAutoSwitchKey];

	if ([text isEqualToString: @"delete"]) {
		if ([arabicLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[arabicLabelString substringToIndex: [arabicLabelString length] - 1]];
            
            if ((autoSwitch == YES) && (lockedMode == NO)) {
                int arabicLabelValue = [newInputString intValue];
            
                if (arabicLabelValue > 3999) {
                    archaicMode = YES;
                } else {
                    archaicMode = NO;
                }
            
                _buttonArchaic.selected = archaicMode;
            }
            

			[self convertYear:newInputString];
		}
	}
	else if ([arabicLabelString length] < 6) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", arabicLabelString, text];
        
        if ((autoSwitch == YES) && (lockedMode == NO)) {
            int arabicLabelValue = [newInputString intValue];
            
            if (arabicLabelValue > 3999) {
                archaicMode = YES;
            } else {
                archaicMode = NO;
            }
            
            _buttonArchaic.selected = archaicMode;
        }
        
		[self convertYear:newInputString];
    }
}

- (IBAction)archaicButtonPressed:(id)sender {
	archaicMode = !archaicMode;
    
    // if the button is what we expect it to be then it is not locked
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL autoSwitch = [defaults boolForKey:kAutoSwitchKey];
    BOOL potentialArchaicMode = NO;
    
    if (autoSwitch == YES) {
        int arabicLabelValue = [_arabicLabel.text intValue];
        
        if (arabicLabelValue > 3999) {
            potentialArchaicMode = YES;
        } else {
            potentialArchaicMode = NO;
        }
        
        if (potentialArchaicMode == archaicMode) {
            lockedMode = NO;
            //NSLog(@"archaid mode is NOT locked");
        } else {
            lockedMode = YES;
            //NSLog(@"archaid mode IS locked");
        }
    } else {
        lockedMode = YES;
    }
	
	_buttonArchaic.selected = archaicMode;
	
	NSString *arabicLabelCopy = [[NSString alloc] initWithString:_arabicLabel.text];
	[self convertYear: arabicLabelCopy];
    
    if (archaicMode) {
        [_buttonArchaic setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateHighlighted];
    } else {
        [_buttonArchaic setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateHighlighted];
    }
    
    [self prepareLargeNumbersKey];
}

- (IBAction)shareButton:(id)sender {
    // Show different text for each service, see http://www.albertopasca.it/whiletrue/2012/10/objective-c-custom-uiactivityviewcontroller-icons-text/
    RomanNumsActivityItemProvider *activityItemProvider = [[RomanNumsActivityItemProvider alloc] initWithRomanText:self.romanLabel.text arabicText:self.arabicLabel.text romanToArabic:NO];
    
    if ([self.romanLabel.text isEqualToString:@""]) {
        return;
    }

    NSArray *itemsToShare = @[activityItemProvider];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
