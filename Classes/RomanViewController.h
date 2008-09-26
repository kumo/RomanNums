//
//  RomanViewController.h
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright 2008 [kumo.it]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RomanViewController : UIViewController {
	IBOutlet UILabel *romanLabel;
	IBOutlet UILabel *arabicLabel;
	NSString *string;
}
@property (nonatomic, retain) UILabel *romanLabel;
@property (nonatomic, retain) UILabel *arabicLabel;
@property (nonatomic, copy) NSString *string;
- (void)convertYear;
- (IBAction)buttonPressed:(id)sender;
@end
