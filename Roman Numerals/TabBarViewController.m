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
#import "CalendarViewController.h"
#import "SolverViewController.h"

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
    /*[self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];*/
    
    // Comment out the following to ignore the purchasing
    NSMutableArray *views = (NSMutableArray *)self.viewControllers;
    [views removeLastObject];
    [self setViewControllers:views animated:NO];

    views = (NSMutableArray *)self.viewControllers;
    [views removeLastObject];
    [self setViewControllers:views animated:NO];

    views = (NSMutableArray *)self.viewControllers;
    [views removeLastObject];
    [self setViewControllers:views animated:NO];

    if ([[RomanIAPHelper sharedInstance] productPurchased:kProPurchaseKey] == YES) {
        [self addCalculatorTab];
        [self addCalendarTab];
        [self addSolverTab];
    } else {

        if ([[RomanIAPHelper sharedInstance] productPurchased:kCalculatorPurchaseKey] == YES) {
            [self addCalculatorTab];
        }

        if ([[RomanIAPHelper sharedInstance] productPurchased:kCalendarPurchaseKey] == YES) {
            [self addCalendarTab];
        }

        if ([[RomanIAPHelper sharedInstance] productPurchased:kSolverPurchaseKey] == YES) {
            [self addSolverTab];
        }

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productPurchased:)
                                                 name:@"ProductPurchased" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCalculatorTab {
    CalculatorViewController *myController = (CalculatorViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorView"];
    NSMutableArray *views = (NSMutableArray *)self.viewControllers;
    [views addObject:myController];
    
    [self setViewControllers:views animated:NO];
}

- (void)addCalendarTab {
    CalendarViewController *myController = (CalendarViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DateView"];
    NSMutableArray *views = (NSMutableArray *)self.viewControllers;
    [views addObject:myController];
    
    [self setViewControllers:views animated:NO];
}

- (void)addSolverTab {
    SolverViewController *myController = (SolverViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SolverView"];
    NSMutableArray *views = (NSMutableArray *)self.viewControllers;
    [views addObject:myController];
    
    [self setViewControllers:views animated:NO];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = (NSString *)[notification.userInfo objectForKey:@"productIdentifier"];
    
    if ([productIdentifier isEqualToString:kCalculatorPurchaseKey]) {
        [self addCalculatorTab];
    } else if ([productIdentifier isEqualToString:kCalendarPurchaseKey]) {
        [self addCalendarTab];
    } else if ([productIdentifier isEqualToString:kSolverPurchaseKey]) {
        [self addSolverTab];
    } else if ([productIdentifier isEqualToString:kProPurchaseKey]) {
        [self addSolverTab];
        [self addCalendarTab];
        [self addCalculatorTab];
    }

}

@end
