//
//  MainMenuViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 26/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ExtendAppViewController.h"

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *label = [NSString stringWithFormat:@"Version %@", version];
        return label;
    } else {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Contact support"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Visit website"];
        } else {
            [cell.textLabel setText:@"Follow on Twitter"];
        }
    } else if (indexPath.section == 1) {
        // restore purchases
        [cell.textLabel setText:@"Extend app"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)  {
            
            if ([MFMailComposeViewController canSendMail])
            {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSString *label = [NSString stringWithFormat:@"Roman Numerals, v%@", version];

                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                [mailer setSubject:@"Roman Numerals"];
                NSArray *toRecipients = [NSArray arrayWithObjects:@"support+roman@cloudpebbles.com", nil];
                [mailer setToRecipients:toRecipients];
                NSString *emailBody = [NSString stringWithFormat:@"\n\n%@", label];
                [mailer setMessageBody:emailBody isHTML:NO];
                [self presentViewController:mailer animated:YES completion:nil];
            }
            else
            {
                NSURL *url = [[NSURL alloc] initWithString:@"mailto:support+roman@cloudpebbles.com?subject=RomanNumerals"];
                [[UIApplication sharedApplication] openURL:url];
            }
        } else if (indexPath.row == 1) {
            NSURL *url = [[NSURL alloc] initWithString:@"http://www.cloudpebbles.com/support/roman-numerals/"];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=cloudpebbles"];
            if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
                [[UIApplication sharedApplication] openURL:twitterURL];
            } else {
                NSURL *url = [[NSURL alloc] initWithString:@"http://www.twitter.com/cloudpebbles"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    } else if (indexPath.section == 1) {
        ExtendAppViewController *myController = (ExtendAppViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ExtendAppViewController"];
        [self presentViewController:myController animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
