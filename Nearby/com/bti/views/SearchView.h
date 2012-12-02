//
//  MapView.h
//  Nearby
//
//  Created by Christopher Black on 11/26/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//
//  SUMMARY:
//  Contains all view elements and lays them out on the page. Auto resize is used when possible, layoutSubviews is used
//  when auto resize isn't possible on the display element.
//

#import <UIKit/UIKit.h>

#define SEARCH_PLACEHOLDER             @"Search"

@interface SearchView : UIView
{
    UITextField *searchField;
}

// 
@property (nonatomic, retain) UITextField *searchField;

@end
