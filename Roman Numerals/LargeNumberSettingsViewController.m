//
//  LargeNumberSettingsViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 26/06/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "LargeNumberSettingsViewController.h"

@interface LargeNumberSettingsViewController ()

@end

@implementation LargeNumberSettingsViewController

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
    
    NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    
    UISwitch *autoSwitchSwitchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.autoSwitchCell.accessoryView = autoSwitchSwitchView;
    [autoSwitchSwitchView setOn:[preferences boolForKey:kAutoSwitchKey] animated:NO];
    [autoSwitchSwitchView addTarget:self action:@selector(autoSwitchSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self adjustLargeNumberRows:[preferences integerForKey:kLargeNumberPresentationKey]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (void)adjustLargeNumberRows:(NSUInteger)largeNumberType {
    if (largeNumberType == 0) {
        self.archaicNumbersCell.accessoryType = UITableViewCellAccessoryNone;
        self.overlineNumberCell.accessoryType = UITableViewCellAccessoryNone;
    } else if (largeNumberType == 1) {
        self.archaicNumbersCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.overlineNumberCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.archaicNumbersCell.accessoryType = UITableViewCellAccessoryNone;
        self.overlineNumberCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)autoCorrectSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    //NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    [preferences setBool:switchControl.on forKey:kAutoCorrectKey];
    
    [preferences synchronize];
}

- (void)autoSwitchSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    //NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    [preferences setBool:switchControl.on forKey:kAutoSwitchKey];
    
    [preferences synchronize];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    
    // keyboard presentation
        [self adjustLargeNumberRows:indexPath.row+1];
        
        [preferences setObject:[NSNumber numberWithInteger:indexPath.row+1] forKey:kLargeNumberPresentationKey];
        [preferences synchronize];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"SymbolChanged" object:self userInfo:nil];
}

- (IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
