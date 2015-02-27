//
//  AgilityBuff.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/24/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "AgilityBuff.h"

@implementation AgilityBuff

+(id)newMagic{
    
    AgilityBuff *magic = [AgilityBuff node];
    magic.type = @"buff";
    magic.name = @"Speed";
    magic.changeStr = 0;
    magic.changeAgi = 3;
    magic.changeMag = 0;
    magic.changeDex = 0;
    magic.changeEnd = 0;
    magic.changeRes = 0;
    magic.mpCost = 3;
    magic.animationSeconds = 2;
    
    magic.particleName = @"AgilityBuff";
    
    return magic;
}


@end
