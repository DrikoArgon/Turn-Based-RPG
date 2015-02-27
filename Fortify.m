//
//  Fortify.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/25/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Fortify.h"

@implementation Fortify

+(id)newMagic{
    
    Fortify *magic = [Fortify node];
    magic.type = @"buff";
    magic.name = @"Fortify";
    magic.changeStr = 3;
    magic.changeAgi = 0;
    magic.changeMag = 0;
    magic.changeDex = 0;
    magic.changeEnd = 0;
    magic.changeRes = 0;
    magic.mpCost = 3;
    magic.animationSeconds = 2;
    
    magic.particleName = @"Fortify";
    
    return magic;
}



@end
