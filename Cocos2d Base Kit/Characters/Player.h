//
//  Player.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite
{
    BOOL isMoving;
    CGPoint startLocation;
    CGPoint endLocation;
    ccTime travelTime;
    float travelPercent;
    float travelIncrement;
    NSMutableArray *moveLine;

}

@property (strong, nonatomic) CCTMXTiledMap *currentPlayerMap;

+(id)player;

-(void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
-(void) movePlayerToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap;


@end
