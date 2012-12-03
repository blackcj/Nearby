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

@synthesize mapController;
@synthesize searchView;         // MapView instanc
@synthesize searchTerm;         // Query text for the Google Places API

#pragma mark - View lifecycle

/**
 *  Initialize the view
 *
 */
- (void) loadView
{
    [super loadView];
    
    // Set default values
    searchTerm = DEFAULT_SEARCH_TERM;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Create view and add delegates
    CGRect rect = [UIScreen mainScreen].applicationFrame; 
    self.searchView = [[SearchView alloc] initWithFrame:rect];
    self.searchView.searchField.delegate = self;
    self.view = self.searchView;
    
    mapController = [[SearchMapController alloc] init];

    [self addChildViewController:mapController];
    [self.searchView addSubview:mapController.view];
    mapController.view.frame = self.view.bounds;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(eventHandler:)
     name:QUERY_GOOGLE_EVENT
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showDetailPage:)
     name:SHOW_DETAIL_EVENT
     object:nil ];
    
    

    if(kGOOGLE_API_KEY == @"YOUR_GOOGLE_PLACES_API_KEY")
    {
        [self.mapController deselectNavButton];
       // self.searchView.navigateButton.selected = NO;
        mapController.focusShift = FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:INVALID_KEY_ERROR
                                                  message:INVALID_KEY_MESSAGE
                                                  delegate:nil 
                                                  cancelButtonTitle:CANCEL_TITLE
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

- (void)viewDidUnload
{
    [mapController removeFromParentViewController];
    [searchView release];
    [searchTerm release];
    [super viewDidUnload];
}

/**
 *  Clean up memory.
 *
 */
- (void) dealloc 
{
    [mapController removeFromParentViewController];
    [searchView release];
    [searchTerm release];
    [super dealloc];
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

#pragma mark - API Functions

/**
 *  Make call to Google Places API
 *
 */
- (void) queryGooglePlaces
{
    // If no location, alert to the user to turn on location services.
    if(mapController.userLocation.longitude == 0.0 && self.mapController.searchMapView.navigateButton.selected)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NO_LOCATION_TITLE 
                                                  message:NO_LOCATION_MESSAGE
                                                  delegate:nil 
                                                  cancelButtonTitle:CANCEL_TITLE
                                                  otherButtonTitles:nil];   //retain count = 1
        
        [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
        [alert release];    //retain count = 1
        
        [mapController setDefaultData];
    } 
    else if(searchTerm.length > 0)
    {
        // Build the url string to send to Google.
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", mapController.lastLocation.latitude, mapController.lastLocation.longitude,[NSString stringWithFormat:@"%i", mapController.currentDist], searchTerm, kGOOGLE_API_KEY];
        
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
        [mapController cleanUpMap];
    }
}

/**
 *  Plot data on the map and add markers.
 *
 */
-(void)plotPositions:(NSArray *)data 
{
    [mapController cleanUpMap];  // Remove existing markers.
    MKMapView *mapView = self.mapController.searchMapView.mapKit;
    
    // If no results, alert to the user to try a different term.
    if(data.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NO_RESULTS_TITLE 
                                                  message:NO_RESULTS_MESSAGE
                                                  delegate:nil 
                                                  cancelButtonTitle:CANCEL_TITLE
                                                  otherButtonTitles:nil];   //retain count = 1
        
        [alert show];       //retain count = 2 (alert should auto release when closed bringing count to 0)
        [alert release];    //retain count = 1
    }
    
    // Loop through the data returned from Goolge Places API and place markers.
    for (int i=0; i<[data count]; i++) {
        NSDictionary *place = [data objectAtIndex:i];
        MapMarker *placeObject = [[MapMarker alloc] initWithData:place];  //retain count = 1
        [mapView addAnnotation:placeObject];                                                                    //retain count = 2 (the map does an extra retain)
        [placeObject release];                                                                                  //retain count = 1
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


#pragma mark - Event Handlers
- (void) showDetailPage:(NSNotification *) notification
{
    id ndict = [notification userInfo];
	id annotation = [ndict objectForKey:@"data"];
    DetailViewController *detailController = [[DetailViewController alloc] initWithMarker:((MapMarker *)annotation)];
    [self.navigationController pushViewController:detailController animated:TRUE];
}


-(void)eventHandler: (NSNotification *) notification
{
    [self queryGooglePlaces];
}

/**
 *  Touch handler used to hide overlay.
 *
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.navigationController.navigationBar endEditing:YES];                             // Hide keyboard
    [self.mapController.searchMapView removeMapOverlay];    // Remove map overlay
}

#pragma mark - Event Handlers - UITextFieldDelegate

/**
 *  Function called when the searchField takes focus.
 *
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    [self.mapController.searchMapView addMapOverlay];                // Show semi transparent overlay
    return YES;
}

/**
 *  Function called when the done button is pressed on the keyboard.
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];                       // Remove focus from text input
    [self.mapController.searchMapView removeMapOverlay];    // Remove map overlay
    searchTerm = self.searchView.searchField.text;          // Set the search term to the user entered value
    [self queryGooglePlaces];                      // Query Google Places with the new value
    return NO;
}



@end
