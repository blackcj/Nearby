//
//  AppDelegate.m
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

/**
 *  Kick start the application.
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *searchView = [[ViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:searchView];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

// Release window from memory
- (void)dealloc {
    [window release];
    [navigationController release];
    [super dealloc];
}

@end
