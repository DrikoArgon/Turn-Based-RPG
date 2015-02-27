//
//  HUD.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/18/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "HUD.h"

@implementation HUD

+(id)hud{
    
    HUD *hud = [HUD node];
    
    return hud;

    
}
-(void)insertMapHudElements{
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftButton"];
    leftButton.size = CGSizeMake(40, 40);
    leftButton.position = CGPointMake(-self.scene.frame.size.width * 0.5 + leftButton.size.width * 0.5 ,
                                      -self.scene.frame.size.height * 0.5 + leftButton.size.height * 0.5 + leftButton.size.height);
    leftButton.name = @"leftButton";
    [leftButton setAlpha:1];
    [self addChild:leftButton];
    
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightButton"];
    rightButton.size = CGSizeMake(leftButton.size.width, leftButton.size.height);
    rightButton.position = CGPointMake(-self.scene.frame.size.width * 0.5 + leftButton.size.width * 0.5 +           leftButton.size.width * 2,
                                      -self.scene.frame.size.height * 0.5 + leftButton.size.height * 0.5 + leftButton.size.height);
    rightButton.name = @"rightButton";
    [rightButton setAlpha:leftButton.alpha];
    [self addChild:rightButton];
    
    SKSpriteNode *downButton = [SKSpriteNode spriteNodeWithImageNamed:@"downButton"];
    downButton.size = CGSizeMake(leftButton.size.width, leftButton.size.height);
    downButton.position = CGPointMake(-self.scene.frame.size.width * 0.5 + leftButton.size.width * 0.5 +            leftButton.size.width,
                                       -self.scene.frame.size.height * 0.5 + leftButton.size.height * 0.5
                                      );
    downButton.name = @"downButton";
    [downButton setAlpha:leftButton.alpha];
    [self addChild:downButton];
    
    SKSpriteNode *upButton = [SKSpriteNode spriteNodeWithImageNamed:@"upButton"];
    upButton.size = CGSizeMake(leftButton.size.width, leftButton.size.height);
    upButton.position = CGPointMake(-self.scene.frame.size.width * 0.5 + leftButton.size.width * 0.5 +            leftButton.size.width,
                                      -self.scene.frame.size.height * 0.5 + leftButton.size.height * 0.5
                                      + leftButton.frame.size.height * 2);
    upButton.name = @"upButton";
    [upButton setAlpha:leftButton.alpha];
    [self addChild:upButton];
    
}


@end
