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
    navigationController.navigationBar.tintColor = [UIColor colorWithRed:(26.0f/255.0f) green:(103.0f/255.0f) blue:(159.0f/255.0f) alpha:1.0f];
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
