//
//  ViewController.m
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "ViewController.h"
#import "MapMarker.h"
#import "SearchView.h"

@implementation ViewController
@synthesize currentDist;        // Current radius of the map viewport at the current zoom
@synthesize lastLocation;         // Stores the map center point
@synthesize userLocation;         // 
@synthesize searchView;            // MapView instance
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
    searchTerm = @"cafe";
    focusShift = TRUE;
    lastLocation.longitude = 0.0;
    lastLocation.latitude = 0.0;
    userLocation.longitude = 0.0;
    userLocation.latitude = 0.0;
    CGRect rect = [UIScreen mainScreen].applicationFrame; 
    self.searchView = [[SearchView alloc] initWithFrame:rect];
    self.searchView.mapKit.delegate = self;
    self.searchView.searchField.delegate = self;
    [self.searchView.navigateButton addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
    self.searchView.navigateButton.selected = YES;
    self.view = self.searchView;
    [super viewDidLoad];
}

- (void) clickHandler:(id)sender
{
    focusShift = TRUE;
    self.searchView.navigateButton.selected = YES;
    [self zoomMap];
}

/**
 *  Make call to Google Places API
 *
 */
-(void) queryGooglePlaces 
{
    // Build the url string to send to Google.
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", lastLocation.latitude, lastLocation.longitude,[NSString stringWithFormat:@"%i", currentDist], searchTerm, kGOOGLE_API_KEY];
    //NSLog(url);
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.searchView removeMapOverlay];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.searchView addMapOverlay];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.searchView removeMapOverlay];
    searchTerm = self.searchView.searchField.text;
    [self queryGooglePlaces];
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
    
    //mapRegion.span.latitudeDelta = 0.3; // you likely don't need these... just kinda hacked this out
    //mapRegion.span.longitudeDelta = 0.3;
    
    // get the lat & lng of the map region
    double lat = mapRegion.center.latitude;
    double lng = mapRegion.center.longitude;
    
    CLLocation *before = [[CLLocation alloc] initWithLatitude:lastLocation.latitude longitude:lastLocation.longitude];
    CLLocation *now = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    CLLocationDistance distance = ([before distanceFromLocation:now]) * 0.000621371192 / (currentDist / 1000);
    [before release];
    [now release];
    NSLog(@"The value of integer num is %i", currentDist);
    NSLog(@"Scrolled distance: %@", [NSString stringWithFormat:@"%.02f", distance]);
    
    if( distance > SCROLL_UPDATE_DISTANCE || focusShift)
    {
        NSLog(@"updated");
        lastLocation = aMapView.centerCoordinate;
        if(focusShift)
        {
            focusShift = FALSE;
        }
        else
        {
            self.searchView.navigateButton.selected = NO;
        }
        
        [self queryGooglePlaces];
    }
    
    // resave the last location center for the next map move event
    
}

/**
 *  Zoom to user location.
 *
 */
- (void) mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    userLocation.latitude = aUserLocation.coordinate.latitude;
    userLocation.longitude = aUserLocation.coordinate.longitude;
    if(self.searchView.navigateButton.selected){
        //NSLog(@"update location");
        lastLocation.latitude = aUserLocation.coordinate.latitude;
        lastLocation.longitude = aUserLocation.coordinate.longitude;
        [self zoomMap];
    }
}

- (void) zoomMap
{
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    region.center = userLocation;
    [self.searchView.mapKit setRegion:region animated:YES];
}

/**
 *  Plot data on the map.
 *
 */
-(void)plotPositions:(NSArray *)data {
    
    [self cleanUpMap];
    MKMapView *mapView = self.searchView.mapKit;
    
    if(data.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" 
                                                        message:@"Pleae try a different search term or zoom out." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    // Loop through the data returned from Goolge Places API and place markers.
    for (int i=0; i<[data count]; i++) {
        NSDictionary* place = [data objectAtIndex:i];
        NSDictionary *geo = [place objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];

        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];

        CLLocationCoordinate2D placeCoord;
        
        // Set the latitude and longitude.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        MapMarker *placeObject = [[MapMarker alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [mapView addAnnotation:placeObject];
        //[placeObject release];
    }
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
    //NSLog(@"Google Places Data: %@", places);
    [self plotPositions:places];
}

- (void)cleanUpMap {
    
    MKMapView *mapView = self.searchView.mapKit;
    // Remove existing markers.
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[MapMarker class]]) {
            [mapView removeAnnotation:annotation];
            [annotation release];
        }
    }
    
}

- (void)dealloc {
    [self cleanUpMap];
    [searchView release];
    [super dealloc];
}

- (void)viewDidUnload
{
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
