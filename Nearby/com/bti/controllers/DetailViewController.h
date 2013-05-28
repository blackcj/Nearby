//
//  DetailViewController.h
//  Nearby
//
//  Created by Christopher Black on 12/1/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailView;
@class MapMarker;

@interface DetailViewController : UIViewController

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, strong) DetailView *detailView;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, strong) MapMarker *marker;

// Init with MapMarker
- (id) initWithMarker:(MapMarker*)mapMarker;

@end
