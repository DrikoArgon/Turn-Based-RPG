//
//  Sharpen.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/27/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Sharpen.h"

@implementation Sharpen

+(id)newMagic{
    
    Sharpen *magic = [Sharpen node];
    magic.type = @"buff";
    magic.name = @"Sharpen";
    magic.changeStr = 0;
    magic.changeAgi = 0;
    magic.changeMag = 0;
    magic.changeDex = 3;
    magic.changeEnd = 0;
    magic.changeRes = 0;
    magic.mpCost = 3;
    magic.animationSeconds = 2;
    
    magic.particleName = @"Sharpen";
    
    return magic;
}

@end
