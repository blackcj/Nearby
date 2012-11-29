//
//  MapView.h
//  Nearby
//
//  Created by Christopher Black on 11/26/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>


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

- (void)addMapOverlay;

- (void)removeMapOverlay;


@end
