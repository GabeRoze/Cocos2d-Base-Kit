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
@synthesize gameLayer;


static Player* instance;

+(Player*)instance
{
    return instance;
}

+(id)playerWithMap:(CCTMXTiledMap *)map gameLayer:(CCLayer *)layer
{
    return [[self alloc] initWithPlayerImageWithMap:map gameLayer:layer];
}


-(id)initWithPlayerImageWithMap:(CCTMXTiledMap *)map gameLayer:(CCLayer *)layer
{
    if ((self = [super initWithFile:@"ninja.png"]))
    {
        instance = self;
        currentPlayerMap = map;
        gameLayer = layer;
    }
    return self;
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

- (void)movePlayerToPosition:(CGPoint)newPosition
{
    //todo if player is still moving
    /*
    slow down player movment and move to new direction (only if the tap is greater than 90 degrees to the left or right of the direction the player is facing)
     */

//    for(int i= 0; i < 100; i++)
//        NSLog(@" ");

    [self stopAllActions];
    [currentPlayerMap stopAllActions];
    [gameLayer stopAllActions];

    CCSequence *moveSequence;
    NSMutableArray *playerMoveSequenceArray = [[NSMutableArray alloc] init];

    CGPoint finalPlayerPosition = self.position;
    float movementBoundsHeight = PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT;
    float movementBoundsWidth = PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH;
    playerMovementBounds = CGRectMake(Helper.screenCenter.x - movementBoundsWidth/2, Helper.screenCenter.y - movementBoundsHeight/2, movementBoundsWidth, movementBoundsHeight);
    playerReachedBoundary = NO;
    travelTime = 0;
    travelPercent = 0;
//    currentPlayerMap = tileMap;
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
                endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));
                finalPlayerPosition = endPosition;
                moveDistance = ccpDistance(startPosition, endPosition);
                moveDuration = moveDistance/moveSpeed;
                id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
                id ease = [CCEaseSineIn actionWithAction:action];
                [playerMoveSequenceArray addObject:action];
                playerReachedBoundary = YES;
            }
            travelPercent = 10;
        }
        else if ([IsometricTileMapHelper isTilePosBlocked:tilePosition tileMap:currentPlayerMap])
        {
            endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));
            finalPlayerPosition = endPosition;
            moveDistance = ccpDistance(startPosition, endPosition);
            moveDuration = moveDistance/moveSpeed;
            id action = [CCMoveTo actionWithDuration:moveDuration position:endPosition];
            id ease = [CCEaseSineIn actionWithAction:action];
            [playerMoveSequenceArray addObject:ease];
            travelPercent = 10;
            playerBlocked = YES;
        }
    }

    if (playerReachedBoundary)
    {
        startPosition = endPosition;
        endPosition = newPosition;

        for (travelPercent = 0; travelPercent < 1.0; travelPercent+=travelIncrement)
        {

            CGPoint nextPosition = ccpLerp(startPosition, endPosition, travelPercent);
            CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:nextPosition tileMap:currentPlayerMap];

            if ([IsometricTileMapHelper isTilePosBlocked:tilePosition tileMap:currentPlayerMap])
            {
                endPosition = ccpLerp(startPosition, endPosition, travelPercent-(travelIncrement*2));
                CGPoint mapEndPosition = [Helper movePoint:currentPlayerMap.position withLine:startPosition end:endPosition];
                moveDistance = ccpDistance(startPosition, endPosition);
                moveDuration = moveDistance/moveSpeed;
                id action = [CCMoveTo actionWithDuration:moveDuration position:mapEndPosition];
                id ease = [CCEaseSineOut actionWithAction:action];
                mapMovement = ease;
                id mapMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(moveMap)];
                [playerMoveSequenceArray addObject:mapMoveAction];
                travelPercent = 10;
                playerBlocked = YES;
            }
        }
        if (!playerBlocked)
        {
            //move chat to end position
            endPosition = ccpLerp(startPosition, endPosition, 1.0f);
            CGPoint mapEndPosition = [Helper movePoint:currentPlayerMap.position withLine:startPosition end:endPosition];
            moveDistance = ccpDistance(startPosition, endPosition);
            moveDuration = moveDistance/moveSpeed;
            id action = [CCMoveTo actionWithDuration:moveDuration position:mapEndPosition];
            id ease = [CCEaseSineOut actionWithAction:action];
            mapMovement = ease;
            id mapMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(moveMap)];
            [playerMoveSequenceArray addObject:mapMoveAction];

            /*
            //center map on player
            startPosition = finalPlayerPosition;
            endPosition = Helper.screenCenter;
            CGPoint mapCenterEndPosition = [Helper movePoint:currentPlayerMap.position withLine:endPosition end:startPosition];
//            CGPoint playerCenterEndPosition = [Helper movePoint:endPosition withLine:endPosition end:startPosition];
            moveDistance = ccpDistance(startPosition, endPosition);
            moveDuration = moveDistance/moveSpeed;
            id mapCenterAction = [CCMoveTo actionWithDuration:moveDuration position:mapCenterEndPosition];
            id mapCenterEase = [CCEaseInOut actionWithAction:mapCenterAction];
            mapCenterMovement = mapCenterEase;
            id playerCenterAction = [CCMoveTo actionWithDuration:moveDuration position:Helper.screenCenter];
            id playerCenterEase = [CCEaseSineInOut actionWithAction:playerCenterAction];
            playerCenterMovement = playerCenterEase;

//            id delayAction = [CCDelayTime actionWithDuration:0.5f];
//            [playerMoveSequenceArray addObject:delayAction];

*/
            startPosition = finalPlayerPosition;
            endPosition = [Helper screenCenter];
            CGPoint layerCenterPosition = [Helper movePoint:gameLayer.position withLine:endPosition end:startPosition];
            moveDistance = ccpDistance(startPosition, endPosition);
            moveDuration = (moveDistance/moveSpeed)*2;
            id layerCenterAction = [CCMoveTo actionWithDuration:moveDuration position:layerCenterPosition];
            id layerCenterEase = [CCEaseSineInOut actionWithAction:layerCenterAction];
            layerMovement = layerCenterEase;

            id mapCenterMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(centerMap)];
            [playerMoveSequenceArray addObject:mapCenterMoveAction];




            playerBlocked = NO;
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
    CCLOG(@"==================== CENTER =================");
//    [self runAction:playerCenterMovement];
//    [currentPlayerMap runAction:mapCenterMovement];

    [gameLayer runAction:layerMovement];
}


-(void) update:(ccTime)delta
{
    CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:self.position tileMap:currentPlayerMap];
//    [self updateVertexZ:tilePosition tileMap:currentPlayerMap];
}


@end
