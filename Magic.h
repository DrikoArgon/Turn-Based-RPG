//
//  Magic.h
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/24/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Magic : SKSpriteNode

@property NSString *type;
@property int changeStr;
@property int changeAgi;
@property int changeMag;
@property int changeDex;
@property int changeEnd;
@property int changeRes;

@property int mpCost;
@property int animationSeconds;

@property NSString* particleName;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
@property (strong, nonatomic) AVAudioPlayer *failSoundPlayer;

+(Magic *)newMagicWithName:(NSString *)magicName;
-(BOOL)executeMagicOnTarget:(id)target by:(id)user onScene:(SKScene *)scene;

@end
