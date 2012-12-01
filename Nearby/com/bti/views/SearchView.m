//
//  MapView.m
//  Nearby
//
//  Created by Christopher Black on 11/26/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

@synthesize searchBar;
@synthesize gradient;
@synthesize overlay;
@synthesize mapKit;                   // MapKit instance
@synthesize searchField;
@synthesize navigateButton;   // Button in lower left. Jumps to current position.

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
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
        // Add the map to the view/
        [self addSubview:mapKit];
        
        overlay = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        overlay.autoresizesSubviews = YES;
        overlay.alpha = OVERLAY_ALPHA;
        overlay.hidden = YES;
        [self addSubview:overlay];
        
        searchBar = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y, self.bounds.size.width, 48)];
        gradient = [CAGradientLayer layer];
        gradient.frame = searchBar.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
        searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        searchBar.autoresizesSubviews = YES;
        [searchBar.layer insertSublayer:gradient atIndex:0];
        //[self addSubview:searchBar];
        
        searchField = [[UITextField alloc] initWithFrame:CGRectMake(6,6, self.bounds.size.width - 12, 32)];
        searchField.placeholder = SEARCH_PLACEHOLDER;
        searchField.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        searchField.returnKeyType = UIReturnKeyDone;
        searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchField.clearButtonMode = UITextFieldViewModeAlways;
        //[searchBar addSubview:searchField];

        navigateButton = [[UIButton alloc] init];
        [navigateButton setBackgroundImage: [UIImage imageNamed:@"disabled.png"] forState: UIControlStateDisabled];
        [navigateButton setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
        [navigateButton setBackgroundImage:[UIImage imageNamed:@"selected_green.png"] forState:UIControlStateSelected];
        [navigateButton setBackgroundImage: [UIImage imageNamed:@"normal_down.png"] forState: UIControlStateHighlighted];
        [navigateButton setBackgroundImage: [UIImage imageNamed:@"selected_green.png"] forState: UIControlStateHighlighted | UIControlStateSelected];
        navigateButton.frame = CGRectMake(4,self.bounds.size.height - 44, 40, 40);
        [self addSubview:navigateButton];
        
    }
    return self;
}

/**
 *  Position gradient and navigate button.
 *
 */
- (void) layoutSubviews
{
    gradient.frame = searchBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
    navigateButton.frame = CGRectMake(4,self.bounds.size.height - 50, 46, 46);
    [super layoutSubviews];
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
    [searchBar release];
    [gradient release];
    [overlay release];
    [mapKit release];
    [searchField release];
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
