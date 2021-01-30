//
//  SolverViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 20/10/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "SolverViewController.h"
#import "RomanNums-Swift.h"
#import "UIImage+Colours.h"
//#import <Crashlytics/Crashlytics.h>  // If using Answers without Crashlytics
//#import <Answers/Answers.h> // If using Answers without Crashlytics


@interface SolverViewController ()

@end

@implementation SolverViewController

@synthesize solver, string;
@synthesize buttons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.solver = [[CrosswordSolver alloc] init];
    
    // Prepare gestures
    for (UIButton *button in self.buttons) {
        UIGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [button addGestureRecognizer:touchGesture];
        
        [button setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateHighlighted];
    }
    
    UIGestureRecognizer *longTouchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.buttonDelete addGestureRecognizer:longTouchGesture];
    
    [self.buttonDelete setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateHighlighted];
    
    _crosswordResults = [[NSArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setTitle:@"Crossword"];
    
    userDidSomething = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *) sender {
    UIButton *button = (UIButton *)sender.view;
    
    if (userDidSomething == NO) {
//        [Answers logContentViewWithName:@"CrosswordSolver" contentType:nil contentId:nil customAttributes:nil];
        userDidSomething = YES;
    }
    //NSLog(@"tapped %@", [button currentTitle]);
    
    //NSLog(@"Before conversion, roman: %@, arabic: %@", _romanLabel.text, _arabicLabel.text);
    if (button.tag == -99) {
        [self updateFilterString: @"delete"];
    } else {
        [self updateFilterString: [button currentTitle]];
    }
}

- (IBAction)handleLongPressGesture:(id)sender {
    //NSLog(@"long pressing delete");
    self.string = @"";
    _romanLabel.text = @"";
}

- (void) updateFilterString:(NSString *) text  {
    self.string = _romanLabel.text;
    
    NSString *arabicLabelString = string;
    
    //NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    
    if ([text isEqualToString: @"delete"]) {
        if ([arabicLabelString length] > 0) {
            NSString *newInputString = [[NSString alloc] initWithString:[arabicLabelString substringToIndex: [arabicLabelString length] - 1]];
            
            [self filterYear:newInputString];
        }
    }
    else if ([arabicLabelString length] < 8) {
        NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", arabicLabelString, text];
        
        [self filterYear:newInputString];
    }
}

-(void)filterYear:(NSString *) text {
    _romanLabel.text = text;

    _crosswordResults = [self.solver search:text];
    
    //NSLog(@"Have to filter %@ (%d)", text, _crosswordResults.count);
    
    [self.resultsTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _crosswordResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CrosswordCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _crosswordResults[indexPath.row];
    
    return cell;
}

@end
