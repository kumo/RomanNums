//
//  LargeNumberSettingsViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 26/06/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeNumberSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *archaicNumbersCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *overlineNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *autoSwitchCell;

- (IBAction)doneAction:(id)sender;

@end
