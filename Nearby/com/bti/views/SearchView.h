//
//  MapView.h
//  Nearby
//
//  Created by Christopher Black on 11/26/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  Contains all view elements and lays them out on the page. Auto resize is used when possible, layoutSubviews is used
//  when auto resize isn't possible on the display element.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define SEARCH_PLACEHOLDER             @"Search"
#define OVERLAY_ALPHA                  0.5

@interface SearchView : UIView
{
    UIView *searchBar;
    CAGradientLayer *gradient;
    UIView *overlay;
    MKMapView *mapKit;
    UITextField *searchField;
    UIButton *navigateButton;
}

// Container for the searchField and gradient
@property (nonatomic, retain) UIView *searchBar;

// Gradeint used behind the search field
@property (nonatomic, retain) CAGradientLayer *gradient;

// Overlay used when user types in the search field
@property (nonatomic, retain) UIView *overlay;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) MKMapView *mapKit;

// Stores the current radius of the view window
@property (nonatomic, retain) UITextField *searchField;

// Stores the current position
@property (nonatomic, retain) UIButton *navigateButton;

// Darken the map, used when searchInput has focus. Also helps to pick up touch events to hide keyboard.
- (void)addMapOverlay;

// Remove dark overlay, used when the user changes focus from the searchField.
- (void)removeMapOverlay;

@end
