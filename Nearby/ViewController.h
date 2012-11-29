//
//  ViewController.h
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kGOOGLE_API_KEY @"API_KEY"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define SCROLL_UPDATE_DISTANCE          0.15

@class SearchView;

// Added MKMapViewDelegate to allow assignmnet to mapView.delegate
@interface ViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>
{
    SearchView *searchView;
    CLLocationCoordinate2D lastLocation;
    CLLocationCoordinate2D userLocation;
    bool focusShift;
    int currentDist;
    NSString *searchTerm;
}

// 
@property (nonatomic) bool focusShift;

// Stores the current radius of the view window
@property (nonatomic) int currentDist;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) SearchView *searchView;

// Stores the current position
@property (nonatomic) CLLocationCoordinate2D lastLocation;

// Stores the user position
@property (nonatomic) CLLocationCoordinate2D userLocation;

// 
@property (nonatomic, retain) NSString *searchTerm;


- (void) cleanUpMap;
- (void) clickHandler:(id)sender;
- (void) zoomMap;

@end
