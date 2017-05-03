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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


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
    [super viewWillAppear:animated];
    
    self.converter.performConversionCheck = NO;
    
    [self prepareLargeNumbersKey];
    
    [self convertYear:_arabicLabel.text];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];

    [self.tabBarController.navigationItem setTitle:@"Roman Nums"];
    
    userDidSomething = NO;
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
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    
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
    
    if (userDidSomething == NO) {
        NSString *mode = @"None";
        
        if (largeNumberMode == 1) {
            mode = @"Archaic";
        } else if (largeNumberMode == 2) {
            mode = @"Overline";
        }
        
        [Answers logContentViewWithName:@"Arabic to Roman" contentType:nil contentId:nil customAttributes:@{@"Large Numbers": mode}];
        userDidSomething = YES;
    }
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
            [str insertString:@" " atIndex:i];
        
        NSString *stringToBuf =[NSString stringWithString:_romanLabel.text];
        NSMutableArray *buffer = [NSMutableArray arrayWithCapacity:[stringToBuf length]];
        for (int i = 0; i < [stringToBuf length]; i++) {
            [buffer addObject:[NSString stringWithFormat:@"%C", [stringToBuf characterAtIndex:i]]];
        }
        NSString *finalString = [buffer componentsJoinedByString:@" "];
        
        [_romanLabel setAccessibilityValue:finalString];
        
        if ([str isEqualToString:@""]) {
            lockedMode = NO;
            //NSLog(@"unblocking locked mode");
            _buttonArchaic.selected = NO;
        }
        
        if (converter.overlineRomanResult != nil) {
            
            NSMutableString* spacedOverlineResult = [converter.overlineRomanResult mutableCopy];
            /*[spacedOverlineResult enumerateSubstringsInRange:NSMakeRange(0, [spacedOverlineResult length])
                                             options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired
                                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                              if (substringRange.location > 0)
                                                  [spacedOverlineResult insertString:@", overlined. " atIndex:substringRange.location];
                                          }];*/
            
            NSMutableArray *buffer = [NSMutableArray arrayWithCapacity:[spacedOverlineResult length]];
            for (int i = 0; i < [spacedOverlineResult length]; i++) {
                [buffer addObject:[NSString stringWithFormat:@"%C", [spacedOverlineResult characterAtIndex:i]]];
            }
            
            [buffer addObject:@" "];

            NSString *final_string = [buffer componentsJoinedByString:@", overlined. "];

            NSMutableString* spacedNormalResult = [converter.normalRomanResult mutableCopy];
            [spacedNormalResult enumerateSubstringsInRange:NSMakeRange(0, [spacedNormalResult length])
                                                     options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired
                                                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                                      if (substringRange.location > 0)
                                                          [spacedNormalResult insertString:@". " atIndex:substringRange.location];
                                                  }];
            
            // say overline X, overline V
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@ %@", final_string, spacedNormalResult]);
            
            [_romanLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", final_string, spacedNormalResult]];
        } else {
            NSMutableString* spacedNormalResult = [converter.normalRomanResult mutableCopy];
            [spacedNormalResult enumerateSubstringsInRange:NSMakeRange(0, [spacedNormalResult length])
                                                   options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired
                                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                                    if (substringRange.location > 0)
                                                        [spacedNormalResult insertString:@". " atIndex:substringRange.location];
                                                }];
            
            // say overline X, overline V
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", spacedNormalResult]);

            [_romanLabel setAccessibilityValue:[NSString stringWithFormat:@"%@", spacedNormalResult]];
        }
	}
}

- (void) updateArabicString:(NSString *) text  {
	self.string = _arabicLabel.text;
	
    NSString *arabicLabelString = string;
	
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
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
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
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
    
    [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        //NSLog(@"completed: %@", activityType);
        
        if (completed) {
            
            NSString *mode = @"None";
            
            if (largeNumberMode == 1) {
                mode = @"Archaic";
            } else if (largeNumberMode == 2) {
                mode = @"Overline";
            }
            
            [Answers logShareWithMethod:@"Arabic to Roman" contentName:activityType contentType:nil contentId:nil customAttributes:@{@"Large Numbers": mode}];
        }
        //Present another VC
    }];

    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
