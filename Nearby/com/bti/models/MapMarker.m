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
        NSDictionary *geo = place[@"geometry"];
        NSDictionary *loc = geo[@"location"];
        
        NSString *name = place[@"name"];
        NSString *address = place[@"vicinity"];
        NSString *icon = place[@"icon"];
        NSString *placeId = place[@"id"];
        
        CLLocationCoordinate2D placeCoord;
        
        // Set the latitude and longitude.
        placeCoord.latitude=[loc[@"lat"] doubleValue];
        placeCoord.longitude=[loc[@"lng"] doubleValue];
        
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
    if (_name && _name.length > 0)
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

@end
