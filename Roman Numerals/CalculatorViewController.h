//
//  CalculatorViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 26/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Converter;

@interface CalculatorViewController : UIViewController {
    NSString *string;
    NSUInteger currentOperator;
    NSString *formula;
    BOOL shouldClearDisplay;
	bool archaicMode;
    
    bool userDidSomething;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *operatorButtons;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (weak, nonatomic) IBOutlet UILabel *romanLabel;
@property (weak, nonatomic) IBOutlet UILabel *arabicLabel;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSString *formula;
@property (nonatomic, retain) Converter *converter;

@property (nonatomic) BOOL shouldClearDisplay;

- (IBAction)operatorAction:(id)sender;
- (IBAction)equalsAction:(id)sender;

@end
