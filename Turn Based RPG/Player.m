//
//  Player.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Player.h"
#import "Enemy.h"
#import "Magic.h"

@interface Player ()

@property NSArray *moveAnimationFrames;
@property BOOL flipped;


@end

@implementation Player

+(id)player{
    
    
    Player *player = [Player spriteNodeWithImageNamed:@"move1"];
    player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:14];
    
    player.level = 1;
    
    player.maxhp = 30;
    player.currentHp = 30;
    player.maxMp = 10;
    player.currentMp = 10;
    
    player.currentExp = 0;
    player.expNeeded = 20;
    
    player.agi = 3;
    
    player.turn = -1;
    player.magic = [NSMutableArray array];
    [player.magic addObject:[Magic newMagicWithName:@"Speed"]];
    [player.magic addObject:[Magic newMagicWithName:@"Fortify"]];
    [player.magic addObject:[Magic newMagicWithName:@"Rock Skin"]];
    [player.magic addObject:[Magic newMagicWithName:@"Sharpen"]];
    [player.magic addObject:[Magic newMagicWithName:@"Mind Up"]];
    [player.magic addObject:[Magic newMagicWithName:@"Blessing"]];
    player.name = @"player";
    
    return player;
}
-(void)moveAnimation{
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *walkAtlas = [SKTextureAtlas atlasNamed:@"move"];
    for (int i = 1; i <= walkAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"move%d", i];
        SKTexture *temp = [walkAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    self.moveAnimationFrames = walkFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:self.moveAnimationFrames
                                                                    timePerFrame:0.2]]withKey:@"walkAnimation"];
    
}
-(void)moveAnimationRight{
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *walkAtlas = [SKTextureAtlas atlasNamed:@"moveRight"];
    for (int i = 1; i <= walkAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"move%d", i];
        SKTexture *temp = [walkAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    self.moveAnimationFrames = walkFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:self.moveAnimationFrames
                                                                    timePerFrame:0.2]]withKey:@"walkAnimation"];
    
}
-(void)walkRight
{
    
    [self moveAnimationRight];
    
    SKAction *incrementRight = [SKAction repeatActionForever:[SKAction moveByX:30 y:0 duration:0.3]];
    
    [self runAction:incrementRight withKey:@"walkRight"];
    
    if (!self.flipped){
        
        self.flipped = YES;
    }
    
    
}

-(void)walkLeft
{
    
    [self moveAnimation];
    
    SKAction *incrementLeft = [SKAction repeatActionForever:[SKAction moveByX:-30 y:0 duration:0.3]];
    [self runAction:incrementLeft withKey:@"walkLeft"];
    
    if (self.flipped){
        
        self.flipped = NO;
    }
    
}

-(void)walkUp
{
    
    if (self.flipped) {
        
        [self moveAnimationRight];
    }
    
    else{
     
        [self moveAnimation];
    }
    

    SKAction *incrementUp = [SKAction repeatActionForever:[SKAction moveByX:0 y:30 duration:0.3]];
    [self runAction:incrementUp withKey:@"walkUp"];
    
    
}

-(void)walkDown
{
    if (self.flipped) {
        
        [self moveAnimationRight];
    }
    
    else{
        
        [self moveAnimation];
    }
    
    SKAction *incrementDown = [SKAction repeatActionForever:[SKAction moveByX:0 y:-30 duration:0.3]];
    [self runAction:incrementDown withKey:@"walkDown"];
    
    
}
-(void)battleIdleAnimation{
    
    NSMutableArray *battleIdleFrames = [NSMutableArray array];
    SKTextureAtlas *battleIdleAtlas = [SKTextureAtlas atlasNamed:@"battleIdle"];
    for (int i = 1; i <= battleIdleAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"battleIdle%d", i];
        SKTexture *temp = [battleIdleAtlas textureNamed:textureName];
        [battleIdleFrames addObject:temp];
    }
    
    self.moveAnimationFrames = battleIdleFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:self.moveAnimationFrames
                                                                    timePerFrame:0.2]]withKey:@"walkAnimation"];
    
    
}
-(void)attackEnemy:(Enemy *)enemy{
    
    [self enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
        node.hidden = YES;
    }];
    [self enumerateChildNodesWithName:@"fillBar2" usingBlock:^(SKNode *node, BOOL *stop) {
        node.hidden = YES;
    }];
    
    
    
    CGPoint beforeAttackPosition = self.position;
    
    SKAction *attackAction = [SKAction moveTo:enemy.position duration:2];
    SKAction *returnToPosition = [SKAction moveTo:beforeAttackPosition duration:0];
    
    [self runAction:[SKAction sequence:@[attackAction,returnToPosition]]];
    
    [self performSelector:@selector(displayDamage:) withObject:enemy afterDelay:2.1];
    
    enemy.currentHp -= 1;
    
}
-(void)displayDamage:(Enemy *)attackedEnemy{
    
    CGPoint positionInScene = [attackedEnemy convertPoint:attackedEnemy.position fromNode:attackedEnemy.parent];
    
    SKLabelNode *damageLabel = [SKLabelNode labelNodeWithFontNamed:@"nevis"];
    damageLabel.text = @"1";
    damageLabel.name = @"damageLabel";
    damageLabel.fontSize = 12;
    damageLabel.fontColor = [UIColor blackColor];
    
    damageLabel.position = CGPointMake(positionInScene.x,positionInScene.y - attackedEnemy.frame.size.height);
    [attackedEnemy addChild:damageLabel];
    
    [self performSelector:@selector(removeDamage:) withObject:attackedEnemy afterDelay:0.5];
    
}
-(void)removeDamage:(Enemy *)attackedEnemy{
    
    [attackedEnemy enumerateChildNodesWithName:@"damageLabel" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
}
-(void)defineMagic{
    
    
    
    
}


@end
