//
//  Player.h
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Enemy;

@interface Player : SKSpriteNode

@property int level;
@property int expNeeded;
@property int currentExp;

@property (nonatomic) int maxhp;
@property (nonatomic) int currentHp;
@property (nonatomic) int maxMp;
@property (nonatomic) int currentMp;

@property (nonatomic) int str;
@property (nonatomic) int agi;
@property (nonatomic) int mag;
@property (nonatomic) int dex;
@property (nonatomic) int res;
@property (nonatomic) int end;

@property (nonatomic) int magicDef;
@property (nonatomic) int Def;

@property NSMutableArray *magic;
@property (nonatomic) int turn;

+(id)player;
-(void)walkLeft;
-(void)walkRight;
-(void)walkUp;
-(void)walkDown;
-(void)moveAnimation;
-(void)moveAnimationRight;
-(void)battleIdleAnimation;
-(void)attackEnemy:(Enemy *)enemy;

@end
