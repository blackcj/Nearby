//
//  ViewController.m
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

/**
 *  QUESTION:
 *  What is the proper syntax for @synthesize? 
 *  I've seen '@synthesize name = _name', '@sythesize name' and have read that modern Objective C
 *  automatically synthesizes variables. 
 *
 */

@synthesize currentDist;        // Current radius of the map viewport at the current zoom
@synthesize lastLocation;       // Stores the map center point
@synthesize userLocation;       // 
@synthesize searchView;         // MapView instance
@synthesize focusShift;
@synthesize searchTerm;

#pragma mark - View lifecycle

/**
 *  Initialize the view
 *
 */
- (void) loadView
{
    [super loadView];
    
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set default values
    searchTerm = DEFAULT_SEARCH_TERM;
    focusShift = TRUE;
    lastLocation.longitude = 0.0;
    lastLocation.latitude = 0.0;
    userLocation.longitude = 0.0;
    userLocation.latitude = 0.0;
    
    // Create view and add delegates
    CGRect rect = [UIScreen mainScreen].applicationFrame; 
    self.searchView = [[SearchView alloc] initWithFrame:rect];
    self.searchView.mapKit.delegate = self;
    self.searchView.searchField.delegate = self;
    [self.searchView.navigateButton addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
    self.searchView.navigateButton.selected = YES;
    self.view = self.searchView;

    //[self.navigationController.navigationBar addSubview:self.searchView.searchField];

    if(kGOOGLE_API_KEY == @"YOUR_GOOGLE_PLACES_API_KEY")
    {
        self.searchView.navigateButton.selected = NO;
        focusShift = FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid API Key" 
                                                  message:@"Please add your API key to ViewController.h." 
                                                  delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];   //retain count = 1
        
        [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
        [alert release];    //retain count = 1
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.searchView.searchField removeFromSuperview];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:self.searchView.searchField];
}

/**
 *  Click handler for the navigateButton. Used to center the map on the user.
 *
 */
- (void) clickHandler:(id)sender
{
    focusShift = TRUE;                              // Shifting focus to lock on user
    self.searchView.navigateButton.selected = YES;  // Set navigateButton to its selected state
    [self zoomMap];                                 // Animate map to current user position
}

/**
 *  Make call to Google Places API
 *
 */
- (void) queryGooglePlaces 
{
    // If no location, alert to the user to turn on location services.
    if(userLocation.longitude == 0.0 && self.searchView.navigateButton.selected)
    {
        self.searchView.navigateButton.selected = NO;
        focusShift = FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Detect Location" 
                                                        message:@"Please ensure location services are enabled. Using default location of Minneapolis, MN." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];   //retain count = 1
        
        [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
        [alert release];    //retain count = 1
        userLocation.longitude = -93.2636;
        userLocation.latitude = 44.9800;
        [self zoomMap];
    } 
    else if(searchTerm.length > 0)
    {
        // Build the url string to send to Google.
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", lastLocation.latitude, lastLocation.longitude,[NSString stringWithFormat:@"%i", currentDist], searchTerm, kGOOGLE_API_KEY];

        //Formulate the string as a URL object.
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        
        // Retrieve the results of the URL.
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        });
    }
    else 
    {
        [self cleanUpMap];
    }
    
}

/**
 *  Used to pick up touch events on the overlay when the searchField is in focus.
 *
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];                     // Hide keyboard
    [self.searchView removeMapOverlay];             // Remove map overlay
}

/**
 *  Function called when the searchField takes focus.
 *
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    [self.searchView addMapOverlay];                // Show semi transparent overlay
    return YES;
}

/**
 *  Function called when the done button is pressed on the keyboard.
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];               // Remove focus from text input
    [self.searchView removeMapOverlay];             // Hide semi transparent overlay
    searchTerm = self.searchView.searchField.text;  // Set the search term to the user entered value
    [self queryGooglePlaces];                       // Query Google Places with the new value
    return NO;
}

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
    
    //NSLog(@"The value of integer currentDist is %i", currentDist);
    //NSLog(@"Scrolled distance: %@", [NSString stringWithFormat:@"%.02f", distance]);
    
    [before release];   //retain count = 0
    [now release];      //retain count = 0
    
    /*
        focusShift:
        This variable is used to determine if the user initiated the movement or if the center on me button initiated movement. If the 
        center on me button was clicked we are shifing focus back to the user and should keep the navigateButton in it's selected state.
        If the user initiated the movement, we disable focus lock by deseleting the button.
     */
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
            self.searchView.navigateButton.selected = NO;
        }
        //if(currentDist
        [self queryGooglePlaces];
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
    if(self.searchView.navigateButton.selected){
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
    self.searchView.navigateButton.selected = NO;
    focusShift = FALSE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Detect Location" 
                                              message:@"Please ensure location services are enabled. Using default location of Minneapolis, MN." 
                                              delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];   //retain count = 1
    
    [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
    [alert release];    //retain count = 1
    userLocation.longitude = -93.2636;
    userLocation.latitude = 44.9800;
    [self zoomMap];
}

- (void) mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
}

- (void) mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%@", pin.annotation.title);
    DetailViewController *detailController = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailController animated:TRUE];
    //NSLog(@"calloutAccessoryControlTapped");
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
    [self.searchView.mapKit setRegion:region animated:YES]; // Animate map to that location
}

/**
 *  Plot data on the map and add markers.
 *
 */
-(void)plotPositions:(NSArray *)data 
{
    [self cleanUpMap];  // Remove existing markers.
    MKMapView *mapView = self.searchView.mapKit;
    
    // If no results, alert to the user to try a different term.
    if(data.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" 
                                                  message:@"Pleae try a different search term or zoom out." 
                                                  delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];   //retain count = 1
        
        [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
        [alert release];    //retain count = 1
    }
    
    // Loop through the data returned from Goolge Places API and place markers.
    for (int i=0; i<[data count]; i++) {
        NSDictionary *place = [data objectAtIndex:i];
        NSDictionary *geo = [place objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];

        NSString *name = [place objectForKey:@"name"];
        NSString *vicinity = [place objectForKey:@"vicinity"];
        NSString *icon = [place objectForKey:@"icon"];

        CLLocationCoordinate2D placeCoord;
        
        // Set the latitude and longitude.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        //MKAnnotationView *marker = [[MKAnnotationView alloc] init];

        MapMarker *placeObject = [[MapMarker alloc] initWithName:name address:vicinity coordinate:placeCoord icon:icon];  //retain count = 1
        
        [mapView addAnnotation:placeObject];                                                                    //retain count = 2 (the map does an extra retain)
        [placeObject release];                                                                                  //retain count = 1
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"searchMap"];
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];                                
    annView.canShowCallout = YES;
                                    
    return annView;
}

/**
 *  Assign response data and call plotPositions.
 *
 */
-(void)fetchedData:(NSData *)responseData {
    // Parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions 
                          error:&error];
    
    NSArray* places = [json objectForKey:@"results"]; 
    NSLog(@"Google Places Data: %@", places);
    [self plotPositions:places];
}

/**
 *  Removes all current markers on the map. Remove annotation subtracts one from the retain count bringing it to 0.
 *
 */
- (void)cleanUpMap {
    
    MKMapView *mapView = self.searchView.mapKit;
    // Remove existing markers.
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[MapMarker class]]) {
            [mapView removeAnnotation:annotation]; //retain count = 0
        }
    }
    
}

/**
 *  Clean up memory.
 *
 */
- (void) dealloc 
{
    [searchView release];
    [searchTerm release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [searchView release];
    [searchTerm release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
