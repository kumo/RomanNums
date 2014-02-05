//
//  MainMenuViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 26/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "MainMenuViewController.h"
#import "RomanIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface MainMenuViewController () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
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
    [self reload];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];

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

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
            //NSLog(@"item has been purchased");

            NSDictionary *dictionary =
            [[NSDictionary alloc] initWithObjectsAndKeys:productIdentifier, @"productIdentifier", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPurchased" object:self userInfo:dictionary];

            *stop = YES;
        }
    }];
    
}

- (void)reload {
    _products = nil;
    [self.tableView reloadData];
    [[RomanIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1){
        return _products.count;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Version 2.0.1";
    }
    
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"Extend Roman Numerals";
    }
    
    return @"";
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
        SKProduct * product = (SKProduct *) _products[indexPath.row];
        cell.textLabel.text = product.localizedTitle;
        [_priceFormatter setLocale:product.priceLocale];
        cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
        
        if ([[RomanIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.accessoryView = nil;
        } else {
            UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            buyButton.frame = CGRectMake(0, 0, 72, 37);
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            buyButton.tag = indexPath.row;
            [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = buyButton;
        }
    } else if (indexPath.section == 2) {
        // restore purchases
        [cell.textLabel setText:@"Restore purchases"];
    }
    
    return cell;
}

- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    //NSLog(@"Buying %@...", product.productIdentifier);
    [[RomanIAPHelper sharedInstance] buyProduct:product];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)  {
            NSURL *url = [[NSURL alloc] initWithString:@"mailto:support+roman@cloudpebbles.com?subject=RomanNumerals"];
            [[UIApplication sharedApplication] openURL:url];
        } else if (indexPath.row == 1) {
            NSURL *url = [[NSURL alloc] initWithString:@"http://www.cloudpebbles.com/support/roman-numerals/"];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSURL *url = [[NSURL alloc] initWithString:@"http://www.twitter.com/cloudpebbles"];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // buy it
        } else {
        }
    } else {
        [[RomanIAPHelper sharedInstance] restoreCompletedTransactions];
    }
}

@end
