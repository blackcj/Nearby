//
//  MapMarker.h
//  Nearby
//
//  Created by Christopher Black on 11/12/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  MapMarker is used to store data returned from the Google Places API. It's used to create
//  the marker on the map for each result returned.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapMarker : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_address;
    NSString *_icon;
    NSString *_placeId;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSString *icon;
@property (copy) NSString *placeId;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithData:(NSDictionary *)place;

- (NSString *)iconPath;

@end
