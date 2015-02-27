//
//  BattleScreen.h
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BattleScreen : SKScene

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (strong, nonatomic) AVAudioPlayer *victoryMusicPlayer;
-(id)initWithSize:(CGSize)size withBackground:(NSString *)backgroundImageName enemy:(NSString *)enemyName maxNumberOfEnemies:(int) maxEnemies;

@end
