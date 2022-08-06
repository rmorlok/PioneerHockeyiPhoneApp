//
//  PioneerHockeyAppDelegate.m
//  PioneerHockey
//
//  Created by Ryan Morlok on 4/12/10.
//  Copyright Morlok Technologies 2010. All rights reserved.
//

#import "PioneerHockeyAppDelegate.h"
#import "MainViewController.h"

@implementation PioneerHockeyAppDelegate


@synthesize window;
@synthesize mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[mainViewController loadData];
}

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
