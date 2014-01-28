//
//  TabBarViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "TabBarViewController.h"
#import "RomanIAPHelper.h"
#import "CalculatorViewController.h"

@interface TabBarViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation TabBarViewController

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

    // Add a reveal button to show the side menu
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    if ([[RomanIAPHelper sharedInstance] productPurchased:@"it.kumo.roman.calculator"] == NO) {
        NSMutableArray *views = (NSMutableArray *)self.viewControllers;
        [views removeLastObject];
        [self setViewControllers:views animated:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productPurchased:)
                                                 name:@"ProductPurchased" object:nil];

    
    // FIXME: this must be done when it is purchased
    /*CalculatorViewController *myController = (CalculatorViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorView"];
    NSMutableArray *views = (NSMutableArray *)self.viewControllers;
    [views addObject:myController];

    [self setViewControllers:views animated:NO];*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = (NSString *)[notification.userInfo objectForKey:@"productIdentifier"];
    
    if ([productIdentifier isEqualToString:@"it.kumo.roman.calculator"]) {
        CalculatorViewController *myController = (CalculatorViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorView"];
         NSMutableArray *views = (NSMutableArray *)self.viewControllers;
         [views addObject:myController];
         
         [self setViewControllers:views animated:NO];
    }
}

@end
