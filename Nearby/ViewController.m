//
//  ViewController.m
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "ViewController.h"
#import "MapMarker.h"

@implementation ViewController
@synthesize currentDist;        // Current radius of the map viewport at the current zoom
@synthesize coordinate;         // Stores the map center point
@synthesize mapView;            // MapKit view object
//@synthesize webView;          // First approach was to use UIWebView

#pragma mark - View lifecycle

/**
 *  Initialize the view
 *
 */
- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds; 
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view = view;
    self.view.autoresizesSubviews = YES;
    [view release];
    [super loadView];
}

/**
 *  Initialize the map and add to the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // START HTML5 web view for Google Maps - decided not to use this
    // NSString *url = @"url";
    // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    // webView.autoresizesSubviews = YES;
    // webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    // [webView loadRequest:request];
    // [self.view addSubview:webView];
    // END HTML5 web view
    
    coordinate.longitude = 0.0;
    coordinate.latitude = 0.0;
    
    // MapKit view
    // set to self.view.bounds to auto resize to parent
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];   
    
    // Config variables for code generated map
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
    
    // Auto resize on orientation change.
    mapView.autoresizesSubviews = YES;
    mapView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    // Add the map to the view/
    [self.view addSubview:mapView];
    
    
    
}

/**
 *  Make call to Google Places API
 *
 */
-(void) queryGooglePlaces {
    // Build the url string to send to Google.
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=cafe&sensor=true&key=%@", coordinate.latitude, coordinate.longitude,[NSString stringWithFormat:@"%i", currentDist], kGOOGLE_API_KEY];
    //NSLog(url);
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

/**
 *  Update points of interest when the map center point changes.
 *
 */
-(void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = aMapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);

    NSLog(@"moved");
    coordinate = aMapView.centerCoordinate;
        
    [self queryGooglePlaces];
}

/**
 *  Zoom to user location on first load.
 *
 */
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    if(coordinate.longitude == 0){
        //NSLog(@"update location");
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        CLLocationCoordinate2D location;
        location.latitude = aUserLocation.coordinate.latitude;
        location.longitude = aUserLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [aMapView setRegion:region animated:YES];
    }
}

/**
 *  Plot data on the map.
 *
 */
-(void)plotPositions:(NSArray *)data {
    // Remove existing markers.
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[MapMarker class]]) {
            [mapView removeAnnotation:annotation];
        }
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
        [placeObject release];
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

- (void)dealloc {
    [mapView release];
    //[webView release];
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
