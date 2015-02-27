//
//  BattleScreen.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import <Firebase/Firebase.h>
#import "BattleScreen.h"
#import "GameScene.h"
#import "Player.h"
#import "BallEnemy.h"
#import "Magic.h"

@interface BattleScreen ()

@property SKSpriteNode *background;
@property SKSpriteNode *battleMenu;
@property SKSpriteNode *optionMenu;
@property NSString *fontName;
@property NSString *enemyName;
@property NSArray *turnOrder;
@property int turnIndex;
@property int numberOfTurns;
@property NSMutableArray *numberOfEnemies; //Guarda todos os inimigos
@property NSMutableArray *numberOfPlayers;
@property int maxNumberOfEnemies;
@property BOOL attackMenuInAction;
@property BOOL magicMenuInAction;
@property Player *currentPlayer;
@property Enemy *currentEnemy;
@property Magic *currentMagic;
@property CGFloat maxHpWidth;
@property CGFloat maxMpWidth;
@property int totalExpEarned;
@property Firebase *firebase;

@end

@implementation BattleScreen{
    
    SKNode *_currentMenu;
    SKNode *_controlWindow;
    
}

-(id)initWithSize:(CGSize)size withBackground:(NSString *)backgroundImageName enemy:(NSString *)enemyName maxNumberOfEnemies:(int) maxEnemies{
    if (self = [super initWithSize:size])
    {
        self.firebase = [[Firebase alloc] initWithUrl:@"https://sweltering-heat-197.firebaseio.com"];
        self.totalExpEarned = 0;
        self.maxNumberOfEnemies = maxEnemies;
        self.currentEnemy = [Enemy alloc];
        self.currentPlayer = [Player alloc];
        
        self.numberOfEnemies = [NSMutableArray array];
        self.numberOfPlayers = [NSMutableArray array];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.background = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName];
        self.background.size = self.frame.size;
        [self addChild:self.background];
    
        self.fontName = @"nevis";
        
        [self insertMenu];
        
        self.enemyName = enemyName;
        
        [self insertLivingBeings];
        [self insertHpMpBar];
        [self defineTurnOrder];
        [self nextTurn];
        
        NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/fightAgainstMonsters.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/victoryFanfare.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        
        self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
        self.musicPlayer.numberOfLoops = -1;
        
        self.victoryMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
        self.victoryMusicPlayer.numberOfLoops = -1;
        
        [self.musicPlayer play];
        
    }
    return self;
}

