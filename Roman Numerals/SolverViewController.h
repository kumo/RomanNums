//
//  SolverViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 20/10/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrosswordSolver;

@interface SolverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    CrosswordSolver *solver;
    
    bool userDidSomething;
}

@property (weak, nonatomic) IBOutlet UILabel *romanLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) CrosswordSolver *solver;

@property (nonatomic) NSArray *crosswordResults;

@property (weak, nonatomic) IBOutlet UITableView *resultsTable;

@end
