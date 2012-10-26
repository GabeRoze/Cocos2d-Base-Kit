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
//    CGPoint mapStartLocation;
//    CGPoint mapEndLocation;

    BOOL playerReachedBoundary;
    BOOL playerBlocked;
    CGPoint startPosition;
//    CGPoint endPosition;

    CGRect playerMovementBounds;
    ccTime travelTime;
    float moveDuration;
    float travelPercent;
    float travelIncrement;

    id mapMovement;
    id layerMovement;
}

@property (assign, nonatomic) CGPoint endPosition;
@property (strong, nonatomic) CCTMXTiledMap *currentPlayerMap;
@property (strong, nonatomic) CCNode *gameNode;

+(Player*)instance;
+(id)player;

-(void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
-(void) movePlayerToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap;


@end
