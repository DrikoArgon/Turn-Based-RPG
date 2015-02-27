//
//  BallEnemy.h
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Enemy.h"

@interface BallEnemy : Enemy

+(id)ballEnemy;
-(void)naturalBehavior;

@end
