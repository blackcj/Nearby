//
//  MapView.m
//  Nearby
//
//  Created by Christopher Black on 11/26/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

@synthesize searchField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.autoresizesSubviews = YES;
        //self.frame = frame;
        
        searchField = [[UITextField alloc] initWithFrame:CGRectMake(6,6, self.bounds.size.width - 12, 32)];
        searchField.placeholder = SEARCH_PLACEHOLDER;
        searchField.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        searchField.returnKeyType = UIReturnKeyDone;
        searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchField.clearButtonMode = UITextFieldViewModeAlways;
        // SearchField added to the navigationBar
        
    }
    return self;
}

/**
 *  Clean up memory.
 *
 */
- (void) dealloc 
{
    [searchField release];
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
