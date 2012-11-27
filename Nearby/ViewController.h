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

#define kGOOGLE_API_KEY @"AIzaSyBp1eIXnp363gQRhYxspanUPDrGKyMPy5k"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@class SearchView;

// Added MKMapViewDelegate to allow assignmnet to mapView.delegate
@interface ViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>
{
    SearchView *searchView;
    //MKMapView *mapView;
    CLLocationCoordinate2D coordinate;
    int currentDist;
}
// Stores the current radius of the view window
@property (nonatomic) int currentDist;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) SearchView *searchView;

// Stores the current position
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (void)cleanUpMap;

@end
