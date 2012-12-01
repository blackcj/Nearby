//
//  DetailViewController.h
//  Nearby
//
//  Created by Christopher Black on 12/1/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailView.h"

@interface DetailViewController : UIViewController
{
    DetailView *detailView;
}

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) DetailView *detailView;

@end
