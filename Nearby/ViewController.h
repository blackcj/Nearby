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

// Added MKMapViewDelegate to allow assignmnet to mapView.delegate
@interface ViewController : UIViewController <MKMapViewDelegate>
{
    //UIWebView *webView;
    MKMapView *mapView;
    CLLocationCoordinate2D coordinate;
    int currentDist;
}
// Stores the current radius of the view window
@property (nonatomic) int currentDist;

// First approach was Google Maps view
//@property (nonatomic, retain) UIWebView *webView;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) MKMapView *mapView;

// Stores the current position
@property (nonatomic) CLLocationCoordinate2D coordinate;


@end
