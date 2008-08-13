//
//  RomanViewController.h
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RomanViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *textField;
	IBOutlet UILabel *label;
	NSString *string;
}
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, copy) NSString *string;
- (IBAction)changeGreeting:(id)sender;
@end
