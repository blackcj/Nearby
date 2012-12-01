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
    CLLocationCoordinate2D placeCoord;
    placeCoord.longitude = -93.2636;
    placeCoord.latitude = 44.9800;
    
    MapMarker *marker = [[MapMarker alloc] initWithName:@"Starbucks" address:@"123 Grand Ave" coordinate:placeCoord];
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Starbucks", title, @"wrong title");
    
    NSString *subtitle = [marker subtitle];
    STAssertEqualObjects(@"123 Grand Ave", subtitle, @"wrong subtitle"); 
   
    CLLocationCoordinate2D coordinate = [marker coordinate];
    
    STAssertEquals(-93.2636, coordinate.longitude, @"wrong initial latitude");
    STAssertEquals(44.9800, coordinate.latitude, @"wrong initial longitude");
    
    [marker release];
}

- (void)testEmptyName
{
    CLLocationCoordinate2D placeCoord;
    placeCoord.longitude = -93.2636;
    placeCoord.latitude = 44.9800;
    
    MapMarker *marker = [[MapMarker alloc] initWithName:@"" address:@"123 Grand Ave" coordinate:placeCoord];
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Unknown", title, @"wrong title");
    
    [marker release];
}

- (void)testNilName
{
    CLLocationCoordinate2D placeCoord;
    placeCoord.longitude = -93.2636;
    placeCoord.latitude = 44.9800;
    
    MapMarker *marker = [[MapMarker alloc] initWithName:Nil address:@"123 Grand Ave" coordinate:placeCoord];
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Unknown", title, @"wrong title");
    
    [marker release];
}

- (void)testInit
{
    MapMarker *marker = [[MapMarker alloc] init];
    
    NSString *title = [marker title];
    
    STAssertEqualObjects(@"Unknown", title, @"wrong title");
    
    [marker release];
}
/*
- (void)testChangeSides
{
    SPRectangle *rect = [SPRectangle rectangleWithX:5 y:10 width:5 height:2];
    
    rect.right = 11.0f;
    STAssertEqualsWithAccuracy(11.0f, rect.right, E, @"wrong right property");
    STAssertEqualsWithAccuracy( 6.0f, rect.width, E, @"wrong width");
    
    rect.bottom = 11.0f;
    STAssertEqualsWithAccuracy(11.0f, rect.bottom, E, @"wrong bottom property");
    STAssertEqualsWithAccuracy( 1.0f, rect.height, E, @"wrong height");
}
*/
@end
