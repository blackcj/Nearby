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
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate icon:(NSString*)icon 
{
    if ((self = [super init])) 
    {
        _name = [name copy];        //retain count = 1
        _address = [address copy];  //retain count = 1
        _coordinate = coordinate;
        _icon = icon;
    }
    return self;
}

- (NSString *)title 
{
    if ([_name isKindOfClass:[NSNull class]] || _name == @"" || _name == Nil)
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
    [_name release];    //retain count = 0
    [_address release]; //retain count = 0
    [super dealloc];
}

@end
