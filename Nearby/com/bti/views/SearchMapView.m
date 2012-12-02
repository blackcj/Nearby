//
//  SearchMapView.m
//  Nearby
//
//  Created by Christopher Black on 12/2/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "SearchMapView.h"

@implementation SearchMapView

@synthesize overlay;
@synthesize mapKit;                   // MapKit instance
@synthesize navigateButton;   // Button in lower left. Jumps to current position.

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.autoresizesSubviews = YES;
        
        // MapKit view
        // set to self.view.bounds to auto resize to parent
        mapKit = [[MKMapView alloc] initWithFrame:self.bounds];   
        
        // Config variables for code generated map
        mapKit.showsUserLocation = YES;
        mapKit.mapType = MKMapTypeHybrid;
        //mapKit.delegate = self;
        
        // Auto resize on orientation change.
        mapKit.autoresizesSubviews = YES;
        mapKit.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        // Add the map to the view
        [self addSubview:mapKit];
        
        navigateButton = [[UIButton alloc] init];
        [navigateButton setBackgroundImage: [UIImage imageNamed:@"disabled.png"] forState: UIControlStateDisabled];
        [navigateButton setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
        [navigateButton setBackgroundImage:[UIImage imageNamed:@"selected_green.png"] forState:UIControlStateSelected];
        [navigateButton setBackgroundImage: [UIImage imageNamed:@"normal_down.png"] forState: UIControlStateHighlighted];
        [navigateButton setBackgroundImage: [UIImage imageNamed:@"selected_green.png"] forState: UIControlStateHighlighted | UIControlStateSelected];
        navigateButton.frame = CGRectMake(4,self.bounds.size.height - 44, 40, 40);
        [self addSubview:navigateButton];
        
        overlay = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        overlay.autoresizesSubviews = YES;
        overlay.alpha = OVERLAY_ALPHA;
        overlay.hidden = YES;
        [self addSubview:overlay];
    }
    return self;
}

/**
 *  Position gradient and navigate button.
 *
 */
- (void) layoutSubviews
{
    [super layoutSubviews];
    navigateButton.frame = CGRectMake(4,self.bounds.size.height - 50, 46, 46);
}

- (void) addMapOverlay
{
    overlay.hidden = NO;
    
}

- (void) removeMapOverlay
{
    overlay.hidden = YES;
}

/**
 *  Clean up memory.
 *
 */
- (void) dealloc 
{
    [overlay release];
    [mapKit release];
    [navigateButton release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
