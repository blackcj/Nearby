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

/**
 *  Kick start the application.
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *searchView = [[ViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:searchView];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(26.0f/255.0f) green:(103.0f/255.0f) blue:(159.0f/255.0f) alpha:1.0f];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

// Release window from memory

@end
