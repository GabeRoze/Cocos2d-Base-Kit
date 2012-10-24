//
//  Player.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "IsometricTileMapHelper.h"
#include <stdlib.h>

@implementation Player

@synthesize currentPlayerMap;
@synthesize endPosition;
@synthesize gameNode;

+(Player*)instance
{
    static Player* instance = nil;

    if (!instance)
    {
        instance = [Player player];
    }

    return instance;
}

+(id)player
{
    return [[self alloc] initWithFile:@"ninja.png"];
}

-(void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
    float lowestZ = -(tileMap.mapSize.width + tileMap.mapSize.height);
    float currentZ = tilePos.x + tilePos.y;
    self.vertexZ = lowestZ + currentZ - 1;
}


-(CGPoint)movePoint:(CGPoint)pointToMove withLine:(CGPoint)start end:(CGPoint)end
{
    CGPoint diff = ccpSub(start, end);
    CGPoint newPoint = ccpAdd(pointToMove, diff);
    return newPoint;
}

-(void) movePlayerToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap
{
    for(int i= 0; i < 100; i++)
        NSLog(@" ");

    [self stopAllActions];

    CCSequence *moveSequence;
    NSMutableArray *playerMoveSequenceArray = [[NSMutableArray alloc] init];


    float movementBoundsHeight = PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT;
    float movementBoundsWidth = PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH;
    playerMovementBounds = CGRectMake(Helper.screenCenter.x - movementBoundsWidth/2, Helper.screenCenter.y - movementBoundsHeight/2, movementBoundsWidth, movementBoundsHeight);
    playerOutOfBounds = NO;
    travelTime = 0;
    travelPercent = 0;
    currentPlayerMap = tileMap;
    startPosition = self.position;

    endPosition = [self movePoint:self.position withLine:newPosition end:self.position];

    float moveDistance = ccpDistance(startPosition, endPosition);
    CCLOG(@"move distance %f", moveDistance);
    float moveSpeed = PLAYER_SPEED;
    if (moveDistance < 100)
    {
        moveSpeed /=2;
    }

    moveDuration = moveDistance/moveSpeed; // in seconds
    float deltaTime = 1.0f/60.0f;//CCDirector.sharedDirector.secondsPerFrame;
    travelIncrement = deltaTime/ moveDuration;





    //1. check if player hits bounds or walls within bound
    for (travelPercent; travelPercent < 1.0; travelPercent+=travelIncrement)
    {
        CGPoint nextPosition = ccpLerp(startPosition, endPosition, travelPercent);
//        travelPercent += travelIncrement;
        CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:nextPosition tileMap:currentPlayerMap];


        float x = nextPosition.x;
        float y = nextPosition.y;

        //out of bounds
        if (x < playerMovementBounds.origin.x
                || (x > playerMovementBounds.origin.x+ PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH)
                || y < playerMovementBounds.origin.y
                || (y > playerMovementBounds.origin.y+ PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT))
        {
            if (travelPercent != 0)
            {
                CCLOG(@"out of bounds");
                endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));
                moveDistance = ccpDistance(startPosition, endPosition);
                moveDuration = moveDistance/moveSpeed;
                id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
                id ease = [CCEaseInOut actionWithAction:action rate:PLAYER_EASE_RATE];
                [playerMoveSequenceArray addObject:ease];
                playerOutOfBounds = YES;
            }
            travelPercent = 10;
        }
        else if ([IsometricTileMapHelper isTilePosBlocked:tilePosition tileMap:currentPlayerMap])
        {
            CCLOG(@"BLOCKED");
            endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));
            moveDistance = ccpDistance(startPosition, endPosition);
            moveDuration = moveDistance/moveSpeed;
            id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
            id ease = [CCEaseInOut actionWithAction:action rate:PLAYER_EASE_RATE];
            [playerMoveSequenceArray addObject:ease];
            travelPercent = 10;
            playerBlocked = YES;
        }
    }


    /*


     */


    if (playerOutOfBounds)
    {
        /*
        move map (check for colissions
        center player/map
         */
    }
    else if (playerBlocked)
    {
        //center player (optional?)
    }
    else //the tap was within the bounds and no blocks
    {
        id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
        id ease = [CCEaseInOut actionWithAction:action rate:PLAYER_EASE_RATE];
        [playerMoveSequenceArray addObject:ease];
    }

