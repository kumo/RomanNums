//
//  PageContentViewController.h
//  Roman Numerals
//
//  Created by Robert Clarke on 25/06/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@end
