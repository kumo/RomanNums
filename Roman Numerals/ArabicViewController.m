//
//  ArabicViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "ArabicViewController.h"
#import "Converter.h"

@interface ArabicViewController ()

@end

@implementation ArabicViewController

// @synthesize romanLabel, arabicLabel;
// @synthesize buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven, buttonDelete;

@synthesize converter, string;
@synthesize buttons;

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.converter = [[Converter alloc] init];

    UIColor *darkHighlightColour = [UIColor colorWithRed:0.754 green:0.759 blue:0.799 alpha:1.000];
    UIColor *lightHighlightColour = [UIColor colorWithRed:0.969 green:0.969 blue:0.973 alpha:1.000];

    // Prepare gestures
    for (UIButton *button in self.buttons) {
        UIGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [button addGestureRecognizer:touchGesture];

        [button setBackgroundImage:[ArabicViewController imageWithColor:darkHighlightColour] forState:UIControlStateHighlighted];
    }
    
    UIGestureRecognizer *longTouchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.buttonDelete addGestureRecognizer:longTouchGesture];

    [self.buttonDelete setBackgroundImage:[ArabicViewController imageWithColor:lightHighlightColour] forState:UIControlStateHighlighted];
    
    archaicMode = NO;
    lockedMode = NO;
    [self prepareLargeNumbersKey];
    [self.buttonArchaic setBackgroundImage:[ArabicViewController imageWithColor:darkHighlightColour] forState:UIControlStateHighlighted];
    [self.buttonArchaic setBackgroundImage:[ArabicViewController imageWithColor:darkHighlightColour] forState:UIControlStateSelected];
    [self.buttonArchaic setBackgroundImage:[ArabicViewController imageWithColor:lightHighlightColour] forState:UIControlStateNormal];

    [self.buttonArchaic setHighlighted:archaicMode];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.converter.performConversionCheck = NO;
    
    [self prepareLargeNumbersKey];
    
    [self convertYear:_arabicLabel.text];
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
    [self updateArabicString: [button currentTitle]];
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
    
    UIColor *darkHighlightColour = [UIColor colorWithRed:0.754 green:0.759 blue:0.799 alpha:1.000];
    UIColor *lightHighlightColour = [UIColor colorWithRed:0.969 green:0.969 blue:0.973 alpha:1.000];
    
    if (archaicMode) {
        [_buttonArchaic setBackgroundColor:darkHighlightColour];
        [_buttonArchaic setBackgroundImage:[ArabicViewController imageWithColor:lightHighlightColour] forState:UIControlStateHighlighted];
    } else {
        [_buttonArchaic setBackgroundColor:lightHighlightColour];
        [_buttonArchaic setBackgroundImage:[ArabicViewController imageWithColor:darkHighlightColour] forState:UIControlStateHighlighted];
    }
    
    [self prepareLargeNumbersKey];
}

- (IBAction)shareButton:(id)sender {
    // TODO: show the share composer
    NSString *textToShare = [NSString stringWithFormat:@"%@=%@", self.arabicLabel.text, self.romanLabel.text];
    NSArray *itemsToShare = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
