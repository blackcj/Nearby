//
//  NearbyTests.m
//  NearbyTests
//
//  Created by Christopher Black on 11/28/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "NearbyTests.h"

@implementation NearbyTests

@synthesize mapController;
@synthesize searchMapView;

- (void)setUp
{
    [super setUp];
    mapController = [[SearchMapController alloc] init];
    STAssertNotNil(mapController, @"Could not create test subject");
    
    searchMapView = [[SearchMapView alloc] initWithFrame:CGRectMake(0,0, 768, 1024)];
    STAssertNotNil(searchMapView, @"Could not create test subject");
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSearchMapView
{
    CGRect rect = CGRectMake(NAV_BUTTON_PADDING, 1024 - NAV_BUTTON_PADDING - NAV_BUTTON_HEIGHT, NAV_BUTTON_HEIGHT, NAV_BUTTON_HEIGHT);
    STAssertEquals(rect, searchMapView.navigateButton.frame, @"Navigation button incorrect position");
    
    [searchMapView layoutSubviews];
    STAssertEquals(rect, searchMapView.navigateButton.frame, @"Navigation button incorrect position");
}

- (void)testSearchMapController
{
    [mapController loadView];
    
    STAssertTrue([mapController focusShift], @"Focus shift invalid");
}

@end
