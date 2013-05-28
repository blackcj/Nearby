//
//  MapMarkerTests.m
//  Nearby
//
//  Created by Christopher Black on 12/1/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "MapMarkerTests.h"

@implementation MapMarkerTests

// All code under test must be linked into the Unit Test bundle
- (void)testInitWithName
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"place" ofType:@"strings"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];

    MapMarker *marker = [[MapMarker alloc] initWithData:data];
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Cafe Torre", title, @"wrong title");
    
    NSString *subtitle = [marker subtitle];
    STAssertEqualObjects(@"20343 Stevens Creek Boulevard, Cupertino", subtitle, @"wrong subtitle"); 
   
    NSString *iconPath = [marker iconPath];
    STAssertEqualObjects(@"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png", iconPath, @"wrong subtitle"); 
    
    CLLocationCoordinate2D coordinate = [marker coordinate];
    
    STAssertEquals(-122.02948, coordinate.longitude, @"wrong initial latitude");
    STAssertEquals(37.323451, coordinate.latitude, @"wrong initial longitude");
    
}

- (void)testEmptyName
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"placeEmptyName" ofType:@"strings"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    MapMarker *marker = [[MapMarker alloc] initWithData:data];
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Unknown", title, @"wrong title");
    
}

- (void)testNilName
{
    NSDictionary *data = [[NSDictionary alloc] init];
    
    MapMarker *marker = [[MapMarker alloc] initWithData:data];
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Unknown", title, @"wrong title");
    
}

- (void)testInit
{
    MapMarker *marker = [[MapMarker alloc] init];
    
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Unknown", title, @"wrong title");
    
}

@end
