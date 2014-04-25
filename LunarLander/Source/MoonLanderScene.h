//
//  MyScene.h
//  SKTest1
//

//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum
{
	MoonLanderSceneStateWaitingToStart = 0,
	MoonLanderSceneStatePlaying,
	MoonLanderSceneStateGameOver
} MoonLanderSceneState;


@interface MoonLanderScene : SKScene

@property (nonatomic, assign) MoonLanderSceneState gameState;

@end
