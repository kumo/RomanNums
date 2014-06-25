//
//  AboutTableViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 24/06/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

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

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *label = [NSString stringWithFormat:@"Version %@", version];
        return label;
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1)  {
            NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=kumo"];
            if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
                [[UIApplication sharedApplication] openURL:twitterURL];
            } else {
                NSURL *url = [[NSURL alloc] initWithString:@"http://twitter.com/kumo"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0)  {
            NSURL *url = [[NSURL alloc] initWithString:@"http://cadigatt.com/roman-nums/support/"];
            [[UIApplication sharedApplication] openURL:url];
        } else if (indexPath.row == 1) {
            NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=RomanNumsApp"];
            if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
                [[UIApplication sharedApplication] openURL:twitterURL];
            } else {
                NSURL *url = [[NSURL alloc] initWithString:@"http://twitter.com/RomanNumsApp"];
                [[UIApplication sharedApplication] openURL:url];
            }
        } else if (indexPath.row == 2) {
            if ([MFMailComposeViewController canSendMail])
            {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSString *label = [NSString stringWithFormat:@"Roman Nums, v%@", version];
                
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                [mailer setSubject:@"Roman Nums"];
                NSArray *toRecipients = [NSArray arrayWithObjects:@"support+romannumsapp@cadigatt.com", nil];
                [mailer setToRecipients:toRecipients];
                NSString *emailBody = [NSString stringWithFormat:@"\n\n%@", label];
                [mailer setMessageBody:emailBody isHTML:NO];
                [self presentViewController:mailer animated:YES completion:nil];
            }
            else
            {
                NSURL *url = [[NSURL alloc] initWithString:@"mailto:support+romannumsapp@cadigatt.com?subject=RomanNums"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
