//
//  GameScene.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/18/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <Firebase/Firebase.h>
#import "GameScene.h"
#import "HUD.h"
#import "Player.h"
#import "Tree.h"
#import "BallEnemy.h"
#import "BattleScreen.h"
#import "Greenie.h"

@interface GameScene ()

@property SKNode *world;
@property HUD *hud;
@property Player *player;
@property SKNode *treeLayer;
@property Firebase *firebase;
@property NSUserDefaults *savedInformation;

@end

static NSString * const PLAYER_X_POSITION_KEY = @"playerX";
static NSString * const PLAYER_Y_POSITION_KEY = @"playerY";

static const uint32_t PLAYER_CATEGORY = 0x1;
static const uint32_t ENEMY_CATEGORY = 0x1 << 1;


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.savedInformation = [NSUserDefaults standardUserDefaults];

    self.firebase = [[Firebase alloc] initWithUrl:@"https://sweltering-heat-197.firebaseio.com"];
    
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    self.world = [SKNode node];
    self.world.zPosition = -10;
    [self addChild:self.world];
    
    self.backgroundColor = [UIColor blueColor];
    
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"testMap"];
    [self.world addChild:floor];
    
    self.treeLayer = [SKNode node];
    self.treeLayer.zPosition = 1;
    [self.treeLayer setScale:1.5];
    [self addChild:self.treeLayer];
    
    self.hud = [HUD hud];
    [self addChild:self.hud];
    self.hud.zPosition = 5;
    [self.hud insertMapHudElements];
    
    self.player = [Player player];
//    self.player.position = CGPointMake([self.savedInformation floatForKey:PLAYER_X_POSITION_KEY],
//                                       [self.savedInformation floatForKey:PLAYER_Y_POSITION_KEY]);
//
    //oi
    [self.firebase observeEventType:FEventTypeChildChanged andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
        
        NSNumber *playerX = snapshot.value[@"PlayerX"];
        NSNumber *playerY = snapshot.value[@"PlayerY"];
        NSNumber *playerCurrentExp = snapshot.value[@"CurrentExp"];
        CGFloat playerXf = [playerX floatValue];
        CGFloat playerYf = [playerY floatValue];
        
        
        self.player.position = CGPointMake(playerXf,playerYf);
        self.player.currentExp = [playerCurrentExp intValue];
        
        
    }];
    NSLog(@"PlayerX:%f  PlayerY:%f",self.player.position.x,self.player.position.y);
    
    self.player.physicsBody.categoryBitMask = PLAYER_CATEGORY;
    self.player.physicsBody.contactTestBitMask = ENEMY_CATEGORY;
    [self.world addChild:self.player];
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/forestMaze.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/battlestart.wav", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.musicPlayer.numberOfLoops = -1;
    
    self.soundPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url2 error:&error];
    self.soundPlayer.numberOfLoops = 0;
    
    [self.musicPlayer play];
    
    
    Tree *tree = [Tree treeWithImage:@"tree1"];
    tree.position = CGPointMake(100,0);
    [self.treeLayer addChild:tree];
    
    BallEnemy *enemy = [BallEnemy ballEnemy];
    enemy.position = CGPointMake(-20, 50);
    enemy.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    [self.world addChild:enemy];
    
    Greenie *enemy2 = [Greenie greenie];
    enemy2.position = CGPointMake(50,0);
    enemy2.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    [self.world addChild:enemy2];
    
    [enemy naturalBehavior];
    [enemy2 naturalBehavior];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        SKNode *n = [self.hud nodeAtPoint:[touch locationInNode:self.hud]];
        
        if ([n.name isEqualToString:@"rightButton"]) {
            [self.player walkRight];
        }
        else if([n.name isEqualToString:@"leftButton"]){
            [self.player walkLeft];
        }
        else if([n.name isEqualToString:@"upButton"]){
            [self.player walkUp];
        }
        else if([n.name isEqualToString:@"downButton"]){
            [self.player walkDown];
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        SKNode *n = [self.hud nodeAtPoint:[touch locationInNode:self.hud]];
        
        if ([n.name isEqualToString:@"rightButton"]) {
            [self.player removeActionForKey:@"walkRight"];
            [self.player removeActionForKey:@"walkLeft"];
            [self.player removeActionForKey:@"walkUp"];
            [self.player removeActionForKey:@"walkDown"];
            [self.player removeActionForKey:@"walkAnimation"];
        }
        else if([n.name isEqualToString:@"leftButton"]){
            [self.player removeActionForKey:@"walkRight"];
            [self.player removeActionForKey:@"walkLeft"];
            [self.player removeActionForKey:@"walkUp"];
            [self.player removeActionForKey:@"walkDown"];
            [self.player removeActionForKey:@"walkAnimation"];
        }
        else if([n.name isEqualToString:@"upButton"]){
            [self.player removeActionForKey:@"walkRight"];
            [self.player removeActionForKey:@"walkLeft"];
            [self.player removeActionForKey:@"walkUp"];
            [self.player removeActionForKey:@"walkDown"];
            [self.player removeActionForKey:@"walkAnimation"];
            
        }
        else if([n.name isEqualToString:@"downButton"]){
            [self.player removeActionForKey:@"walkRight"];
            [self.player removeActionForKey:@"walkLeft"];
            [self.player removeActionForKey:@"walkUp"];
            [self.player removeActionForKey:@"walkDown"];
            [self.player removeActionForKey:@"walkAnimation"];
            
        }
        else{
            
            [self.player removeAllActions];
            
        }
        
    }
    
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask )
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == PLAYER_CATEGORY && secondBody.categoryBitMask == ENEMY_CATEGORY) {
        
//        [self.savedInformation setFloat:self.player.position.x forKey:PLAYER_X_POSITION_KEY];
//        [self.savedInformation setFloat:self.player.position.y forKey:PLAYER_Y_POSITION_KEY];
        NSDictionary *playerInformation = @{
                                            @"PlayerX" : [NSNumber numberWithFloat:self.player.position.x],
                                            @"PlayerY" : [NSNumber numberWithFloat:self.player.position.y],
                                            @"CurrentExp" : [NSNumber numberWithFloat:self.player.currentExp]
                                            };
        
        Firebase *playerRef = [self.firebase childByAppendingPath:@"/Player"];
        [playerRef setValue:playerInformation];
        
        
        
        if (!self.battleWon) {
            
            [self iniciateBattleWithEnemy:secondBody.node.name];
        }
        else{
            
            [secondBody.node removeFromParent];
            self.battleWon = NO;
        }
        
        
    }
    
}
-(void)iniciateBattleWithEnemy:(NSString *)enemyName{
    
    BattleScreen *scene = [[BattleScreen alloc] initWithSize:self.frame.size
                                                withBackground:@"grassFloor" enemy:enemyName
                                                maxNumberOfEnemies:3];
    
    scene.anchorPoint = CGPointMake(0.5, 0.5);
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [self.musicPlayer stop];
    [self.soundPlayer play];
    
    SKTransition *reveal = [SKTransition fadeWithDuration:1];
    [self.view presentScene:scene transition: reveal];
    
}

-(void)didSimulatePhysics{
    
    [self centerOnNode:self.player];
    
}

-(void)centerOnNode:(SKNode *)node{
    
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    
    self.world.position = CGPointMake(self.world.position.x - positionInScene.x, self.world.position.y - positionInScene.y);
    self.treeLayer.position = CGPointMake(self.treeLayer.position.x - positionInScene.x, self.treeLayer.position.y - positionInScene.y);
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
