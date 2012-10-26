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

-(float)setMoveSpeedWithMoveDistance:(float)distance
{
    float moveSpeed = PLAYER_SPEED;
    if (distance < 100)
    {
        moveSpeed /=2;
    }
    return moveSpeed;
}

-(void) movePlayerToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap
{
    //todo if player is still moving
    /*

    slow down player movment and move to new direction (only if the tap is greater than 90 degrees to the left or right of the direction the player is facing)

     */


    for(int i= 0; i < 100; i++)
        NSLog(@" ");

    [self stopAllActions];
    [currentPlayerMap stopAllActions];

    CCSequence *moveSequence;
    NSMutableArray *playerMoveSequenceArray = [[NSMutableArray alloc] init];


    float movementBoundsHeight = PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT;
    float movementBoundsWidth = PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH;
    playerMovementBounds = CGRectMake(Helper.screenCenter.x - movementBoundsWidth/2, Helper.screenCenter.y - movementBoundsHeight/2, movementBoundsWidth, movementBoundsHeight);
    playerReachedBoundary = NO;
    travelTime = 0;
    travelPercent = 0;
    currentPlayerMap = tileMap;
    startPosition = self.position;

//    endPosition = [self movePoint:self.position withLine:newPosition end:self.position];
    endPosition = newPosition;

    float moveDistance = ccpDistance(startPosition, endPosition);
//    CCLOG(@"move distance %f", moveDistance);
    float moveSpeed = [self setMoveSpeedWithMoveDistance:moveDistance];
//    if (moveDistance < 100)
//    {
//        moveSpeed /=2;
//    }

    moveDuration = moveDistance/moveSpeed; // in seconds
    float deltaTime = 1.0f/60.0f;//CCDirector.sharedDirector.secondsPerFrame;
    travelIncrement = deltaTime/ moveDuration;

    //1. check if player hits bounds or walls within bound
    for (travelPercent; travelPercent < 1.0; travelPercent+=travelIncrement)
    {
        CGPoint nextPosition = ccpLerp(startPosition, endPosition, travelPercent);
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
//                moveSpeed = [self setMoveSpeedWithMoveDistance:moveDistance];
                moveDuration = moveDistance/moveSpeed;
                id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
                id ease = [CCEaseIn actionWithAction:action rate:PLAYER_EASE_RATE];
                [playerMoveSequenceArray addObject:action];
                playerReachedBoundary = YES;
            }
            travelPercent = 10;
        }
        else if ([IsometricTileMapHelper isTilePosBlocked:tilePosition tileMap:currentPlayerMap])
        {
            CCLOG(@"BLOCKED");
            endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));
            moveDistance = ccpDistance(startPosition, endPosition);
//            moveSpeed = [self setMoveSpeedWithMoveDistance:moveDistance];
            moveDuration = moveDistance/moveSpeed;
            id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
            id ease = [CCEaseInOut actionWithAction:action rate:PLAYER_EASE_RATE];
            [playerMoveSequenceArray addObject:ease];
            travelPercent = 10;
            playerBlocked = YES;
        }
    }

    if (playerReachedBoundary)
    {
        startPosition = endPosition;
        endPosition = newPosition;
        /*
        end location = player at boundary point
        lerp from endlocation to newposition
        loop through all iterations of lerp
        set new end position
        move player to end position
        move map (check for colissions
        center player/map
         */
        for (travelPercent = 0; travelPercent < 1.0; travelPercent+=travelIncrement)
        {

            CGPoint nextPosition = ccpLerp(startPosition, endPosition, travelPercent);
            CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:nextPosition tileMap:currentPlayerMap];

            if ([IsometricTileMapHelper isTilePosBlocked:tilePosition tileMap:currentPlayerMap])
            {
                CCLOG(@"BLOCKED");
                endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));

                CGPoint mapEndPosition = [Helper movePoint:currentPlayerMap.position withLine:startPosition end:endPosition];
                moveDistance = ccpDistance(startPosition, endPosition);
//                moveSpeed = [self setMoveSpeedWithMoveDistance:moveDistance];
                moveDuration = moveDistance/moveSpeed;
                id action = [CCMoveTo actionWithDuration:moveDuration position:mapEndPosition];
                id ease = [CCEaseOut actionWithAction:action rate:PLAYER_EASE_RATE];
                mapMovement = ease;
                id mapMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(moveMap)];
//                [playerMoveSequenceArray addObject:ease];
                [playerMoveSequenceArray addObject:mapMoveAction];
                travelPercent = 10;
                playerBlocked = YES;
                CCLOG(@"start pos x%f y%f", startPosition.x, startPosition.y);
                CCLOG(@"end pos x%f y%f", endPosition.x, endPosition.y);
                CCLOG(@"move distance %f", moveDistance);
            }
        }
        if (!playerBlocked)
        {
            //move chat to end position
            CCLOG(@"start pos x%f y%f", startPosition.x, startPosition.y);
            CCLOG(@"end pos x%f y%f", endPosition.x, endPosition.y);
            endPosition = ccpLerp(startPosition, endPosition, 1.0f);
            CGPoint mapEndPosition = [Helper movePoint:currentPlayerMap.position withLine:startPosition end:endPosition];
            moveDistance = ccpDistance(startPosition, endPosition);
//            moveSpeed = [self setMoveSpeedWithMoveDistance:moveDistance];
            moveDuration = moveDistance/moveSpeed;
            id action = [CCMoveTo actionWithDuration:moveDuration position:mapEndPosition];
            id ease = [CCEaseOut actionWithAction:action rate:PLAYER_EASE_RATE];
            mapMovement = ease;
            id mapMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(moveMap)];
            [playerMoveSequenceArray addObject:mapMoveAction];
//            [playerMoveSequenceArray addObject:ease];
//            travelPercent = 10;
            playerBlocked = NO;
            CCLOG(@"start pos x%f y%f", startPosition.x, startPosition.y);
            CCLOG(@"end pos x%f y%f", endPosition.x, endPosition.y);
            CCLOG(@"move distance %f", moveDistance);

        }

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
    CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:self.position tileMap:currentPlayerMap];
//    [self updateVertexZ:tilePosition tileMap:currentPlayerMap];
}


@end
