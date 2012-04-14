//
//  PageViewController.m
//  Container
//
//  Created by Oliver Drobnik on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
	// set up the base view
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	label.backgroundColor = [UIColor yellowColor];
	label.numberOfLines = 0; // multiline
	label.textAlignment = UITextAlignmentCenter;

	// let's just have this view description
	label.text = [self description];
	self.view = label;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	NSLog(@"willMove");
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	NSLog(@"didMove");
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@"viewDidDisappear");
}

@end
