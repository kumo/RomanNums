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
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (weak, nonatomic) IBOutlet UILabel *romanLabel;
@property (weak, nonatomic) IBOutlet UILabel *arabicLabel;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) Converter *converter;

- (IBAction)operatorAction:(id)sender;
- (IBAction)equalsAction:(id)sender;

@end
