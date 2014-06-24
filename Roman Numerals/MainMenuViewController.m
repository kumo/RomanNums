//
//  MainMenuViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 26/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ExtendAppViewController.h"
#import "AboutTableViewController.h"

@interface MainMenuViewController () {
}
@end

@implementation MainMenuViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        frame.size.width = [UIScreen mainScreen].bounds.size.height - 60;
    } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.size.width = [UIScreen mainScreen].bounds.size.width - 60;
    }
    self.view.frame = frame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Tutorial"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Support"];
        }
    } else if (indexPath.section == 0) {
        // restore purchases
        [cell.textLabel setText:@"Extra Features"];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"What's New"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Tell a Friend"];
        } else {
            [cell.textLabel setText:@"About"];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0)  {
            ExtendAppViewController *myController = (ExtendAppViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ExtendAppViewController"];
            [self presentViewController:myController animated:YES completion:NULL];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0)  {
            // tutorial
        } else if (indexPath.row == 1) {
            NSURL *url = [[NSURL alloc] initWithString:@"http://cadigatt.com/roman-nums/support/"];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIViewController *myController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"WhatsNewViewController"];
            [self presentViewController:myController animated:YES completion:NULL];
        } else if (indexPath.row == 1) {
            [self tellAFriend];
        } else if (indexPath.row == 2){
            AboutTableViewController *myController = (AboutTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutTableViewController"];
            [self presentViewController:myController animated:YES completion:NULL];
        }
    }
}

- (void)tellAFriend
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    NSString *text = @"Check out Roman Nums - a Roman Numerals converter for iPhone http://romannumsapp.com #romannumsapp";
    if (text) {
        [sharingItems addObject:text];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
