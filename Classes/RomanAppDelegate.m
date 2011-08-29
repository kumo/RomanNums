//
//  RomanAppDelegate.m
//  Roman
//
//  Created by Rob on 13/08/2008.
//  Copyright [kumo.it] 2008. All rights reserved.
//

#import "RomanViewController.h"
#import "RomanAppDelegate.h"
#import "Appirater.h"

@implementation RomanAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];

	NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"keyboard_type"];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
		
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
		
		NSString *keyboardTypeDefault;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:@"keyboard_type"])
			{
				keyboardTypeDefault = defaultValue;
			}
		}
		
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:
									  keyboardTypeDefault, @"keyboard_type",
									  [NSNumber numberWithInt:1], @"correction",
									  nil];
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    [Appirater appLaunched:YES];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}


- (void)dealloc {
    [tabBarController release];
	[window release];
	[super dealloc];
}

/*- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[UIAccelerometer sharedAccelerometer].delegate = viewController;
}*/

@end
