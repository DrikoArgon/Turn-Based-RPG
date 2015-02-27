//
//  GameScene.h
//  Turn Based RPG
//

//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) BOOL battleWon;
@property (nonatomic) int numberOfPlayers;
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;

@end
