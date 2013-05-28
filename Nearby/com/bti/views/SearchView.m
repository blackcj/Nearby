//
//  MapView.m
//  Nearby
//
//  Created by Christopher Black on 11/26/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.autoresizesSubviews = YES;
        //self.frame = frame;
        
        self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(6,6, self.bounds.size.width - 12, 32)];
        self.searchField.placeholder = SEARCH_PLACEHOLDER;
        self.searchField.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.searchField.borderStyle = UITextBorderStyleRoundedRect;
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.searchField.returnKeyType = UIReturnKeyDone;
        self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchField.clearButtonMode = UITextFieldViewModeAlways;
        // SearchField added to the navigationBar
        
    }
    return self;
}

/**
 *  Clean up memory.
 *
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
