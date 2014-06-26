//
//  WhatsNewViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 24/06/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "WhatsNewViewController.h"

@interface WhatsNewViewController ()

@end

@implementation WhatsNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reviewAction:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:@"https://itunes.apple.com/us/app/roman-numerals-converter/id291773125?mt=8&uo=4"];
    [[UIApplication sharedApplication] openURL:url];
}

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
