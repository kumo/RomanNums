//
//  RomanViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Converter;

@interface RomanViewController : UIViewController {
    NSString *string;
	Converter *converter;

	BOOL isTouchingRoman;
    
	BOOL isTouchingDelete;
	NSTimer *deleteTimer;
}


@property (weak, nonatomic) IBOutlet UILabel *romanLabel;
@property (weak, nonatomic) IBOutlet UILabel *arabicLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) Converter *converter;

- (void)convertYear:(NSString *)input;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)deleteButtonStartPressed:(id)sender;
- (void)setButtonTitles:(NSArray *)titles;
- (void)replaceRomanString:(NSString *)text;
- (void)triggerDelete:(NSTimer *) timer;

@end
