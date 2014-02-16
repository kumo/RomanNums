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

    archaicMode = NO;
    /*int largeNumberMode = [[defaults valueForKey:kLargeNumberPresentationKey] intValue];
    
    if (largeNumberMode > 0)
        archaicMode = YES;
    else
        archaicMode = NO;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)operatorAction:(id)sender {
    NSUInteger nextOperator = ((UIButton *)sender).tag - 9000;
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL autoSwitch = [defaults boolForKey:kAutoSwitchKey];

    if ((result > 3999) && (autoSwitch)) {
        archaicMode = YES;
    } else {
        archaicMode = NO;
    }
    
    [_converter convertToRoman:_arabicLabel.text archaic:archaicMode];
    [_romanLabel setText:_converter.romanResult];
    
    UIButton *currentButton = (UIButton *)[self.view viewWithTag:9000+currentOperator];
    currentButton.selected = NO;

    formula = @"";
    shouldClearDisplay = YES;
    currentOperator = 0;
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
	} else if (self.converter.conversionResult == Converted) {
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

@end
