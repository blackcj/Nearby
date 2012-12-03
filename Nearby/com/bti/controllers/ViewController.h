//
//  ViewController.h
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  ViewController is used to handle all of the interaction and data retrieval for the application.
//  Contains code for making calls to Google Places API and parsing data.
//

#import <UIKit/UIKit.h>

#import "SearchView.h"
#import "DetailViewController.h"
#import "SearchMapController.h"

#define kGOOGLE_API_KEY                 @"YOUR_GOOGLE_PLACES_API_KEY"               // Google Places API Key
#define DEFAULT_SEARCH_TERM             @"cafe"                                     // Default search term so results show right away

#define INVALID_KEY_ERROR               @"Invalid API Key"
#define INVALID_KEY_MESSAGE             @"Please add your API key to ViewController.h."

#define NO_RESULTS_TITLE                @"No Results"
#define NO_RESULTS_MESSAGE              @"Pleae try a different search term or zoom out."

// Added MKMapViewDelegate to allow assignmnet to mapView.delegate
@interface ViewController : UIViewController <UITextFieldDelegate>
{
    SearchView *searchView;
    SearchMapController *mapController;
    NSString *searchTerm;
}

@property (strong, nonatomic) SearchMapController *mapController;     // Map ViewController

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) SearchView *searchView;

// Stores the current search term.
@property (nonatomic, retain) NSString *searchTerm;

- (void) queryGooglePlaces;

@end
