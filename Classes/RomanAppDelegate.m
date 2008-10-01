//
//  RomanAppDelegate.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright [kumo.it] 2008. All rights reserved.
//

#import "RomanViewController.h"
#import "RomanAppDelegate.h"

@implementation RomanAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


- (void)dealloc {
    [tabBarController release];
	[window release];
	[super dealloc];
}


@end
