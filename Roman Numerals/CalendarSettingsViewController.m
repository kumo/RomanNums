//
//  CalendarSettingsViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 27/08/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "CalendarSettingsViewController.h"

@interface CalendarSettingsViewController ()

@end

@implementation CalendarSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    [self adjustDateOrderRows:[preferences integerForKey:kDateOrderKey]];

    [self adjustDateFormatRows:[preferences integerForKey:kDateFormatKey]];

    UISwitch *autoSwitchSwitchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.yearFormatCell.accessoryView = autoSwitchSwitchView;
    [autoSwitchSwitchView setOn:[preferences boolForKey:kYearFormatKey] animated:NO];
    [autoSwitchSwitchView addTarget:self action:@selector(yearFormatSwitchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    // keyboard presentation
    if (indexPath.section == 0) {
        [self adjustDateOrderRows:indexPath.row];
        
        [preferences setObject:[NSNumber numberWithInteger:indexPath.row] forKey:kDateOrderKey];
        [preferences synchronize];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else if (indexPath.section == 1) {
        [self adjustDateFormatRows:indexPath.row];
        
        [preferences setObject:[NSNumber numberWithInteger:indexPath.row] forKey:kDateFormatKey];
        [preferences synchronize];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
}

- (void)adjustDateOrderRows:(NSUInteger)dateOrder {
    if (dateOrder == 0) {
        self.systemOrderCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.dayOrderCell.accessoryType = UITableViewCellAccessoryNone;
        self.monthOrderCell.accessoryType = UITableViewCellAccessoryNone;
    } else if (dateOrder == 1) {
        self.systemOrderCell.accessoryType = UITableViewCellAccessoryNone;
        self.dayOrderCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.monthOrderCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.systemOrderCell.accessoryType = UITableViewCellAccessoryNone;
        self.dayOrderCell.accessoryType = UITableViewCellAccessoryNone;
        self.monthOrderCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)adjustDateFormatRows:(NSUInteger)dateFormat {
    if (dateFormat == 0) {
        self.dotSeperatorCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.dashSeperatorCell.accessoryType = UITableViewCellAccessoryNone;
        self.spaceSeperatorCell.accessoryType = UITableViewCellAccessoryNone;
    } else if (dateFormat == 1) {
        self.dotSeperatorCell.accessoryType = UITableViewCellAccessoryNone;
        self.dashSeperatorCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.spaceSeperatorCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.dotSeperatorCell.accessoryType = UITableViewCellAccessoryNone;
        self.dashSeperatorCell.accessoryType = UITableViewCellAccessoryNone;
        self.spaceSeperatorCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)yearFormatSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    //NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:switchControl.on forKey:kYearFormatKey];
    
    [preferences synchronize];
}


@end
