//
//  ExtendAppViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 16/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "ExtendAppViewController.h"
#import "RomanIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface ExtendAppViewController () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}

@end

@implementation ExtendAppViewController

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
    
    _knownProducts = @[ @"Calculator", @"Calendar", @"Crossword Solver" ];
    _knownDescriptions = @[ @"Calculate XI*IV or MM-CXV", @"Any date in Roman Numerals", @"Find solutions to X?I?" ];
    _knownImages = @[ [UIImage imageNamed:@"thin-165_calculator"], [UIImage imageNamed:@"thin-021_calendar_date"], [UIImage imageNamed:@"thin-093_notebook_to_do"] ];

    _knownProProducts = @[ @"Pro Mode" ];
    _knownProDescriptions = @[ @"Unlock all features" ];
    _knownProImages = @[ [UIImage imageNamed:@"thin-464_bright_bulb_idea_lamp_light"] ];

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

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
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
        return _knownProducts.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell; // = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if ((indexPath.section == 0) || (indexPath.section == 1)) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            cell.textLabel.text = _knownProducts[indexPath.row];
            cell.detailTextLabel.text = _knownDescriptions[indexPath.row];
            cell.imageView.image = _knownImages[indexPath.row];
        } else {
            // NOTE: hard-coding value here
            cell.textLabel.text = _knownProProducts[0];
            cell.detailTextLabel.text = _knownProDescriptions[0];
            cell.imageView.image = _knownProImages[0];
        }
        
        SKProduct * product = nil;
        
        if (_products.count > indexPath.row) {
            product = (SKProduct *) _products[indexPath.row];
        }
        
        if (indexPath.section == 1) {
            product = (SKProduct *) _products.lastObject;
        }
        
        if (product != nil) {
            cell.textLabel.text = product.localizedTitle;
            [_priceFormatter setLocale:product.priceLocale];
        
            if ([[RomanIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.accessoryView = nil;
            } else {
                UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                buyButton.frame = CGRectMake(0, 0, 72, 37);
                [buyButton setTitle:[_priceFormatter stringFromNumber:product.price] forState:UIControlStateNormal];
                buyButton.tag = indexPath.row;
                [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside   ];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryView = buyButton;
            }
        }
    } else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        // restore purchases
        [cell.textLabel setText:@"Restore purchases"];
    }
    
    return cell;
}

- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    [[RomanIAPHelper sharedInstance] buyProduct:product];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (_products != nil) {
            SKProduct *product = _products[indexPath.row];
        
            [[RomanIAPHelper sharedInstance] buyProduct:product];
        }
    } else {
        [[RomanIAPHelper sharedInstance] restoreCompletedTransactions];
    }
}

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end