//
//  BallEnemy.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "BallEnemy.h"

@interface BallEnemy ()

@end

@implementation BallEnemy

+(id)ballEnemy{
    
    BallEnemy *enemy = [BallEnemy spriteNodeWithImageNamed:@"ballmove1"];
    enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:16];
    enemy.name = @"ballEnemy";
    enemy.dead = NO;
    enemy.turn = -1;
    enemy.maxhp = 1;
    enemy.currentHp = 1;
    enemy.expGiven = 1;
    enemy.agi = 2;
    enemy.textureAtlasName = @"ballenemymove";
    enemy.frameName = @"ballmove";
    return enemy;
}

-(void)naturalBehavior{
    
    float currentScale = self.xScale;
    
    [self moveAnimation];
    
    SKAction *walkLeft = [SKAction sequence:@[[SKAction moveByX:self.position.x - 300 y:0 duration:3],[SKAction scaleXTo:currentScale * -1 duration:0]]];
    
    currentScale = self.xScale * -1;
    
    SKAction *walkRight = [SKAction sequence:@[[SKAction moveByX:self.position.x + 300 y:0 duration:3],[SKAction scaleXTo:currentScale * -1 duration:0]]];
    
    
    
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[walkLeft,walkRight]]]];
                                         
    
    
}

@end
