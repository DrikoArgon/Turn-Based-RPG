//
//  Enemy.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/23/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Enemy.h"
#import "BallEnemy.h"
#import "Greenie.h"
#import "Player.h"

@implementation Enemy

+(Enemy *)newEnemyWithName:(NSString *)enemyName
{
    
    if ([enemyName isEqualToString:@"ballEnemy"]) {
        return [BallEnemy ballEnemy];
    }
    else if([enemyName isEqualToString:@"greenie"]){
        return [Greenie greenie];
    }
    
    
    
    return nil;
}

-(void)moveAnimation
{
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *walkAtlas = [SKTextureAtlas atlasNamed:self.textureAtlasName];
    
    for (int i = 1; i <= walkAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@%d", self.frameName, i];
        SKTexture *temp = [walkAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames
                                                                    timePerFrame:0.2]]withKey:@"moveAnimation"];
}
-(void)attackAnimation{
    
    [self removeActionForKey:@"moveAnimation"];
    
    NSMutableArray *attackFrames = [NSMutableArray array];
    SKTextureAtlas *attackAtlas = [SKTextureAtlas atlasNamed:self.attackTextureAtlasName];
    
    for (int i = 1; i <= attackAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@%d", self.attackFrameName, i];
        SKTexture *temp = [attackAtlas textureNamed:textureName];
        [attackFrames addObject:temp];
    }
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:attackFrames
                                                                    timePerFrame:0.2]] withKey:@"attackAnimation"];
}
-(void)deathAnimation{
    
    [self removeActionForKey:@"moveAnimation"];
    
    NSMutableArray *deathFrames = [NSMutableArray array];
    SKTextureAtlas *deathAtlas = [SKTextureAtlas atlasNamed:self.deathTextureAtlasName];
    
    for (int i = 1; i <= deathAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@%d", self.deathFrameName, i];
        SKTexture *temp = [deathAtlas textureNamed:textureName];
        [deathFrames addObject:temp];
    }
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:deathFrames
                                                                    timePerFrame:0.2]] withKey:@"deathAnimation"];
}
-(void)die{
    SKAction *deathAnimationAndSound = [SKAction group:@[[SKAction fadeAlphaTo:0 duration:1],[SKAction playSoundFileNamed:@"enemyDie.wav" waitForCompletion:NO]]];
    
    SKAction *dieAction = [SKAction sequence:@[[SKAction waitForDuration:3],deathAnimationAndSound,[SKAction removeFromParent]]];
    
    [self runAction:dieAction];
    
}

-(void)attackPlayer:(Player *)attackedPlayer{
    
    CGPoint beforeAttackPosition = self.position;
    
    SKAction *attackAction = [SKAction moveTo:attackedPlayer.position duration:2];
    SKAction *returnToPosition = [SKAction moveTo:beforeAttackPosition duration:0];
    
    [self runAction:[SKAction sequence:@[attackAction,returnToPosition]]];
    
    attackedPlayer.currentHp -= 2;
    
    [self performSelector:@selector(displayDamage:) withObject:attackedPlayer afterDelay:2.1];
    
}
-(void)displayDamage:(Player *)attackedPlayer{
    
    CGPoint positionInScene = [attackedPlayer convertPoint:attackedPlayer.position fromNode:attackedPlayer.parent];
    
    SKLabelNode *damageLabel = [SKLabelNode labelNodeWithFontNamed:@"nevis"];
    damageLabel.text = @"2";
    damageLabel.name = @"damageLabel";
    damageLabel.fontSize = 12;
    damageLabel.fontColor = [UIColor blackColor];
    
    damageLabel.position = CGPointMake(positionInScene.x,positionInScene.y - attackedPlayer.frame.size.height);
    [attackedPlayer addChild:damageLabel];
    
    [self performSelector:@selector(removeDamage:) withObject:attackedPlayer afterDelay:0.5];
    
}
-(void)removeDamage:(Player *)attackedPlayer{
    
    [attackedPlayer enumerateChildNodesWithName:@"damageLabel" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
}


@end
