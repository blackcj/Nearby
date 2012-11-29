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
@synthesize viewController;

/**
 *  Kick start the application.
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] init];
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

// Release window from memory
- (void)dealloc {
    [window release];
    [viewController release];
    [super dealloc];
}

@end
