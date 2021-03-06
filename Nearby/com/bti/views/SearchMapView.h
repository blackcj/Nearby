//
//  SearchMapView.h
//  Nearby
//
//  Created by Christopher Black on 12/2/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  Contains all view elements and lays them out on the page. Auto resize is used when possible, layoutSubviews is used
//  when auto resize isn't possible on the display element.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define OVERLAY_ALPHA                  0.5
#define NAV_BUTTON_PADDING             4
#define NAV_BUTTON_HEIGHT              40

@interface SearchMapView : UIView
{
    UIView *overlay;
    MKMapView *mapKit;
    UIButton *navigateButton;
}


// Overlay used when user types in the search field
@property (nonatomic, strong) UIView *overlay;

// Decided on MapKit to utlize more Objective C code
@property (nonatomic, strong) MKMapView *mapKit;

// Button used to lock to user location
@property (nonatomic, strong) UIButton *navigateButton;

// Darken the map, used when searchInput has focus. Also helps to pick up touch events to hide keyboard.
- (void)addMapOverlay;

// Remove dark overlay, used when the user changes focus from the searchField.
- (void)removeMapOverlay;

@end
