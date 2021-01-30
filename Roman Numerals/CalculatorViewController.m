//
//  CalculatorViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 26/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "CalculatorViewController.h"
#import "Converter.h"
#import "UIImage+Colours.h"
#import "RomanNumsActivityItemProvider.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

@synthesize string, formula, shouldClearDisplay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*NSString *formula = @"10-3*3+10/2";
    
    NSExpression *expression = [NSExpression expressionWithFormat:formula];
    
    int result = [[expression expressionValueWithObject:nil context:nil] intValue];
    NSLog(@"%d", result);*/
    
    self.converter = [[Converter alloc] init];
    
    [self prepareGestures];

    self.formula = @"";
    self.shouldClearDisplay = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // set the keyboard order
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    int keyboardType = [[defaults valueForKey:kKeyboardPresentationKey] intValue];
    
    if (keyboardType == 0) {
        [self setButtonTitles:@[@"C", @"D", @"Ⅰ", @"L", @"M", @"V", @"X"]];
    } else if (keyboardType == 1) {
        [self setButtonTitles:@[@"M", @"D", @"C", @"L", @"X", @"V", @"Ⅰ"]];
    } else {
        [self setButtonTitles:@[@"Ⅰ", @"V", @"X", @"L", @"C", @"D", @"M"]];
    }
    
	self.converter.performConversionCheck = [defaults boolForKey:kAutoCorrectKey];

    archaicMode = NO;
    /*int largeNumberMode = [[defaults valueForKey:kLargeNumberPresentationKey] intValue];
    
    if (largeNumberMode > 0)
        archaicMode = YES;
    else
        archaicMode = NO;*/
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];

    [self.tabBarController.navigationItem setTitle:@"Calculator"];
    
    userDidSomething = NO;
}

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


- (void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        _arabicLabel.center = CGPointMake(_arabicLabel.center.x, _arabicLabel.center.y + 30);
        _romanLabel.center = CGPointMake(_romanLabel.center.x, _romanLabel.center.y + 30);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *) sender {
    UIButton *button = (UIButton *)sender.view;
    
    if (userDidSomething == NO) {
//        [Answers logContentViewWithName:@"Calculator" contentType:nil contentId:nil customAttributes:nil];
        userDidSomething = YES;
    }
    
    if (button.tag == -99) {
        [self updateRomanString: @"delete"];
    } else {
        [self updateRomanString: [button currentTitle]];
    }
}

- (IBAction)handleLongPressGesture:(UIGestureRecognizer *) sender {
    self.string = @"";
    self.romanLabel.text = @"";
    self.arabicLabel.text = @"";
}

- (IBAction)operatorAction:(id)sender {
    NSUInteger nextOperator = ((UIButton *)sender).tag - 9000;
    
    if (userDidSomething == NO) {
//        [Answers logContentViewWithName:@"Calculator" contentType:nil contentId:nil customAttributes:nil];
        userDidSomething = YES;
    }

    if (currentOperator == 1)
        formula = [NSString stringWithFormat:@"%@+",formula];
    else if (currentOperator == 2)
        formula = [NSString stringWithFormat:@"%@-",formula];
    else if (currentOperator == 3)
        formula = [NSString stringWithFormat:@"%@*",formula];
    else if (currentOperator == 4)
        formula = [NSString stringWithFormat:@"%@/",formula];
    else
        formula = @"";
    
    UIButton *currentButton = (UIButton *)[self.view viewWithTag:9000+currentOperator];
    currentButton.selected = NO;
    
    formula = [NSString stringWithFormat:@"%@%@",formula, _arabicLabel.text];
    
    //NSLog(@"formula is now %@", formula);
    
    currentOperator = nextOperator;
    shouldClearDisplay = YES;
    
    UIButton *nextButton = (UIButton *)[self.view viewWithTag:9000+nextOperator];
    nextButton.selected = YES;
}

