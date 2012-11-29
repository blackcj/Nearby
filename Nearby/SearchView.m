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
        
        overlay = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,40, self.bounds.size.width, self.bounds.size.height - 40)];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        overlay.autoresizesSubviews = YES;
        overlay.alpha = 0.5;
        overlay.hidden = YES;
        [self addSubview:overlay];
        
        searchBar = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y, self.bounds.size.width, 48)];
        gradient = [CAGradientLayer layer];
        gradient.frame = searchBar.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
        searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        searchBar.autoresizesSubviews = YES;
        [searchBar.layer insertSublayer:gradient atIndex:0];
        [self addSubview:searchBar];
        
        searchField = [[UITextField alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 6,self.bounds.origin.y + 6, self.bounds.size.width - 12, 36)];
        //searchField.autoresizesSubviews = YES;
        searchField.placeholder = @"Search";
        searchField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        searchField.returnKeyType = UIReturnKeyDone;
        //searchField.placeholder = inPlaceholder;
        searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchField.clearButtonMode = UITextFieldViewModeAlways;
        [searchBar addSubview:searchField];

        navigateButton = [[UIButton alloc] init];
        [navigateButton setBackgroundImage:[UIImage imageNamed:@"49.png"] forState:UIControlStateNormal];
        [navigateButton setBackgroundImage:[UIImage imageNamed:@"50.png"] forState:UIControlStateSelected];
        //navigateButton.selected 
        navigateButton.frame = CGRectMake(4,self.bounds.size.height - 44, 40, 40);
        [self addSubview:navigateButton];
        
    }
    return self;
}

/*
 Position
 
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
