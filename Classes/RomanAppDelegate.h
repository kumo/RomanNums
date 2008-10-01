//
//  RomanAppDelegate.h
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright [kumo.it] 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RomanAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

