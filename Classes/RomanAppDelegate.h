//
//  RomanAppDelegate.h
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright [kumo.it] 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RomanViewController;

@interface RomanAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;

@end

