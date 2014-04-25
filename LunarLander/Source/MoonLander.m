//
//  MoonLander.m
//  SKTest1
//
//  Created by Oliver Drobnik on 6/21/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "MoonLander.h"
#import "NSBezierPath+Utils.h"

#define MASS_KG 14696
#define PROPULSION_MAIN_N 30000

@implementation MoonLander
{
	SKEmitterNode *_thrusterEmitter;
	
	SKEmitterNode *_rightUpThrusterEmitter;
	SKEmitterNode *_rightDownThrusterEmitter;
	SKEmitterNode *_leftUpThrusterEmitter;
	SKEmitterNode *_leftDownThrusterEmitter;
	
	CGFloat _scale;
}

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		SKTexture *texture = [SKTexture textureWithImageNamed:@"Lander_0001"];
		self.texture = texture;
		self.size = texture.size;

		_thrusterEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Thruster" ofType:@"sks"]];
		_thrusterEmitter.position = CGPointMake(0, -130);
		_thrusterEmitter.zRotation = M_PI;
		
		_rightUpThrusterEmitter = [_thrusterEmitter copy];
		_rightUpThrusterEmitter.position = CGPointMake(63, 60);
		_rightUpThrusterEmitter.zRotation = 0;
		_rightUpThrusterEmitter.scale = 0.3;
		
		_leftUpThrusterEmitter = [_rightUpThrusterEmitter copy];
		_leftUpThrusterEmitter.position = CGPointMake(-71, 60);
		_leftUpThrusterEmitter.zRotation = 0;
		
		_leftDownThrusterEmitter = [_leftUpThrusterEmitter copy];
		_leftDownThrusterEmitter.zRotation = M_PI;
		_leftDownThrusterEmitter.position = CGPointMake(-72, 31);
		
		_rightDownThrusterEmitter = [_rightUpThrusterEmitter copy];
		_rightDownThrusterEmitter.position = CGPointMake(63, 30);
		_rightDownThrusterEmitter.zRotation = M_PI;

		
		[self _updatePhysicsBody];
	}
	
	return self;
}


- (void)_updatePhysicsBody
{
	CGPathRef path = [self newPhysicsOutlinePathForScale:_scale];
	self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
	CGPathRelease(path);
	
	self.physicsBody.friction = 1;
	self.physicsBody.linearDamping = 0;
	self.physicsBody.angularDamping = 0;
	self.physicsBody.usesPreciseCollisionDetection = YES;
	
	self.physicsBody.mass = MASS_KG;
}

- (CGPathRef)newPhysicsOutlinePathForScale:(CGFloat)scale
{
	CGSize textureSize = self.texture.size;
	CGSize scaledSize = self.size;
	
	CGFloat factor = scaledSize.width / textureSize.width;
	
	CGMutablePathRef mutablePath = CGPathCreateMutable();
	CGAffineTransform transform = CGAffineTransformMakeTranslation(-scaledSize.width/2.0, -scaledSize.height/2.0);
	CGPathMoveToPoint(mutablePath, &transform, 197*factor, 286.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 172.5*factor, 295.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 88.5*factor, 251.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 8.5*factor, 26.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 32.5*factor, 21.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 337.5*factor, 20.5*factor);
	
	CGPathAddLineToPoint(mutablePath, &transform, 348.5*factor, 26.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 264.5*factor, 191.5*factor);
	CGPathAddLineToPoint(mutablePath, &transform, 232.5*factor, 248.5*factor);

	CGPathCloseSubpath(mutablePath);
	
	return mutablePath;
}

- (void)setScale:(CGFloat)scale
{
	[super setScale:scale];
	
	_scale = scale;
	
	[self _updatePhysicsBody];
}


#pragma mark - Public Interface


- (void)fireMainThrusterForDuration:(NSTimeInterval)duration
{
	CGFloat thrust = PROPULSION_MAIN_N * duration * 10000;
	
	CGFloat shipDirection = self.zRotation + M_PI_2;
	CGVector thrustVector = CGVectorMake(thrust*cosf(shipDirection), thrust*sinf(shipDirection));
	[self.physicsBody applyForce:thrustVector];
}

- (void)fireCWThrustersForDuration:(NSTimeInterval)duration
{
	CGFloat torque = 5000 * _scale;
	
	[self.physicsBody applyTorque:-torque];
}

- (void)fireCCWThrustersForDuration:(NSTimeInterval)duration
{
	CGFloat torque = 5000 * _scale;
	
	[self.physicsBody applyTorque:torque];
}

- (void)setMainThrusterEmitting:(BOOL)mainThrusterEmitting
{
	if (_mainThrusterEmitting != mainThrusterEmitting)
	{
		_mainThrusterEmitting = mainThrusterEmitting;
		
		
		if (_mainThrusterEmitting)
		{
			[self addChild:_thrusterEmitter];
		}
		else
		{
			[_thrusterEmitter removeFromParent];
		}
	}
}

- (void)setCwThrustersEmitting:(BOOL)cwThrustersEmitting
{
	if (_cwThrustersEmitting == cwThrustersEmitting)
	{
		return;
	}
	
	_cwThrustersEmitting = cwThrustersEmitting;
	
	if (_cwThrustersEmitting)
	{
		[self addChild:_rightUpThrusterEmitter];
		[self addChild:_leftDownThrusterEmitter];
	}
	else
	{
		[_rightUpThrusterEmitter removeFromParent];
		[_leftDownThrusterEmitter removeFromParent];
	}
}

- (void)setCcwThrustersEmitting:(BOOL)ccwThrustersEmitting
{
	if (_ccwThrustersEmitting == ccwThrustersEmitting)
	{
		return;
	}
	
	_ccwThrustersEmitting = ccwThrustersEmitting;
	
	if (_ccwThrustersEmitting)
	{
		[self addChild:_rightDownThrusterEmitter];
		[self addChild:_leftUpThrusterEmitter];
	}
	else
	{
		[_rightDownThrusterEmitter removeFromParent];
		[_leftUpThrusterEmitter removeFromParent];
	}
}


@end
