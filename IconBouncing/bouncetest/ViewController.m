//
//  ViewController.m
//  bouncetest
//
//  Created by Oliver Drobnik on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "CAKeyFrameAnimation+Jumping.h"


@interface ViewController ()

@end


@implementation ViewController

@synthesize bounceView;
@synthesize bounceButton;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	bounceView.layer.masksToBounds = NO;
	bounceView.clipsToBounds = NO;
	bounceView.layer.shadowColor = [UIColor blackColor].CGColor;
	bounceView.layer.shadowOffset = CGSizeMake(0, 5);
	bounceView.layer.shadowRadius = 5;
	bounceView.layer.shadowOpacity = 0.5;
	bounceView.layer.masksToBounds = NO;
	bounceView.clipsToBounds = NO;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
	
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)ease:(id)sender
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position" function:BounceEaseOut fromPoint:CGPointMake(bounceView.center.x, bounceView.center.y - 150.0) toPoint:bounceView.center keyframeCount:90];
	animation.duration = 1.5;
	[bounceView.layer addAnimation:animation forKey:@"easing"];
}

- (IBAction)bounce:(id)sender
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation dockBounceAnimationWithIconHeight:150];
	[bounceView.layer addAnimation:animation forKey:@"jumping"];
}

- (IBAction)jump:(id)sender
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation jumpAnimation];
	animation.duration = 1.5;
	[bounceView.layer addAnimation:animation forKey:@"jumping"];
}

@end
