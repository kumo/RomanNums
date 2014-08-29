//
//  CalendarSettingsViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 27/08/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarSettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *systemOrderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dayOrderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *monthOrderCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *dotSeperatorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dashSeperatorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *spaceSeperatorCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *yearFormatCell;
@end
