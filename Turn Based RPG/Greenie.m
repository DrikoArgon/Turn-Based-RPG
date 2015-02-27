//
//  Greenie.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/23/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Greenie.h"

@implementation Greenie

+(id)greenie{
    
    Greenie *enemy = [Greenie spriteNodeWithImageNamed:@"greenie1"];
    enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    enemy.name = @"greenie";
    enemy.dead = NO;
    enemy.turn = -1;
    enemy.maxhp = 2;
    enemy.expGiven = 2;
    enemy.currentHp = 2;
    enemy.agi = 5;
    enemy.textureAtlasName = @"greenieEnemyMove";
    enemy.frameName = @"greenie";
    return enemy;
}

-(void)naturalBehavior{
    
    
    [self moveAnimation];
    
    SKAction *walkDown = [SKAction sequence:@[[SKAction moveByX:0 y:self.position.y - 300 duration:3]]];
    
    SKAction *walkUp = [SKAction sequence:@[[SKAction moveByX:0 y:self.position.y + 300 duration:3]]];
    
    
    
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[walkDown,walkUp]]]];
    
    
    
}

@end
