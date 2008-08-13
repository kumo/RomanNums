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
@synthesize romanViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	RomanViewController *aViewController = [[RomanViewController alloc]
										 initWithNibName:@"ControllerView" bundle:[NSBundle mainBundle]];
	self.romanViewController = aViewController;
	[aViewController release];

	UIView *controllersView = [romanViewController view];
	[window addSubview:controllersView];
	
	// Override point for customization after app launch	
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[romanViewController release];
	[window release];
	[super dealloc];
}


@end
