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

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) Converter *converter;

- (void)convertYear:(NSString *)input;

@end
