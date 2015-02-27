//
//  Tree.m
//  Turn Based RPG
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/19/15.
//  Copyright (c) 2015 Bear Games. All rights reserved.
//

#import "Tree.h"

@implementation Tree

+(id)treeWithImage:(NSString *)imageName
{
    
    Tree *tree = [Tree spriteNodeWithImageNamed:imageName];
    
    
    if ([imageName isEqualToString:@"tree1"]) {
        
        tree.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(29, 22) center:CGPointMake(0, -48)];
        tree.name = @"tree1";
    }
    else if([imageName isEqualToString:@"tree2"]){
       
        tree.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(16, 16) center:CGPointMake(0, -48)];
        tree.name = @"tree2";
    }

    tree.physicsBody.dynamic = NO;
    return tree;
}

@end