- (IBAction)equalsAction:(id)sender {
    if (userDidSomething == NO) {
//        [Answers logContentViewWithName:@"Calculator" contentType:nil contentId:nil customAttributes:nil];
        userDidSomething = YES;
    }

    if (currentOperator == 1)
        formula = [NSString stringWithFormat:@"%@+",formula];
    else if (currentOperator == 2)
        formula = [NSString stringWithFormat:@"%@-",formula];
    else if (currentOperator == 3)
        formula = [NSString stringWithFormat:@"%@*",formula];
    else if (currentOperator == 4)
        formula = [NSString stringWithFormat:@"%@/",formula];
    else
        formula = @"";
    
    
    //formula = [NSString stringWithFormat:@"%@%@.0",formula, _arabicLabel.text];
    formula = [NSString stringWithFormat:@"%@%@",formula, _arabicLabel.text];
    
    //NSLog(@"formula is now %@", formula);

    
    int result;
    NSString *resultStr;
    
    @try {
        // the code that potentially raises an NSInvalidArgumentException
        NSExpression *expression = [NSExpression expressionWithFormat:formula];

        result = [[expression expressionValueWithObject:nil context:nil] intValue];
        resultStr = [[expression expressionValueWithObject:nil context:nil] stringValue];
    } @catch (NSException *exception) {
        if ([[exception name] isEqualToString:NSInvalidArgumentException]) {
            // your error handling
            result = 0;
            resultStr = @"";
        }
    }
    
    //NSLog(@"%d", result);

    /*float floatResult = [[expression expressionValueWithObject:nil context:nil] floatValue];
    NSLog(@"%.2f", floatResult);*/

    [_arabicLabel setText:resultStr];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    BOOL autoSwitch = [defaults boolForKey:kAutoSwitchKey];

    if ((result > 3999) && (autoSwitch)) {
        archaicMode = YES;
    } else {
        archaicMode = NO;
    }
    
    [_converter convertToRoman:_arabicLabel.text archaic:archaicMode];
    [_romanLabel setText:_converter.romanResult];
    
    if (_converter.overlineRomanResult != nil) {
        
        NSMutableString* spacedOverlineResult = [_converter.overlineRomanResult mutableCopy];
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
        
        NSMutableString* spacedNormalResult = [_converter.normalRomanResult mutableCopy];
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
        NSMutableString* spacedNormalResult = [_converter.normalRomanResult mutableCopy];
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
    
    UIButton *currentButton = (UIButton *)[self.view viewWithTag:9000+currentOperator];
    currentButton.selected = NO;

    formula = @"";
    shouldClearDisplay = YES;
    currentOperator = 0;
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", resultStr]);
}

#pragma mark - Conversion methods

- (void)convertYear:(NSString *)input {
	[self.converter convertToArabic:input];
    
	//debugLog(@"conversion result is %d", converter.conversionResult);
	if (self.converter.conversionResult == Ignored)
	{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.x";
        animation.values = @[ @0, @10, @-10, @10, @0 ];
        animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
        animation.duration = 0.4;
        
        animation.additive = YES;
        
        [self.romanLabel.layer addAnimation:animation forKey:@"shake"];
	} else if (self.converter.conversionResult == Converted) {
		NSString *result = self.converter.arabicResult;
		self.arabicLabel.text = result;
		
		[UIView beginAnimations:@"switch" context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.romanLabel cache:YES];
		[UIView setAnimationDuration:0.3f];
		NSString *convertedValue = self.converter.calculatedRomanValue;
		self.romanLabel.text = convertedValue;
		
		[UIView commitAnimations];
        
        [self.arabicLabel setAccessibilityValue:self.arabicLabel.text];
        
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", result]);
	} else {
		NSString *result = self.converter.arabicResult;
		self.arabicLabel.text = result;
		
		self.romanLabel.text = input;
        [self.arabicLabel setAccessibilityValue:self.arabicLabel.text];

        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", result]);
    }
}

- (void)updateRomanString:(NSString *) text  {
	self.string = [self.romanLabel text];
	
    NSString *romanLabelString = self.string;
    
    if ((romanLabelString == Nil) || (shouldClearDisplay == YES)) {
        romanLabelString = @"";
        shouldClearDisplay = NO;
        [self.romanLabel setText:@""];
        [self.arabicLabel setText:@""];
    }
    
	if ([text isEqualToString: @"delete"]) {
		if ([romanLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[romanLabelString substringToIndex: [romanLabelString length] - 1]];
			[self convertYear:newInputString];
		} else {
            shouldClearDisplay = YES;
            formula = @"";
            currentOperator = 0;
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

- (void)prepareGestures
{
    // Prepare gestures
    for (UIButton *button in self.buttons) {
        UIGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [button addGestureRecognizer:touchGesture];
        
        [button setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateHighlighted];
    }
    
    UIGestureRecognizer *longTouchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.buttonDelete addGestureRecognizer:longTouchGesture];
    
    [self.buttonDelete setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateHighlighted];
    
    for (UIButton *button in self.operatorButtons) {
        [button setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateSelected];
    }
}

- (IBAction)shareButton:(id)sender {
    // Show different text for each service, see http://www.albertopasca.it/whiletrue/2012/10/objective-c-custom-uiactivityviewcontroller-icons-text/
    RomanNumsActivityItemProvider *activityItemProvider = [[RomanNumsActivityItemProvider alloc] initWithRomanText:self.romanLabel.text arabicText:self.arabicLabel.text romanToArabic:YES];
    
    NSArray *itemsToShare = @[activityItemProvider];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        //NSLog(@"completed: %@", activityType);
        
        if (completed) {
            
            NSString *mode = @"None";
            
            if (archaicMode == YES) {
                NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
                
                int largeNumberMode = [[defaults valueForKey:kLargeNumberPresentationKey] intValue];

                if (largeNumberMode == 1) {
                    mode = @"Archaic";
                } else if (largeNumberMode == 2) {
                    mode = @"Overline";
                }
            }
            
//            [Answers logShareWithMethod:@"Calculator" contentName:activityType contentType:nil contentId:nil customAttributes:@{@"Large Numbers": mode}];
        }
        //Present another VC
    }];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
