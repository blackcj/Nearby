//
//  DetailView.m
//  Nearby
//
//  Created by Christopher Black on 12/1/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.autoresizesSubviews = YES;
        
    }
    return self;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for(UIView *subview in [self subviews]) {
        subview.center = self.center;
    }
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
