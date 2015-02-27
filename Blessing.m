//
//  Blessing.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/27/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Blessing.h"

@implementation Blessing

+(id)newMagic{
    
    Blessing *magic = [Blessing node];
    magic.type = @"buff";
    magic.name = @"Blessing";
    magic.changeStr = 0;
    magic.changeAgi = 0;
    magic.changeMag = 0;
    magic.changeDex = 3;
    magic.changeEnd = 0;
    magic.changeRes = 0;
    magic.mpCost = 3;
    magic.animationSeconds = 2;
    
    magic.particleName = @"Blessing";
    
    return magic;
}

@end