//    if (playerMoveSequenceArray.count == 0)
//    {
//        CCLOG(@"ZERO ARRAY");
//        id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
//        id ease = [CCEaseInOut actionWithAction:action rate:PLAYER_EASE_RATE];
//        [playerMoveSequenceArray addObject:ease];
//    }
    /*
    else
    {
        //move mother fucken map!
        //add map movment to sequence
        //add centering
        CCLOG(@"MOVE MAP ONLY");
        CGPoint mapEndPoint = [Helper movePoint:currentPlayerMap.position withLine:endPosition end:newPosition];
        moveDistance = ccpDistance(endPosition, newPosition);
        moveDuration = moveDistance/moveSpeed;
        id action = [CCMoveTo actionWithDuration:moveDuration position:mapEndPoint];
        mapMovement = [CCEaseInOut actionWithAction:action rate:PLAYER_EASE_RATE];
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(moveMap)];
        [playerMoveSequenceArray addObject:callFunc];


        //center that shit
//        CGPoint centerGameLayerPoint = [Helper movePoint:gameNode.position withLine:Helper.screenCenter end:newPosition];
//        moveDistance = ccpDistance(newPosition, Helper.screenCenter);
//        moveDuration = moveDistance/moveSpeed;
//        id centerAction = [CCMoveTo actionWithDuration:moveDuration position:centerGameLayerPoint];
//        layerMovement = [CCEaseInOut actionWithAction:centerAction rate:PLAYER_EASE_RATE];
//        id centerCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(centerMap)];
//        [playerMoveSequenceArray addObject:centerCallFunc];
    }
*/


    //todo if moving, perform easy out to slow down on current line then run next action
    //todo

    if (playerMoveSequenceArray.count > 0)
        [self runAction:[CCSequence actionWithArray:playerMoveSequenceArray]];

    playerBlocked = NO;

//    [self unscheduleUpdate];
//    [self scheduleUpdate];
}

-(void)moveMap
{
    [currentPlayerMap runAction:mapMovement];
}

-(void)centerMap
{
    [gameNode runAction:layerMovement];
}


-(void) update:(ccTime)delta
{
//    float x = self.position.x;
//    float y = self.position.y;
//
//    if (x < playerMovementBounds.origin.x
//            || (x > playerMovementBounds.origin.x+ PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH)
//            || y < playerMovementBounds.origin.y
//            || (y > playerMovementBounds.origin.y+ PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT))
//    {
//
//        NSLog(@"OUT OF BOUND!");
//        playerOutOfBounds = YES;
//
//
//
//        [self unscheduleUpdate];
//    }
//    else
//    {
//        CGPoint playerMovePosition = ccpLerp(startPosition, endPosition, travelPercent);
//        CGPoint nextPlayerMovePosition = ccpLerp(startPosition, endPosition, travelPercent+travelIncrement);
    CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:self.position tileMap:currentPlayerMap];
//        CGPoint playerNextTilePosition = [IsometricTileMapHelper tilePosFromLocation:nextPlayerMovePosition tileMap:currentPlayerMap];
//
//        self.position = playerMovePosition;
//
//        travelPercent += travelIncrement;
    [self updateVertexZ:tilePosition tileMap:currentPlayerMap];
//
//        if ([IsometricTileMapHelper isTilePosBlocked:playerNextTilePosition tileMap:currentPlayerMap])
//        {
//            NSLog(@"BLOCKED!");
//            [self unscheduleUpdate];
//        }
//        else if (travelPercent >= 1.0)
//        {
//            [self unscheduleUpdate];
//        }
//    }



}


@end
