//
//  ViewController.h
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  ViewController is used to handle all of the interaction and data retrieval for the application.
//  It passes data back to the view and handles delegation for all items in the SearchView.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kGOOGLE_API_KEY @"YOUR_GOOGLE_PLACES_API_KEY"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define SCROLL_UPDATE_DISTANCE          0.10                                    // Distance used to determine if user is scrolling map or walking
#define DEFAULT_SEARCH_TERM             @"cafe"                                 // Default search term so results show right away
#define DISTANCE_MULTIPLIER             0.000621371192                          // Used to normalize a really big number

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

// Used to determine if the user initiated the movement or if the 'center on me' navigation button initiated movement.
@property (nonatomic) bool focusShift;

// Stores the current radius of the view window
@property (nonatomic) int currentDist;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) SearchView *searchView;

// Stores the current position
@property (nonatomic) CLLocationCoordinate2D lastLocation;

// Stores the user position
@property (nonatomic) CLLocationCoordinate2D userLocation;

// Stores the current search term.
@property (nonatomic, retain) NSString *searchTerm;

// Remove existing markers from the map
- (void) cleanUpMap;

// Handle navigationButton click events
- (void) clickHandler:(id)sender;

// Zooms the map to the last known user location
- (void) zoomMap;

@end
