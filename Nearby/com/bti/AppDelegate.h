//
//  AppDelegate.h
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  Kick starts the application and initialized the ViewController.
//
//

#import <UIKit/UIKit.h>

@class ViewController;

// AppDelegate built without any interface builder

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    ViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;                 // Root Window

@property (strong, nonatomic) ViewController *viewController;   // Root ViewController

@end
