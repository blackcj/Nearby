//
//  NearbyTests.h
//  NearbyTests
//
//  Created by Christopher Black on 11/28/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "SearchMapController.h"

@interface NearbyTests : SenTestCase

@property (nonatomic, retain) SearchMapView *searchMapView;

@property (strong, nonatomic) SearchMapController *mapController;

@end
