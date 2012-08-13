//
//  DTViewController.m
//  threedee2
//
//  Created by Oliver Drobnik on 11.08.12.
//  Copyright (c) 2012 Oliver Drobnik. All rights reserved.
//

#import "DTViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DTViewController ()

@end

@implementation DTViewController
{
	CATransformLayer *baseLayer;
	CALayer *greenLayer;
	CALayer *magentaLayer;
	CALayer *blueLayer;
	CALayer *yellowLayer;
	CALayer *purpleLayer;
	
	BOOL isThreeDee;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
	[self.view addGestureRecognizer:pan];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self.view addGestureRecognizer:tap];
	
	UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
	[self.view addGestureRecognizer:pinch];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	baseLayer = [CATransformLayer layer];
	baseLayer.anchorPoint = CGPointZero;
	baseLayer.bounds = self.view.bounds;
	baseLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	
	[self.view.layer addSublayer:baseLayer];
	
	CALayer *redLayer = [CALayer layer];
	redLayer.backgroundColor = [UIColor redColor].CGColor;
	redLayer.frame = CGRectMake(0, 0, 100, 100);
	redLayer.position = CGPointMake(0,0);
	[baseLayer addSublayer:redLayer];
	
	blueLayer = [CALayer layer];
	blueLayer.backgroundColor = [UIColor blueColor].CGColor;
	blueLayer.bounds = CGRectMake(0, 0, 100, 100);
	blueLayer.anchorPoint = CGPointMake(1, 0.5); // right
	blueLayer.position = CGPointMake(-50,0);
	[baseLayer addSublayer:blueLayer];
	
	yellowLayer = [CALayer layer];
	yellowLayer.backgroundColor = [UIColor purpleColor].CGColor;
	yellowLayer.bounds = CGRectMake(0, 0, 100, 100);
	yellowLayer.anchorPoint = CGPointMake(0.5, 1); // bottom
	yellowLayer.position = CGPointMake(0,-50);
	[baseLayer addSublayer:yellowLayer];
	
	purpleLayer = [CALayer layer];
	purpleLayer.backgroundColor = [UIColor yellowColor].CGColor;
	purpleLayer.bounds = CGRectMake(0, 0, 100, 100);
	purpleLayer.anchorPoint = CGPointMake(0.5, 0); // top
	purpleLayer.position = CGPointMake(0,50);
	[baseLayer addSublayer:purpleLayer];
	
	// need a transform layer for green to mount magenta on
	greenLayer = [CATransformLayer layer];
	greenLayer.bounds = CGRectMake(0, 0, 100, 100);
	greenLayer.anchorPoint = CGPointMake(0, 0.5); // left
	greenLayer.position = CGPointMake(50,0);
	[baseLayer addSublayer:greenLayer];
	
	CALayer *greenSolidLayer = [CALayer layer];
	greenSolidLayer.backgroundColor = [UIColor greenColor].CGColor;
	greenSolidLayer.bounds = CGRectMake(0, 0, 100, 100);
	greenSolidLayer.anchorPoint = CGPointMake(0, 0); // top left
	greenSolidLayer.position = CGPointMake(0,0);
	[greenLayer addSublayer:greenSolidLayer];
	
	// the "lid"
	magentaLayer = [CALayer layer];
	magentaLayer.backgroundColor = [UIColor magentaColor].CGColor;
	magentaLayer.bounds = CGRectMake(0, 0, 100, 100);
	magentaLayer.anchorPoint = CGPointMake(0, 0.5); // left
	magentaLayer.position = CGPointMake(100,50);
	[greenLayer addSublayer:magentaLayer];
	
	CATransform3D initialTransform = baseLayer.sublayerTransform;
	initialTransform.m34 = 1.0 / -1200;
	baseLayer.sublayerTransform = initialTransform;
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateChanged)
	{
		CGPoint displacement = [gesture translationInView:self.view.superview];
		CATransform3D currentTransform = baseLayer.sublayerTransform;
		
		if (displacement.x==0 && displacement.y==0)
		{
			// no rotation, nothing to do
			return;
		}
		
		CGFloat totalRotation = sqrt(displacement.x * displacement.x + displacement.y * displacement.y) * M_PI / 180.0;
		CGFloat xRotationFactor = displacement.x/totalRotation;
		CGFloat yRotationFactor = displacement.y/totalRotation;
		
		
		if (isThreeDee)
		{
			currentTransform = CATransform3DTranslate(currentTransform, 0, 0, 50);
		}
		
		CATransform3D rotationalTransform = CATransform3DRotate(currentTransform, totalRotation,
																				  (xRotationFactor * currentTransform.m12 - yRotationFactor * currentTransform.m11),
																				  (xRotationFactor * currentTransform.m22 - yRotationFactor * currentTransform.m21),
																				  (xRotationFactor * currentTransform.m32 - yRotationFactor * currentTransform.m31));
		
		if (isThreeDee)
		{
			rotationalTransform = CATransform3DTranslate(rotationalTransform, 0, 0, -50);
		}
		
		[CATransaction setAnimationDuration:0];
		
		baseLayer.sublayerTransform = rotationalTransform;
		
		
		[gesture setTranslation:CGPointZero inView:self.view];
	}
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
	isThreeDee = !isThreeDee;
	
	if (isThreeDee)
	{
		greenLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
		blueLayer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
		yellowLayer.transform = CATransform3DMakeRotation(-M_PI_2, 1, 0, 0);
		purpleLayer.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
		magentaLayer.transform = CATransform3DMakeRotation(0.8*-M_PI_2, 0, 1, 0);
	}
	else
	{
		greenLayer.transform = CATransform3DIdentity;
		blueLayer.transform = CATransform3DIdentity;
		yellowLayer.transform = CATransform3DIdentity;
		purpleLayer.transform = CATransform3DIdentity;
		magentaLayer.transform = CATransform3DIdentity;
	}
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
	if (pinch.state == UIGestureRecognizerStateChanged)
	{
		//	currentTransform = baseLayer.sublayerTransform;
		
		NSLog(@"%f", pinch.scale);
	}
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
