//
//  RomanAppDelegate.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright [kumo.it] 2008. All rights reserved.
//

#import "RomanAppDelegate.h"

@implementation RomanAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	// Override point for customization after app launch	
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
