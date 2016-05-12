//
//  CalendarViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 16/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController {
    bool userDidSomething;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end
