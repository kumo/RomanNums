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
	IBOutlet UILabel *romanLabel;
	IBOutlet UILabel *arabicLabel;
	IBOutlet UIButton *archaicButton;
	NSString *string;
	Converter *converter;
	
	bool archaicMode;
}
@property (nonatomic, retain) UILabel *romanLabel;
@property (nonatomic, retain) UILabel *arabicLabel;
@property (nonatomic, retain) UIButton *archaicButton;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) Converter *converter;

- (void)convertYear:(NSString *)input;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)archaicButtonPressed:(id)sender;
@end
