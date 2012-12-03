//
//  DetailViewController.m
//  Nearby
//
//  Created by Christopher Black on 12/1/12.
//  Copyright (c) 2012 Blacktop Interactive, LLC. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize detailView;
@synthesize marker;

- (id)initWithMarker:(MapMarker *)mapMarker
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.marker = mapMarker;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:marker.title];
    // Create view and add delegates
    CGRect rect = [UIScreen mainScreen].applicationFrame; 
    self.detailView = [[DetailView alloc] initWithFrame:rect];
    self.view = self.detailView;
    self.navigationController.navigationBar.hidden = NO;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:marker.icon]]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    [imageView setCenter:CGPointMake(CGRectGetMidX([self.view bounds]), 60.0)];
}

- (void)viewDidUnload
{
    [marker release];
    [detailView release];
    [super viewDidUnload];
}

- (void)dealloc
{
    [marker release];
    [detailView release];
    [super viewDidUnload];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
