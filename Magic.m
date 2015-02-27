//
//  Magic.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/24/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Magic.h"
#import "Player.h"
#import "Enemy.h"
#import "AgilityBuff.h"
#import "Fortify.h"
#import "RockSkin.h"
#import "Sharpen.h"
#import "MindUp.h"
#import "Blessing.h"

@implementation Magic{
    
    SKScene *_currentScene;
}

+(Magic *)newMagicWithName:(NSString *)magicName{
    
    if ([magicName isEqualToString:@"Speed"]) {
        return [AgilityBuff newMagic];
    }
    else if([magicName isEqualToString:@"Fortify"]){
        return [Fortify newMagic];
    }
    else if([magicName isEqualToString:@"Rock Skin"]){
        return [RockSkin newMagic];
    }
    else if([magicName isEqualToString:@"Sharpen"]){
        return [Sharpen newMagic];
    }
    else if([magicName isEqualToString:@"Mind Up"]){
        return [MindUp newMagic];
    }
    else if([magicName isEqualToString:@"Blessing"]){
        return [Blessing newMagic];
    }
    
    return nil;
}

-(BOOL)executeMagicOnTarget:(id)target by:(id)user onScene:(SKScene *)scene{
    
    
    _currentScene = scene;
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/powerUp.wav", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.soundPlayer.numberOfLoops = 0;
    
    NSString *magicEmmiterPath = [[NSBundle mainBundle] pathForResource:self.particleName ofType:@"sks"];
    SKEmitterNode *magicEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:magicEmmiterPath];
    magicEmmitter.zPosition = 5;
    
    
    if ([user isMemberOfClass:[Player class]]){
        Player *currentUser = (Player *)user;
        
        if (currentUser.currentMp - self.mpCost >= 0) {
            
            currentUser.currentMp -= self.mpCost;
            if ([target isMemberOfClass:[Player class]]) {
                Player *currentTarget = (Player *)target;
                
                if ([self.type isEqualToString:@"buff"]) {
                    [self buffStats:target str:self.changeStr agi:self.changeAgi mag:self.changeMag dex:self.changeDex end:self.changeEnd res:self.changeRes];
                    
                    magicEmmitter.position = CGPointMake(currentTarget.position.x,
                                                         currentTarget.position.y - currentTarget.frame.size.height * 0.5);
                    [self.soundPlayer play];
                    [_currentScene addChild:magicEmmitter];
                    [self removeMagicWithDelay];
                    return YES;
                }
            }
            else{
                
                Enemy *currentTarget = (Enemy *)target;
                
                if ([self.type isEqualToString:@"buff"]) {
                    [self buffStats:target str:self.changeStr agi:self.changeAgi mag:self.changeMag dex:self.changeDex end:self.changeEnd res:self.changeRes];
                    
                    magicEmmitter.position = CGPointMake(currentTarget.position.x,
                                                         currentTarget.position.y - currentTarget.frame.size.height * 0.5);
                    [self.soundPlayer play];
                    [_currentScene addChild:magicEmmitter];
                    [self removeMagicWithDelay];
                    return YES;
                }
                
                
            }
            
        }
        else{
            
            NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/errorSound.wav", [[NSBundle mainBundle] resourcePath]]];
    
            self.failSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
            self.failSoundPlayer.numberOfLoops = 0;
            [self.failSoundPlayer play];
            
            return NO;
            
        }
    }
    else{
        
        if ([target isMemberOfClass:[Player class]]) {
            Player *currentTarget = (Player *)target;
            
            if ([self.type isEqualToString:@"buff"]) {
                [self buffStats:target str:self.changeStr agi:self.changeAgi mag:self.changeMag dex:self.changeDex end:self.changeEnd res:self.changeRes];
                
                magicEmmitter.position = CGPointMake(currentTarget.position.x,
                                                     currentTarget.position.y - currentTarget.frame.size.height * 0.5);
                [self.soundPlayer play];
                [_currentScene addChild:magicEmmitter];
                [self removeMagicWithDelay];
                return YES;
            }
        }
        else{
            
            Enemy *currentTarget = (Enemy *)target;
            
            if ([self.type isEqualToString:@"buff"]) {
                [self buffStats:target str:self.changeStr agi:self.changeAgi mag:self.changeMag dex:self.changeDex end:self.changeEnd res:self.changeRes];
                
                magicEmmitter.position = CGPointMake(currentTarget.position.x,
                                                     currentTarget.position.y - currentTarget.frame.size.height * 0.5);
                [self.soundPlayer play];
                [_currentScene addChild:magicEmmitter];
                [self removeMagicWithDelay];
                return YES;
            }
            
            
        }

        
    }
    
    
    return NO;
}
-(void)buffStats:(id)target str:(int)strModifier agi:(int)agiModifier mag:(int)magModifier dex:(int)dexModifier end:(int)endModifier res:(int)resModifier{
             
    if ([target isMemberOfClass:[Player class]]) {
        Player *currentTarget = (Player *)target;
        
        currentTarget.str += strModifier;
        currentTarget.agi += agiModifier;
        currentTarget.mag += magModifier;
        currentTarget.dex += dexModifier;
        currentTarget.end += endModifier;
        currentTarget.res += resModifier;
        
    }
    else{
        Enemy *currentTarget = (Enemy *)target;
        
        currentTarget.str += strModifier;
        currentTarget.agi += agiModifier;
        currentTarget.mag += magModifier;
        currentTarget.dex += dexModifier;
        currentTarget.end += endModifier;
        currentTarget.res += resModifier;
    }
   
    
    
}
-(void)removeMagicWithDelay{
    
    [self performSelector:@selector(removeMagic) withObject:self afterDelay:self.animationSeconds];
    
}
-(void)removeMagic{
    
    [self removeFromParent];
}

@end
