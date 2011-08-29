//
//  ArabicViewController.h
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Converter;

@interface ArabicViewController : UIViewController {
	IBOutlet UIImageView *iPhoneImage;
	
	IBOutlet UILabel *romanLabel;
	IBOutlet UILabel *arabicLabel;
	IBOutlet UIButton *archaicButton;
	IBOutlet UIButton *buttonDelete;
	NSString *string;
	Converter *converter;
	
	bool archaicMode;
	BOOL isTouchingRoman;

	BOOL isTouchingDelete;
	NSTimer *deleteTimer;
}

@property (nonatomic, retain) UILabel *romanLabel;
@property (nonatomic, retain) UILabel *arabicLabel;
@property (nonatomic, retain) UIButton *archaicButton;
@property (nonatomic, retain) UIButton *buttonDelete;
@property (nonatomic, retain) UIImageView *iPhoneImage;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) Converter *converter;

- (IBAction)showInfo:(id)sender;
- (void)convertYear:(NSString *)input;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)archaicButtonPressed:(id)sender;
- (IBAction)deleteButtonStartPressed:(id)sender;
- (void)replaceArabicString:(NSString *)text;
- (void)triggerDelete:(NSTimer *) timer;
- (void) updateArabicString:(NSString *) text;

@end
