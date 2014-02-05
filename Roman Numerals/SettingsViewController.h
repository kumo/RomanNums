//
//  SettingsViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 27/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *alphabeticalKeyboardCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *largestFirstKeyboardCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *smallestFirstKeyboardCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *archaicNumbersCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *overlineNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *autoSwitchCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *autoCorrectCell;

- (IBAction)doneAction:(id)sender;

@end
