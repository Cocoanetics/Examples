//
//  ContainerViewController.m
//  Container
//
//  Created by Oliver Drobnik on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController
{
	NSArray *_subViewControllers;
	UIViewController *_selectedViewController;
	UIView *_containerView;
}

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
	UIView *view = [[UIView alloc] initWithFrame:frame];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor blueColor];
	
	// set up content view a bit inset
	frame = CGRectInset(view.bounds, 0, 100);
	_containerView = [[UIView alloc] initWithFrame:frame];
	_containerView.backgroundColor = [UIColor redColor];
	_containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[view addSubview:_containerView];
	
	// from here on the container is automatically adjusting to the orientation
	self.view = view;
	
	// add gesture support
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[view addGestureRecognizer:swipeLeft];

	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[view addGestureRecognizer:swipeRight];
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	if (fromViewController == toViewController)
	{
		// cannot transition to same
		return;
	}
	
	// animation setup
	toViewController.view.frame = _containerView.bounds;
	toViewController.view.autoresizingMask = _containerView.autoresizingMask;

	// notify
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
	
	// transition
	[self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:10.0
							   options:UIViewAnimationOptionTransitionCurlDown
							animations:^{
							}
							completion:^(BOOL finished) {
								[toViewController didMoveToParentViewController:self];
								[fromViewController removeFromParentViewController];
							}];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		NSInteger index = [_subViewControllers indexOfObject:_selectedViewController];
		index = MIN(index+1, [_subViewControllers count]-1);
		
		UIViewController *newSubViewController = [_subViewControllers objectAtIndex:index];
		
		[self transitionFromViewController:_selectedViewController toViewController:newSubViewController];
		_selectedViewController = newSubViewController;
	}
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		NSInteger index = [_subViewControllers indexOfObject:_selectedViewController];
		index = MAX(index-1, 0);
		
		UIViewController *newSubViewController = [_subViewControllers objectAtIndex:index];
		
		[self transitionFromViewController:_selectedViewController toViewController:newSubViewController]; 
		_selectedViewController = newSubViewController;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (_selectedViewController.parentViewController == self)
	{
		// nowthing to do
		return;
	}
	
	// adjust the frame to fit in the container view
	_selectedViewController.view.frame = _containerView.bounds;
	
	// make sure that it resizes on rotation automatically
	_selectedViewController.view.autoresizingMask = _containerView.autoresizingMask;
	
	// add as child VC
	[self addChildViewController:_selectedViewController];
	
	// add it to container view, calls willMoveToParentViewController for us
	[_containerView addSubview:_selectedViewController.view];
	
	// notify it that move is done
	[_selectedViewController didMoveToParentViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark Properties

- (void)setSubViewControllers:(NSArray *)subViewControllers
{
	_subViewControllers = [subViewControllers copy];

	if (_selectedViewController)
	{
		// TODO: remove previous VC
	}
	
	_selectedViewController = [subViewControllers objectAtIndex:0];
	
	// cannot add here because the view might not have been loaded yet
}

@synthesize subViewControllers = _subViewControllers;

@end
