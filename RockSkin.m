//
//  RockSkin.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/27/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "RockSkin.h"

@implementation RockSkin

+(id)newMagic{
    
    RockSkin *magic = [RockSkin node];
    magic.type = @"buff";
    magic.name = @"Rock Skin";
    magic.changeStr = 0;
    magic.changeAgi = 0;
    magic.changeMag = 0;
    magic.changeDex = 0;
    magic.changeEnd = 3;
    magic.changeRes = 0;
    magic.mpCost = 3;
    magic.animationSeconds = 2;
    
    magic.particleName = @"RockSkin";
    
    return magic;
}

@end
