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
    UIView *overlay;
    MKMapView *mapKit;
    UITextField *searchField;
    UIButton *searchButton;
    
}
// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) UIView *overlay;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, retain) MKMapView *mapKit;

// Stores the current radius of the view window
@property (nonatomic, retain) UITextField *searchField;

// Stores the current position
@property (nonatomic, retain) UIButton *searchButton;

- (void)addMapOverlay;

- (void)removeMapOverlay;


@end
