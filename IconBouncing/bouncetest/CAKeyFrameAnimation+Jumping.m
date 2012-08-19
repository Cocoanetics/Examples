//
//  CAKeyFrameAnimation+Jumping.m
//  bouncetest
//
//  Created by Oliver Drobnik on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CAKeyframeAnimation+Jumping.h"
#import <QuartzCore/QuartzCore.h>

@implementation CAKeyframeAnimation (Jumping)

+ (CAKeyframeAnimation *)jumpAnimation
{
	// these three values are subject to experimentation
	CGFloat initialMomentum = 300.0f; // positive is upwards, per sec
	CGFloat gravityConstant = 250.0f; // downwards pull per sec
	CGFloat dampeningFactorPerBounce = 0.6;  // percent of rebound
	
	// internal values for the calculation
	CGFloat momentum = initialMomentum; // momentum starts with initial value
	CGFloat positionOffset = 0; // we begin at the original position
	CGFloat slicesPerSecond = 60.0f; // how many values per second to calculate
	CGFloat lowerMomentumCutoff = 5.0f; // below this upward momentum animation ends
	
	CGFloat duration = 0;
	NSMutableArray *values = [NSMutableArray array];
	
	do
	{
		duration += 1.0f/slicesPerSecond;
		positionOffset+=momentum/slicesPerSecond;
		
		if (positionOffset<0)
		{
			positionOffset=0;
			momentum=-momentum*dampeningFactorPerBounce;
		}
		
		// gravity pulls the momentum down
		momentum -= gravityConstant/slicesPerSecond;
		
		CATransform3D transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
		[values addObject:[NSValue valueWithCATransform3D:transform]];
	} while (!(positionOffset==0 && momentum < lowerMomentumCutoff));
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.repeatCount = 1;
	animation.duration = duration;
	animation.fillMode = kCAFillModeForwards;
	animation.values = values;
	animation.removedOnCompletion = YES; // final stage is equal to starting stage
	animation.autoreverses = NO;
	
	return animation;
}

+ (CAKeyframeAnimation *)dockBounceAnimationWithIconHeight:(CGFloat)iconHeight
{
	CGFloat factors[32] = {0, 32, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32,
		0, 24, 42, 54, 62, 64, 62, 54, 42, 24, 0, 18, 28, 32, 28, 18, 0};
	
	NSMutableArray *values = [NSMutableArray array];
	
	for (int i=0; i<32; i++)
	{
		CGFloat positionOffset = factors[i]/128.0f * iconHeight;
		
		CATransform3D transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
		[values addObject:[NSValue valueWithCATransform3D:transform]];
	}
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.repeatCount = 1;
	animation.duration = 32.0f/30.0f;
	animation.fillMode = kCAFillModeForwards;
	animation.values = values;
	animation.removedOnCompletion = YES; // final stage is equal to starting stage
	animation.autoreverses = NO;
	
	return animation;
}

@end
