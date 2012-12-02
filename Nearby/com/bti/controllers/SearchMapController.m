//
//  MapViewController.m
//  Nearby
//
//  Created by Christopher Black on 12/2/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "SearchMapController.h"

@implementation SearchMapController

@synthesize searchMapView;         // 
@synthesize currentDist;        // Current radius of the map viewport at the current zoom
@synthesize lastLocation;       // Stores the map center point
@synthesize userLocation;       // Stores last known user location
@synthesize focusShift;         // Used to determine if the user moved the map

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/**
 *  Initialize the view
 *
 */
- (void) loadView
{
    [super loadView];

    focusShift = TRUE;
    lastLocation.longitude = 0.0;
    lastLocation.latitude = 0.0;
    userLocation.longitude = 0.0;
    userLocation.latitude = 0.0;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Create view and add delegates
    CGRect rect = [UIScreen mainScreen].applicationFrame; 
    self.searchMapView = [[SearchMapView alloc] initWithFrame:rect];
    self.searchMapView.mapKit.delegate = self;
    [self.searchMapView.navigateButton addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
    self.searchMapView.navigateButton.selected = YES;
    self.view = self.searchMapView;
    
}

- (void)viewDidUnload
{
    [self cleanUpMap];
    [searchMapView release];
    [super viewDidUnload];
}

/**
 *  Clean up memory.
 *
 */
- (void) dealloc 
{
    [self cleanUpMap];
    [searchMapView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - General Functions

/**
 *  If no location is found, set default data.
 *
 */
- (void) setDefaultData
{
    searchMapView.navigateButton.selected = NO;
    focusShift = FALSE;
    userLocation.longitude = -93.2636;
    userLocation.latitude = 44.9800;
    [self zoomMap];
}

/**
 *  Selects and deselects the navigateButton.
 *
 */
- (void) deselectNavButton
{
    self.searchMapView.navigateButton.selected = NO;
}

- (void) selectNavButton
{
    self.searchMapView.navigateButton.selected = YES;
}

/**
 *  Zoom to user location.
 *
 */
- (void) zoomMap
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    region.center = userLocation;                           // Set region center to last known user location
    [self.searchMapView.mapKit setRegion:region animated:YES]; // Animate map to that location
}

/**
 *  Removes all current markers on the map. Remove annotation subtracts one from the retain count bringing it to 0.
 *
 */
- (void)cleanUpMap {
    
    MKMapView *mapView = self.searchMapView.mapKit;
    // Remove existing markers.
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[MapMarker class]]) {
            [mapView removeAnnotation:annotation]; //retain count = 0
        }
    }
    
}

/**
 *  Click handler for the navigateButton. Used to center the map on the user.
 *
 */
- (void) clickHandler:(id)sender
{
    focusShift = TRUE;                        // Shifting focus to lock on user
    [self selectNavButton];                        // Set navigateButton to its selected state
    [self zoomMap];                                // Animate map to current user position
}

#pragma mark - Event Handlers - MKMapViewDelegate

/**
 *  Update points of interest when the map center point changes.
 *
 */
-(void) mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated 
{
    
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = aMapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    MKCoordinateRegion mapRegion;   
    
    // set the center of the map region to the now updated map view center
    mapRegion.center = aMapView.centerCoordinate;
    
    // get the lat & lng of the map region
    double lat = mapRegion.center.latitude;
    double lng = mapRegion.center.longitude;
    
    CLLocation *before = [[CLLocation alloc] initWithLatitude:lastLocation.latitude longitude:lastLocation.longitude];  //retain count = 1
    CLLocation *now = [[CLLocation alloc] initWithLatitude:lat longitude:lng];                                          //retain count = 1
    
    // Calculate distance from before to now. Normalize it. Divide it by the current zoom level to keep it consistent.
    CLLocationDistance distance = ([before distanceFromLocation:now]) * DISTANCE_MULTIPLIER / (currentDist / 1000);
    
    [before release];   //retain count = 0
    [now release];      //retain count = 0
    
    if( (distance > SCROLL_UPDATE_DISTANCE || focusShift) && userLocation.longitude != 0.0)
    {
        lastLocation = aMapView.centerCoordinate;   // Store last location to use for calculating distance
        
        if(focusShift)
        {
            // User clicked center on me, we are tracking movement
            focusShift = FALSE;
        }
        else
        {
            // User triggered movement, we are no longer tracking movement
            self.searchMapView.navigateButton.selected = NO;
        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:QUERY_GOOGLE_EVENT
         object:nil ];
    }
}

/**
 *  Called when the GPS has a new user location.
 *
 */
- (void) mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation 
{
    userLocation.latitude = aUserLocation.coordinate.latitude;      // Store current user location to use for zooming to current location
    userLocation.longitude = aUserLocation.coordinate.longitude;
    
    // If locked on user is true, zoom to user location
    if(self.searchMapView.navigateButton.selected){
        //NSLog(@"update location");
        lastLocation.latitude = aUserLocation.coordinate.latitude;
        lastLocation.longitude = aUserLocation.coordinate.longitude;
        [self zoomMap];
    }
}

/**
 *  Error handler.
 *
 */
- (void) mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Detect Location" 
                                              message:@"Please ensure location services are enabled. Using default location of Minneapolis, MN." 
                                              delegate:nil 
                                              cancelButtonTitle:CANCEL_TITLE
                                              otherButtonTitles:nil];   //retain count = 1
    
    [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
    [alert release];    //retain count = 1
    
    [self setDefaultData];
}

/**
 *  Override default MKAnnotationView to provide a callout accessory and store marker data.
 *
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    } 
    else 
    {
        MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"searchMap"];
        annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; 
        annView.pinColor = MKPinAnnotationColorGreen;
        annView.canShowCallout = YES;
        return annView;
    }
	
}

/**
 *  When ther user clicks a callout, open the detail page.
 *
 */
- (void) mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:pin.annotation forKey:@"data"];
     
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SHOW_DETAIL_EVENT
     object:Nil userInfo:dict ];
    [dict release];
}

@end
