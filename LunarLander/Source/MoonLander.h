//
//  MoonLander.h
//  SKTest1
//
//  Created by Oliver Drobnik on 6/21/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 Apollo Lunar Lander modeled after http://en.wikipedia.org/wiki/Apollo_Lunar_Module
 */

@interface MoonLander : SKSpriteNode

@property (nonatomic, assign) BOOL mainThrusterEmitting;
@property (nonatomic, assign) BOOL ccwThrustersEmitting;
@property (nonatomic, assign) BOOL cwThrustersEmitting;

- (void)fireMainThrusterForDuration:(NSTimeInterval)duration;

- (void)fireCWThrustersForDuration:(NSTimeInterval)duration;

- (void)fireCCWThrustersForDuration:(NSTimeInterval)duration;


@end
