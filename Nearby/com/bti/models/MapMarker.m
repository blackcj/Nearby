//
//  MapMarker.m
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "MapMarker.h"

@implementation MapMarker
@synthesize name = _name;
@synthesize address = _address;
@synthesize icon = _icon;
@synthesize placeId = _placeId;
@synthesize coordinate = _coordinate;

- (id) initWithData:(NSDictionary *)place
{
    if ((self = [super init])) 
    {
        NSDictionary *geo = [place objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        NSString *name = [place objectForKey:@"name"];
        NSString *address = [place objectForKey:@"vicinity"];
        NSString *icon = [place objectForKey:@"icon"];
        NSString *placeId = [place objectForKey:@"id"];
        
        CLLocationCoordinate2D placeCoord;
        
        // Set the latitude and longitude.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        _name = [name copy];        //retain count = 1
        _address = [address copy];  //retain count = 1
        _coordinate = placeCoord;
        _placeId = [placeId copy];  //retain count = 1
        _icon = [icon copy]; 
    }
    return self;
    
}

- (NSString *)iconPath
{
    return _icon;
}

- (NSString *)title 
{
    if ([_name isKindOfClass:[NSNull class]] || _name == @"" || _name.length == 0 || _name == Nil)
    {
        return @"Unknown";
    }
    else
    {
        return _name;
    }
        
}

- (NSString *)subtitle 
{
    return _address;
}

/**
 *  Clean up memory.
 *
 */
- (void)dealloc {
    [_placeId release]; //retain count = 0
    [_icon release];    //retain count = 0
    [_name release];    //retain count = 0
    [_address release]; //retain count = 0
    [super dealloc];
}

@end
