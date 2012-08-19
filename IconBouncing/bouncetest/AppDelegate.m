//
//  AppDelegate.m
//  bouncetest
//
//  Created by Oliver Drobnik on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
	
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}

@end
