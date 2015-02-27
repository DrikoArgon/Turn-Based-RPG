//
//  Enemy.h
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/23/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@class Player;

@interface Enemy : SKSpriteNode

@property (nonatomic) int maxhp;
@property (nonatomic) int currentHp;
@property (nonatomic) BOOL dead;
@property (nonatomic) int str;
@property (nonatomic) int agi;
@property (nonatomic) int mag;
@property (nonatomic) int dex;
@property (nonatomic) int res;
@property (nonatomic) int end;

@property (nonatomic) int magicDef;
@property (nonatomic) int Def;

@property (nonatomic) int turn;

@property (nonatomic) NSString *textureAtlasName;
@property (nonatomic) NSString *frameName;

@property (nonatomic) NSString *attackTextureAtlasName;
@property (nonatomic) NSString *attackFrameName;

@property (nonatomic) NSString *deathTextureAtlasName;
@property (nonatomic) NSString *deathFrameName;

@property int expGiven;

@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
-(void)moveAnimation;
-(void)attackPlayer:(Player *)attackedPlayer;
+(Enemy *)newEnemyWithName:(NSString *)enemyName;
-(void)die;
@end
