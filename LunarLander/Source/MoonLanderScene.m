//
//  MyScene.m
//  SKTest1
//
//  Created by Oliver Drobnik on 6/21/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "MoonLanderScene.h"
#import "MoonLander.h"

@implementation MoonLanderScene
{
	SKLabelNode *_messageLabel;
	SKSpriteNode *_ground;
	MoonLander *_spaceship;
	SKSpriteNode *_earth;
	
	BOOL _mainThrusterOn;
	BOOL _cwThrustersOn;
	BOOL _ccwThrustersOn;
	
	CFTimeInterval _lastUpdateTime;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size])
	 {
		 
		 CGRect frame = self.frame;
		 frame.size.height += 200;
		 frame.size.width += 400;
		 frame.origin.y = 50;
		 frame.origin.x -= 200;
		 self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
		// self.scaleMode = SKSceneScaleModeResizeFill;
		 
		 self.physicsWorld.gravity = CGVectorMake(0, -1.62);  // http://hypertextbook.com/facts/2004/MichaelRobbins.shtml
		 
		 SKSpriteNode *stars = [SKSpriteNode spriteNodeWithImageNamed:@"stars"];
		 //stars.anchorPoint = CGPointZero;
		 stars.position = CGPointMake(self.size.width/2, self.size.height/2);
		 stars.scale = 0.5;
		 [self addChild:stars];
		 
		 _earth = [SKSpriteNode spriteNodeWithImageNamed:@"earth_half"];
		 _earth.position = CGPointMake(900, 400);
		 _earth.scale = 0.3;
		 [self addChild:_earth];
		 self.backgroundColor = [NSColor blackColor];
		 
		 _ground = [SKSpriteNode spriteNodeWithImageNamed:@"moonpan"];
		 _ground.anchorPoint = CGPointZero;
		 //_ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
		 //_ground.physicsBody.affectedByGravity = NO;
		 _ground.position = CGPointMake(0, -50);
		 _ground.scale = 0.5;
		 [self addChild:_ground];
		 

		 SKShapeNode *ground = [[SKShapeNode alloc] init];
		 CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.frame.size.width, 10), NULL);
		 ground.path = path;
		 ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 10)];
		 ground.position = CGPointMake(0, -200);
		 ground.physicsBody.affectedByGravity = NO;
		 ground.physicsBody.mass = 100000;
		 
		 [self addChild:ground];
//		 
//		 
//		 self.physicsBody.affectedByGravity = NO;
//		 self.physicsBody.restitution = 0.1;
//		 self.physicsBody.friction = 1;
//		 self.physicsBody.linearDamping = 1;
		 
		 // initial game state = waiting to start
		 [self _updateSceneForGameState];

    }
    return self;
}

#pragma mark - Utilities

- (void)_showMessage:(NSString *)message
{
	if (!_messageLabel)
	{
		_messageLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
		_messageLabel.fontSize = 65;
		_messageLabel.position = CGPointMake(CGRectGetMidX(self.frame),
												 CGRectGetMidY(self.frame));
		
		[self addChild:_messageLabel];
	}
	
	_messageLabel.text = message;
}

- (void)_hideMessage
{
	[_messageLabel removeFromParent];
}

- (void)_showSpaceshipAtStart
{
	if (!_spaceship)
	{
		_spaceship = [[MoonLander alloc] init];
		
		_spaceship.position = CGPointMake(0, self.size.height);
		
		_spaceship.scale = 0.3;
	}

	[self addChild:_spaceship];
	
	_spaceship.physicsBody.velocity	= CGVectorMake(200, 0);
}

#pragma mark - Game State

- (void)_updateSceneForGameState
{
	switch (self.gameState)
	{
		case MoonLanderSceneStateWaitingToStart:
		{
			[self _showMessage:@"Press a key to Start"];
			break;
		}
			
		case MoonLanderSceneStatePlaying:
		{
			[self _hideMessage];
			
			[self _showSpaceshipAtStart];
			
			break;
		}
			
		default:
		{
			NSLog(@"not implemented");
		}
	}
}

- (void)setGameState:(MoonLanderSceneState)gameState
{
	if (gameState == _gameState)
	{
		return;
	}
	
	_gameState = gameState;
	
	[self _updateSceneForGameState];
}


#pragma mark - Game Loop

-(void)update:(CFTimeInterval)currentTime
{
	CFTimeInterval timeSinceLast = currentTime - _lastUpdateTime;
	_lastUpdateTime = currentTime;
	
	if (timeSinceLast > 1)
	{
		// first update
		timeSinceLast = 1.60;
	}
	
	if (_mainThrusterOn)
	{
		[_spaceship fireMainThrusterForDuration:timeSinceLast];
		
	}
	
	if (_cwThrustersOn)
	{
		[_spaceship fireCWThrustersForDuration:timeSinceLast];
	}
	
	if (_ccwThrustersOn)
	{
		[_spaceship fireCCWThrustersForDuration:timeSinceLast];
	}
}


#pragma mark - Actions

- (void)keyDown:(NSEvent *)event
{
	if (_gameState == MoonLanderSceneStateWaitingToStart)
	{
		self.gameState = MoonLanderSceneStatePlaying;
	}
	else if (_gameState == MoonLanderSceneStatePlaying)
	{
		NSString *theArrow = [event charactersIgnoringModifiers];
		unichar keyChar = 0;
		
		if ([theArrow length] == 1)
		{
			keyChar = [theArrow characterAtIndex:0];
			
			switch (keyChar)
			{
				case NSUpArrowFunctionKey:
					break;
					
				case NSLeftArrowFunctionKey:
				{
					_ccwThrustersOn = YES;
					_spaceship.ccwThrustersEmitting = YES;

					break;
				}
					
				case NSRightArrowFunctionKey:
				{
					_cwThrustersOn = YES;
					_spaceship.cwThrustersEmitting = YES;
					break;
				}
					
				case NSDownArrowFunctionKey:
				{
					_mainThrusterOn = YES;
					_spaceship.mainThrusterEmitting = YES;

					break;
				}
			}
		}
	}
}

- (void)keyUp:(NSEvent *)event
{
	if (_gameState == MoonLanderSceneStatePlaying)
	{
		NSString *theArrow = [event charactersIgnoringModifiers];
		unichar keyChar = 0;
		
		if ([theArrow length] == 1)
		{
			keyChar = [theArrow characterAtIndex:0];
			
			switch (keyChar)
			{
				case NSUpArrowFunctionKey:
					break;
				case NSLeftArrowFunctionKey:
				{
					_ccwThrustersOn = NO;
					_spaceship.ccwThrustersEmitting = NO;
					break;
				}
					
				case NSRightArrowFunctionKey:
				{
					_cwThrustersOn = NO;
					_spaceship.cwThrustersEmitting = NO;
					break;
				}

				case NSDownArrowFunctionKey:
				{
					_mainThrusterOn = NO;
					_spaceship.mainThrusterEmitting = NO;
					break;
				}
			}
		}
	}
}

-(void)mouseDown:(NSEvent *)event
{
	if (_gameState == MoonLanderSceneStateWaitingToStart)
	{
		self.gameState = MoonLanderSceneStatePlaying;
	}
}


@end