-(void)insertMenu{
    
    self.battleMenu = [SKSpriteNode spriteNodeWithImageNamed:@"menuTemplate"];
    self.battleMenu.position = CGPointMake(self.frame.size.width * 0.13, -self.frame.size.height * 0.5 + self.battleMenu.frame.size.height * 0.5);
    self.battleMenu.size = CGSizeMake(self.frame.size.width * 0.75,self.battleMenu.size.height);
    [self addChild:self.battleMenu];
    
    self.optionMenu = [SKSpriteNode spriteNodeWithImageNamed:@"menuTemplate"];
    self.optionMenu.position = CGPointMake(-self.frame.size.width * 0.5 + self.optionMenu.size.width * 0.25 ,
                                           -self.frame.size.height * 0.5 + self.optionMenu.frame.size.height * 0.5);
    self.optionMenu.size = CGSizeMake(self.frame.size.width * 0.25,self.optionMenu.size.height);
    [self addChild:self.optionMenu];
    
    _currentMenu = [SKNode node];
    [self addChild:_currentMenu];
    _controlWindow = [SKNode node];
    [self addChild:_controlWindow];
    
}
-(void)insertControls{
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftButton"];
    leftButton.size = CGSizeMake(20, 20);
    leftButton.position = CGPointMake(self.optionMenu.position.x - leftButton.frame.size.width,
                                      self.optionMenu.position.y);
    leftButton.name = @"leftButton";
    [leftButton setAlpha:1];
    leftButton.zPosition = 2;
    [_controlWindow addChild:leftButton];
    
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightButton"];
    rightButton.size = CGSizeMake(leftButton.size.width, leftButton.size.height);
    rightButton.position = CGPointMake(self.optionMenu.position.x + leftButton.frame.size.width,
                                       self.optionMenu.position.y);
    rightButton.name = @"rightButton";
    [rightButton setAlpha:leftButton.alpha];
    rightButton.zPosition = leftButton.zPosition;
    [_controlWindow addChild:rightButton];
    
    SKSpriteNode *downButton = [SKSpriteNode spriteNodeWithImageNamed:@"downButton"];
    downButton.size = CGSizeMake(leftButton.size.width, leftButton.size.height);
    downButton.position = CGPointMake(self.optionMenu.position.x,
                                      self.optionMenu.position.y - leftButton.frame.size.height);
    downButton.name = @"downButton";
    [downButton setAlpha:leftButton.alpha];
    downButton.zPosition = leftButton.zPosition;
    [_controlWindow addChild:downButton];

    SKSpriteNode *upButton = [SKSpriteNode spriteNodeWithImageNamed:@"upButton"];
    upButton.size = CGSizeMake(leftButton.size.width, leftButton.size.height);
    upButton.position = CGPointMake(self.optionMenu.position.x,
                                    self.optionMenu.position.y + leftButton.frame.size.height);
    upButton.name = @"upButton";
    [upButton setAlpha:leftButton.alpha];
    upButton.zPosition = leftButton.zPosition;
    [_controlWindow addChild:upButton];
    
    SKLabelNode *attackLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    attackLabel.text = @"Attack";
    attackLabel.fontColor = [UIColor blackColor];
    attackLabel.position = CGPointMake(upButton.position.x, upButton.position.y + leftButton.frame.size.height * 0.5 + 2);
    attackLabel.fontSize = 10;
    attackLabel.name = @"attackLabel";
    [_controlWindow addChild:attackLabel];
    
    SKLabelNode *etcLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    etcLabel.text = @"Etc.";
    etcLabel.fontColor = [UIColor blackColor];
    etcLabel.position = CGPointMake(downButton.position.x, downButton.position.y - leftButton.frame.size.height * 0.5 - 10);
    etcLabel.fontSize = 10;
    etcLabel.name = @"etcLabel";
    [_controlWindow addChild:etcLabel];
    
    SKLabelNode *itemLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    itemLabel.text = @"Item";
    itemLabel.fontColor = [UIColor blackColor];
    itemLabel.position = CGPointMake(rightButton.position.x + leftButton.size.width * 0.5 + 15, rightButton.position.y - 3);
    itemLabel.fontSize = 10;
    itemLabel.name = @"itemLabel";
    [_controlWindow addChild:itemLabel];
    
    SKLabelNode *magicLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    magicLabel.text = @"Magic";
    magicLabel.fontColor = [UIColor blackColor];
    magicLabel.fontSize = 10;
    magicLabel.position = CGPointMake(leftButton.position.x - leftButton.size.width * 0.5 - 17,
                                      leftButton.position.y - 3);
    magicLabel.name = @"magicLabel";
    [_controlWindow addChild:magicLabel];
    
}
-(void)etcMenu{
    self.attackMenuInAction = NO;
    self.magicMenuInAction = NO;
    
    SKLabelNode *defenseLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    defenseLabel.text = @"Defend";
    defenseLabel.name = @"defenseLabel";
    defenseLabel.fontSize = 20;
    defenseLabel.fontColor = [UIColor blackColor];
    defenseLabel.position = CGPointMake(self.battleMenu.position.x - defenseLabel.frame.size.width * 2, self.battleMenu.position.y);
    [_currentMenu  addChild:defenseLabel];
    
    SKLabelNode *fleeLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    fleeLabel.text = @"Flee";
    fleeLabel.name = @"fleeLabel";
    fleeLabel.fontSize = 20;
    fleeLabel.fontColor = [UIColor blackColor];
    fleeLabel.position = CGPointMake(self.battleMenu.position.x, self.battleMenu.position.y);
    [_currentMenu  addChild:fleeLabel];
    
    SKLabelNode *switchLabel = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    switchLabel.text = @"Switch";
    switchLabel.name = @"switchLabel";
    switchLabel.fontSize = 20;
    switchLabel.fontColor = [UIColor blackColor];
    switchLabel.position = CGPointMake(self.battleMenu.position.x + defenseLabel.frame.size.width * 2, self.battleMenu.position.y);
    [_currentMenu  addChild:switchLabel];
    
}
-(void)attackMenu{
    self.attackMenuInAction = YES;
    self.magicMenuInAction = NO;
    
    [self enumerateChildNodesWithName:self.enemyName usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *attackArrow = [SKSpriteNode spriteNodeWithImageNamed:@"attackArrow"];
        attackArrow.size = CGSizeMake(15,15);
        attackArrow.position = CGPointMake(node.position.x,node.position.y + node.frame.size.width * 1.5);
        [_currentMenu addChild:attackArrow];
    }];
    
}
-(void)magicMenu{

    self.attackMenuInAction = NO;
    self.magicMenuInAction = YES;
    int j = 0;
    int w = 0;
    
    SKLabelNode *firstMagicLabel = [SKLabelNode node];
    
    for (int i = 0; i < self.currentPlayer.magic.count; i++) {
        Magic *magic = (Magic *)self.currentPlayer.magic[i];
        
        SKLabelNode *magicLabel = [SKLabelNode labelNodeWithFontNamed:@"nevis"];
        magicLabel.fontColor = [UIColor blackColor];
        magicLabel.fontSize = 14;
        magicLabel.text = [NSString stringWithFormat:@"%@ %d",magic.name,magic.mpCost];
        magicLabel.horizontalAlignmentMode = 1;
        if (i == 0) {
            firstMagicLabel = magicLabel;
        }
        
        
        
        if ((i % 4) == 0 && i != 0) {
            j++;
            magicLabel.position = CGPointMake(firstMagicLabel.position.x,
                                              self.battleMenu.position.y + firstMagicLabel.frame.size.height - firstMagicLabel.frame.size.height * 2 * j);
            
            w = 1;
        }
        else{
            magicLabel.position = CGPointMake(self.battleMenu.position.x - firstMagicLabel.frame.size.width * 3.5 + firstMagicLabel.frame.size.width *1.5*w,
                                              self.battleMenu.position.y + firstMagicLabel.frame.size.height - firstMagicLabel.frame.size.height * 2 * j);
            w++;
        }
        magicLabel.name = magic.name;
        
        [_currentMenu addChild:magicLabel];
        
    }
    
}
-(void)magicSelected{
    
    [self enumerateChildNodesWithName:self.enemyName usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *attackArrow = [SKSpriteNode spriteNodeWithImageNamed:@"attackArrow"];
        attackArrow.size = CGSizeMake(15,15);
        attackArrow.position = CGPointMake(node.position.x,node.position.y + node.frame.size.height * 1.5);
        [_currentMenu addChild:attackArrow];
    }];
    
    [self enumerateChildNodesWithName:@"player" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *attackArrow = [SKSpriteNode spriteNodeWithImageNamed:@"attackArrow"];
        attackArrow.size = CGSizeMake(15,15);
        attackArrow.position = CGPointMake(node.position.x,node.position.y + node.frame.size.height * 1.5);
        [_currentMenu addChild:attackArrow];
    }];
}
-(void)insertLivingBeings{
    
    int randomNumberOfEnemies = arc4random_uniform(self.maxNumberOfEnemies)+1;
    
    Player *player = [Player player];
    [player battleIdleAnimation];
    player.position = CGPointMake(-self.frame.size.width * 0.25,
                                  self.battleMenu.position.y + self.battleMenu.frame.size.height * 0.5 + player.size.height * 2);
    player.physicsBody.collisionBitMask = 0;
    player.zPosition = 2;
    [self addChild:player];
    [self.numberOfPlayers addObject:player];

    for (int i = 0; i < randomNumberOfEnemies; i++) {
        Enemy *enemy = [Enemy newEnemyWithName:self.enemyName];
        [enemy moveAnimation];
        enemy.position = CGPointMake(self.frame.size.width * 0.05 + 50*i ,
                                      self.battleMenu.position.y + self.battleMenu.frame.size.height * 0.5 + player.size.height * 5 - 20*i);
        enemy.physicsBody.collisionBitMask = 0;
        enemy.zPosition = 2;
        [self addChild:enemy];
        [self.numberOfEnemies addObject:enemy];
    }
    
}
-(void)insertHpMpBar{
    
    for (int i = 0; i < self.numberOfPlayers.count; i++) {
        Player *player = (Player *)self.numberOfPlayers[i];
        
        CGPoint positionInScene = [player convertPoint:player.position fromNode:player.parent];
        
        SKSpriteNode *fillBar = [SKSpriteNode spriteNodeWithImageNamed:@"fillBar"];
        fillBar.anchorPoint = CGPointMake(0.0, 0.5);
        [fillBar setScale:0.3];
        fillBar.name = @"fillBar";
        fillBar.position = CGPointMake(positionInScene.x - fillBar.size.width * 0.5, positionInScene.y + player.size.height );
        
        [player addChild:fillBar];
        
        SKSpriteNode *fillBar2 = [SKSpriteNode spriteNodeWithImageNamed:@"fillBar"];
        fillBar2.anchorPoint = CGPointMake(0, 0.5);
        [fillBar2 setScale:0.3];
        fillBar2.name = @"fillBar2";
        fillBar2.position = CGPointMake(positionInScene.x - fillBar2.size.width * 0.5, positionInScene.y + player.size.height * 0.7);
        [player addChild:fillBar2];
        
        SKSpriteNode *hpBar = [SKSpriteNode spriteNodeWithImageNamed:@"hpBar"];
        hpBar.anchorPoint = CGPointMake(0, 0.5);
        hpBar.position = CGPointMake(7,0);
        hpBar.name = @"hpBar";
        self.maxHpWidth = hpBar.size.width;
        [fillBar addChild:hpBar];

        SKSpriteNode *mpBar = [SKSpriteNode spriteNodeWithImageNamed:@"mpBar"];
        mpBar.anchorPoint = CGPointMake(0, 0.5);
        mpBar.position = CGPointMake(6,0);
        mpBar.name = @"mpBar";
        self.maxMpWidth = mpBar.size.width;
        [fillBar2 addChild:mpBar];
        
    }
    
    for (int i = 0; i < self.numberOfEnemies.count; i++) {
        Enemy *enemy = (Enemy *)self.numberOfEnemies[i];
        
        CGPoint positionInScene = [enemy convertPoint:enemy.position fromNode:enemy.parent];
        
        SKSpriteNode *fillBar = [SKSpriteNode spriteNodeWithImageNamed:@"fillBar"];
        fillBar.anchorPoint = CGPointMake(0.0, 0.5);
        [fillBar setScale:0.3];
        fillBar.name = @"fillBar";
        fillBar.position = CGPointMake(positionInScene.x - fillBar.size.width * 0.5, positionInScene.y + enemy.size.height);
        [enemy addChild:fillBar];
        
        SKSpriteNode *hpBar = [SKSpriteNode spriteNodeWithImageNamed:@"hpBar"];
        hpBar.anchorPoint = CGPointMake(0, 0.5);
        hpBar.name = @"hpBar";
        hpBar.position = CGPointMake(7,0);
        [fillBar addChild:hpBar];
        
        
    }
    
}
-(void)nextTurn{
    
    [self enumerateChildNodesWithName:@"selectionArrow" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self.currentPlayer enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
        node.hidden = NO;
    }];
    
    [self.currentPlayer enumerateChildNodesWithName:@"fillBar2" usingBlock:^(SKNode *node, BOOL *stop) {
        node.hidden = NO;
    }];
    
    [self.currentEnemy enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
        node.hidden = NO;
    }];
    
    if (self.turnIndex >= self.numberOfTurns) {
        self.turnIndex = 0;
    }
    
    BOOL playerTurn = NO;
    SKSpriteNode *selectionArrow = [SKSpriteNode spriteNodeWithImageNamed:@"selectionArrow"];
    selectionArrow.name = @"selectionArrow";
    selectionArrow.size = CGSizeMake(15,15);
    
    for (int i = 0; i < _numberOfPlayers.count; i++) {
         self.currentPlayer = (Player *)_numberOfPlayers[i];
        
        if (self.currentPlayer.turn == self.turnIndex) {
            selectionArrow.position = CGPointMake(self.currentPlayer.position.x,self.currentPlayer.position.y + self.currentPlayer.size.width * 1.5);
            playerTurn = YES;
            [self insertControls];
            [self addChild:selectionArrow];
            self.turnIndex++;
            break;
        }
        
     }
    
    if (!playerTurn) {
        for (int i = 0; i < _numberOfEnemies.count; i++) {
            self.currentEnemy = (Enemy *)_numberOfEnemies[i];
            
            if (self.currentEnemy.turn == self.turnIndex) {
                selectionArrow.position = CGPointMake(self.currentEnemy.position.x,self.currentEnemy.position.y + self.currentEnemy.size.width * 1.5);
                [_controlWindow removeAllChildren];
                [self addChild:selectionArrow];
                
                [self.currentEnemy enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
                    node.hidden = YES;
                }];
                
                Player *attackedPlayer = (Player *)self.numberOfPlayers[0];
                
                [self.currentEnemy attackPlayer:attackedPlayer];
                
                [attackedPlayer enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node enumerateChildNodesWithName:@"hpBar" usingBlock:^(SKNode *node, BOOL *stop) {
                        SKSpriteNode *hpBar = (SKSpriteNode *)node;
                        double reductionModifier = (double)attackedPlayer.currentHp/attackedPlayer.maxhp;
                        
                        SKAction *resizeAction = [SKAction sequence:@[[SKAction waitForDuration:2],[SKAction resizeToWidth:self.maxHpWidth * reductionModifier height:hpBar.frame.size.height duration:0.5]]];
                        
                        [hpBar runAction:resizeAction];
                    }];
                    
                }];
                
                [self performSelector:@selector(nextTurn) withObject:self afterDelay:3];
                self.turnIndex++;
                break;
            }
            
        }
    }
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        SKNode *n1 = [_currentMenu nodeAtPoint:[touch locationInNode:_currentMenu]];
        
        if ([n.name isEqualToString:@"etcLabel"] || [n.name isEqualToString:@"downButton"]) {
            [_currentMenu removeAllChildren];
            [self etcMenu];
        }
        else if([n.name isEqualToString:@"attackLabel"] || [n.name isEqualToString:@"upButton"]){
            [_currentMenu removeAllChildren];
            [self attackMenu];
        }
        else if([n.name isEqualToString:@"magicLabel"] || [n.name isEqualToString:@"leftButton"]){
            [_currentMenu removeAllChildren];
            [self magicMenu];
        }
        else if([n.name isEqualToString:@"victoryWindow"]){
            
                [self.victoryMusicPlayer stop];
                GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
                scene.anchorPoint = CGPointMake(0.5, 0.5);
                scene.battleWon = YES;
                SKTransition *reveal = [SKTransition fadeWithDuration:1];
                [self.view presentScene:scene transition: reveal];
            
        }
        
        if ([n1.name isEqualToString:@"fleeLabel"]) {
            GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
            scene.anchorPoint = CGPointMake(0.5, 0.5);
            SKTransition *reveal = [SKTransition fadeWithDuration:1];
            [self.view presentScene:scene transition: reveal];
        }
        
        if (self.attackMenuInAction) {
            if ([n.name isEqualToString:self.enemyName]) {
                Enemy *attackedEnemy = (Enemy *)n;
                
                [self.currentPlayer attackEnemy:attackedEnemy];
                [_controlWindow removeAllChildren];
                
                [attackedEnemy enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node enumerateChildNodesWithName:@"hpBar" usingBlock:^(SKNode *node, BOOL *stop) {
                        SKSpriteNode *hpBar = (SKSpriteNode *)node;
                        double reductionModifier = (double)attackedEnemy.currentHp/attackedEnemy.maxhp;
                        
                        SKAction *resizeAction = [SKAction sequence:@[[SKAction waitForDuration:2],[SKAction resizeToWidth:self.maxHpWidth * reductionModifier height:hpBar.frame.size.height duration:0.5]]];
                        
                        [hpBar runAction:resizeAction];
                    }];
                    
                }];
                
                if (attackedEnemy.currentHp <= 0) {
                    self.totalExpEarned += attackedEnemy.expGiven;
                    [attackedEnemy die];
                    [self.numberOfEnemies removeObject:attackedEnemy];
                    [self defineTurnOrder];
                }
                
                [self performSelector:@selector(verifyBattleStatus) withObject:self afterDelay:4];
                
                [self performSelector:@selector(nextTurn) withObject:self afterDelay:3];
                [_currentMenu removeAllChildren];
                self.attackMenuInAction = NO;
            }
        }
        
        if (self.magicMenuInAction) {
            BOOL magicSuccess = NO;
            
            for (int i = 0; i < self.currentPlayer.magic.count; i++) {
                Magic* magic = (Magic *)self.currentPlayer.magic[i];
                
                if ([n.name isEqualToString:magic.name]) {
                    self.currentMagic = magic;
                    [self magicSelected];
                    break;
                }
            }
            
            if ([n.name isEqualToString:self.enemyName]) {
                Enemy *enemy = (Enemy *)n;
                magicSuccess = [self.currentMagic executeMagicOnTarget:enemy by:self.currentPlayer onScene:self];
                
                if (magicSuccess) {
                    
                    [self.currentPlayer enumerateChildNodesWithName:@"fillBar2" usingBlock:^(SKNode *node, BOOL *stop) {
                        [node enumerateChildNodesWithName:@"mpBar" usingBlock:^(SKNode *node, BOOL *stop) {
                            SKSpriteNode *mpBar = (SKSpriteNode *)node;
                            double reductionModifier = (double)self.currentPlayer.currentMp/self.currentPlayer.maxMp;
                            
                            SKAction *resizeAction = [SKAction sequence:@[[SKAction waitForDuration:2],[SKAction resizeToWidth:self.maxHpWidth * reductionModifier height:mpBar.frame.size.height duration:0.5]]];
                            
                            [mpBar runAction:resizeAction];
                        }];
                        
                    }];
                    
                    self.magicMenuInAction = NO;
                    [_currentMenu removeAllChildren];
                    [self performSelector:@selector(nextTurn) withObject:self afterDelay:3];
                }
            }
            else if([n.name isEqualToString:@"player"]){
                Player *player = (Player *)n;
                magicSuccess = [self.currentMagic executeMagicOnTarget:player by:self.currentPlayer onScene:self];
                if(magicSuccess){
                    
                    [self.currentPlayer enumerateChildNodesWithName:@"fillBar2" usingBlock:^(SKNode *node, BOOL *stop) {
                        [node enumerateChildNodesWithName:@"mpBar" usingBlock:^(SKNode *node, BOOL *stop) {
                            SKSpriteNode *mpBar = (SKSpriteNode *)node;
                            double reductionModifier = (double)self.currentPlayer.currentMp/self.currentPlayer.maxMp;
                            
                            SKAction *resizeAction = [SKAction sequence:@[[SKAction waitForDuration:2],[SKAction resizeToWidth:self.maxHpWidth * reductionModifier height:mpBar.frame.size.height duration:0.5]]];
                            
                            [mpBar runAction:resizeAction];
                        }];
                        
                    }];
                    
                    self.magicMenuInAction = NO;
                    [_currentMenu removeAllChildren];
                    [self performSelector:@selector(nextTurn) withObject:self afterDelay:3];
                }
            }
            
        }
        
        
    }
}
-(void)verifyBattleStatus{
    
    if (self.numberOfEnemies.count == 0) {
        
        [self executeVictory];
        
    }
    
}
-(void)executeVictory{
    
    [self removeAllChildren];
    
    [self.musicPlayer stop];
    [self.victoryMusicPlayer play];
    
    SKSpriteNode *victoryWindow = [SKSpriteNode spriteNodeWithImageNamed:@"menuTemplate"];
    victoryWindow.size = self.frame.size;
    victoryWindow.position = CGPointZero;
    victoryWindow.name = @"victoryWindow";
    [self addChild:victoryWindow];
    
   
    for (int i = 0; i < self.numberOfPlayers.count; i++) {
        
        Player *player = (Player *)self.numberOfPlayers[i];
        
        [self.currentPlayer enumerateChildNodesWithName:@"fillBar" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
        [self.currentPlayer enumerateChildNodesWithName:@"fillBar2" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
        
        SKSpriteNode *fillBar = [SKSpriteNode spriteNodeWithImageNamed:@"fillBar"];
        fillBar.position = CGPointMake(0, fillBar.frame.size.height * 3 - fillBar.frame.size.height * i);
        fillBar.anchorPoint = CGPointMake(0.0, 0.5);
        [victoryWindow addChild:fillBar];
        
        SKSpriteNode *expBar = [SKSpriteNode spriteNodeWithImageNamed:@"expBar"];
        expBar.anchorPoint = CGPointMake(0, 0.5);
        expBar.position = CGPointMake(7, 0);
        [expBar setSize:CGSizeMake(0, expBar.frame.size.height)];
        [fillBar addChild:expBar];
        
        [player moveAnimation];
        player.position = CGPointMake(fillBar.position.x - fillBar.frame.size.width, fillBar.position.y);
        [victoryWindow addChild:player];
        
        player.currentExp += self.totalExpEarned;
        
//        NSNumber *updateExp = [NSNumber numberWithInt:player.currentExp];
//        
//        Firebase *playerRef = [self.firebase childByAppendingPath:@"/Player"];
//        [playerRef setValue:updateExp];
//
        double sizeModifier = (double)player.currentExp/player.expNeeded;
        
        SKAction *resizeAction = [SKAction resizeToWidth:self.maxHpWidth * sizeModifier duration:0.5];
        [expBar runAction:resizeAction];
        
    }

    
}


-(void)sortPlayers{
    
    if (self.numberOfPlayers.count > 1) {
        
        for (int i = self.numberOfPlayers.count - 1; i >= 1; i--) {
            
            for (int j = 0; j < i; j++) {
                Player *currentPlayer = (Player *) self.numberOfPlayers[j];
                Player *nextPlayer = (Player *) self.numberOfPlayers[j++];
                
                if (nextPlayer.agi > currentPlayer.agi) {
                    Player *temp;
                    temp = self.numberOfPlayers[j];
                    [self.numberOfPlayers[j] addObject:self.numberOfPlayers[j++]];
                    [self.numberOfPlayers[j++] addObject:temp];
                }
                
            }
            
            
        }
        
    }
    
}
-(void)sortEnemies{
    
    if (self.numberOfEnemies.count > 1) {
        
        for (int i = self.numberOfEnemies.count - 1; i >= 1; i--) {
            
            for (int j = 0; j < i; j++) {
                Enemy *currentEnemy = (BallEnemy *) self.numberOfEnemies[j];
                Enemy *nextEnemy = (BallEnemy *) self.numberOfEnemies[j++];
                
                if (nextEnemy.agi > currentEnemy.agi) {
                    Enemy *temp;
                    temp = self.numberOfEnemies[j];
                    [self.numberOfEnemies[j] addObject:self.numberOfEnemies[j++]];
                    [self.numberOfEnemies[j++] addObject:temp];
                }
                
            }
            
            
        }
        
        
    }
    
}
-(void)defineTurnOrder{
    
    self.turnIndex = 0;
    //Sorting the players according to agility
    [self sortPlayers];
    //Sorting the enemies according to agility
    [self sortEnemies];
    //Sorting everyone and defining turnOrder
    
    for (int i = 0; i < self.numberOfPlayers.count; i++) {
        Player *player = (Player *)self.numberOfPlayers[i];
        player.turn = -1;
    }
    for (int i = 0; i < self.numberOfEnemies.count; i++) {
        Enemy *enemy = (Enemy *)self.numberOfEnemies[i];
        enemy.turn = -1;
    }
    
    int i = 0;
    int j = 0;
        
    while (i < self.numberOfPlayers.count) {
        Player *player = (Player *) self.numberOfPlayers[i];
        
        while (j < self.numberOfEnemies.count) {
            
            Enemy *enemy = (Enemy *) self.numberOfEnemies[j];
            
            if (player.agi >= enemy.agi) {
                player.turn = self.turnIndex;
                
                self.turnIndex++;
                break;
            }
            else{
                enemy.turn = self.turnIndex;
                
                self.turnIndex++;
                j++;
            }
            
        }
        i++;
    }
    i = 0;
    j = 0;
    
    while (i < self.numberOfEnemies.count) {
        
        Enemy *enemy = (Enemy *) self.numberOfEnemies[i];
        if (enemy.turn == -1) {
            
            enemy.turn = self.turnIndex;
            self.turnIndex++;
        }
        i++;
    }
    
    
    while (j < self.numberOfPlayers.count) {
        Player *player = (Player *) self.numberOfPlayers[j];
        if (player.turn == -1) {
            
            player.turn = self.turnIndex;
            self.turnIndex++;
        }
        j++;
    }
    


    self.numberOfTurns = self.turnIndex;
    self.turnIndex = 0;
}

@end
