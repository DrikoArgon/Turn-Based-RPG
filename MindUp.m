//
//  MindUp.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/27/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "MindUp.h"

@implementation MindUp

+(id)newMagic{
    
    MindUp *magic = [MindUp node];
    magic.type = @"buff";
    magic.name = @"Mind Up";
    magic.changeStr = 0;
    magic.changeAgi = 0;
    magic.changeMag = 3;
    magic.changeDex = 0;
    magic.changeEnd = 0;
    magic.changeRes = 0;
    magic.mpCost = 3;
    magic.animationSeconds = 2;
    
    magic.particleName = @"MindUp";
    
    return magic;
}

@end
