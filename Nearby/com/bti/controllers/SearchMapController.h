//
//  MapViewController.h
//  Nearby
//
//  Created by Christopher Black on 12/2/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  The SearchMapController handles all of the delegation for the MKMapKit located in the SearchMapView.
//  Contains code specific to the map. 
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#import "MapMarker.h"
#import "SearchMapView.h"

#define SCROLL_UPDATE_DISTANCE          0.10                // Distance used to determine if user is scrolling map or walking
#define DISTANCE_MULTIPLIER             0.000621371192      // Used to normalize a really big number
#define QUERY_GOOGLE_EVENT              @"queryGoogle"      // Notification dispatched when the map view port changes
#define SHOW_DETAIL_EVENT               @"showDetails"      // Notification dispatched when the user clicks more info on a pin
#define CANCEL_TITLE                    @"OK"

#define NO_LOCATION_TITLE               @"Unable to Detect Location"
#define NO_LOCATION_MESSAGE             @"Please ensure location services are enabled. Using default location of Minneapolis, MN."

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface SearchMapController : UIViewController <MKMapViewDelegate>
{
    SearchMapView *searchMapView;
    CLLocationCoordinate2D lastLocation;
    CLLocationCoordinate2D userLocation;
    bool focusShift;
    int currentDist;
}

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) SearchMapView *searchMapView;

// Stores the current position
@property (nonatomic) CLLocationCoordinate2D lastLocation;

// Stores the user position
@property (nonatomic) CLLocationCoordinate2D userLocation;

// Used to determine if the user initiated the movement or if the 'center on me' navigation button initiated movement.
@property (nonatomic) bool focusShift;

// Stores the current radius of the view window
@property (nonatomic) int currentDist;


// Handle navigationButton click events
- (void) clickHandler:(id)sender;

// Zooms the map to the last known user location
- (void) zoomMap;

// Remove existing markers from the map
- (void) cleanUpMap;

// Sets navigateButton in the searchMapView selected to NO
- (void) deselectNavButton;

// Sets navigateButton in the searchMapView selected to YES
- (void) selectNavButton;

// Loads default data when user location is unavailable
- (void) setDefaultData;

- (void) setLocationToDefault;

- (void) generateSearchView;

@end
