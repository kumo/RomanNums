//
//  SettingsViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 27/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardSettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *alphabeticalKeyboardCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *largestFirstKeyboardCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *smallestFirstKeyboardCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *autoCorrectCell;

- (IBAction)doneAction:(id)sender;

@end
