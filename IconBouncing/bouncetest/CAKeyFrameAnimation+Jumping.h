//
//  CAKeyFrameAnimation+Jumping.h
//  bouncetest
//
//  Created by Oliver Drobnik on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeAnimation (Jumping)

+ (CAKeyframeAnimation *)jumpAnimation;

+ (CAKeyframeAnimation *)dockBounceAnimationWithIconHeight:(CGFloat)iconHeight;

@end
