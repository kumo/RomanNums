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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.converter = [[Converter alloc] init];
	self.converter.performConversionCheck = NO;

    // Prepare gestures
    for (UIButton *button in self.buttons) {
        UIGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [button addGestureRecognizer:touchGesture];
    }
    
    UIGestureRecognizer *longTouchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.buttonDelete addGestureRecognizer:longTouchGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *) sender {
    UIButton *button = (UIButton *)sender.view;
    
    NSLog(@"tapped %@", [button currentTitle]);
    
    NSLog(@"Before conversion, roman: %@, arabic: %@", _romanLabel.text, _arabicLabel.text);
    [self updateArabicString: [button currentTitle]];
}

- (IBAction)handleLongPressGesture:(id)sender {
    NSLog(@"long pressing delete");
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
        
	}
}

- (void) updateArabicString:(NSString *) text  {
	self.string = _arabicLabel.text;
	
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
	
	_buttonArchaic.selected = archaicMode;
	
	NSString *arabicLabelCopy = [[NSString alloc] initWithString:_arabicLabel.text];
	[self convertYear: arabicLabelCopy];
}

@end
