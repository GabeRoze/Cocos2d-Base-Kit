//
//  Player.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "IsometricTileMapHelper.h"
#import "MainGameScene.h"
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

    //shit only fucks up when the game layer movies

    //get new position in terms of gamelayer
    CGPoint gameLayerNewPos = [Helper movePoint:newPosition withLine:CGPointZero end:gameLayer.position];
    //calculate new move point

    newPosition = gameLayerNewPos;


//    newPosition = [Helper movePoint:newPosition withLine:CGPointZero end:gameLayer.position];

    //note - the touch location is on the gameLayer
//    CCSprite *spr = [CCSprite spriteWithFile:@"ninja.png"];
//    spr.position = gameLayerNewPos;
//    [gameLayer addChild:spr];

    CCLOG(@"new pos x%f y%f", newPosition.x, newPosition.y);
    CCLOG(@"game layer at x%f y%f", gameLayer.position.x, gameLayer.position.y);
//    CCLOG(@"game layer  anchorat x%f y%f", gameLayer.anchorPoint.x, gameLayer.anchorPoint.y);
//    CGPoint worldspace =  [gameLayer convertToNodeSpace:MainGameScene.instance.position];
//    CCLOG(@"world space x%f y%f", worldspace.x, worldspace.y);


    //todo if player is still moving


    //have players new position
    //have new gameLayers position



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

    playerMovementBounds.origin = [Helper movePoint:playerMovementBounds.origin withLine:CGPointZero end:gameLayer.position];



    travelTime = 0;
    travelPercent = 0;
//    currentPlayerMap = tileMap;
    startPosition = self.position;

//    endPosition = [self movePoint:self.position withLine:newPosition end:self.position];
    endPosition = newPosition;

    //ofset everytthing

//    CGPoint add = ccpAdd(CGPointZero, gameLayer.position);
//    newPosition = ccpAdd(newPosition, add);
//    startPosition = ccpAdd(startPosition, add);
//    endPosition = ccpAdd(endPosition, add);
//    playerMovementBounds.origin = ccpAdd(playerMovementBounds.origin, add);

//    CGPoint diff = ccpSub(self.position, newPosition);


//    startPosition = [Helper movePoint:startPosition withLine:CGPointZero end:gameLayer.position];
//    endPosition = [Helper movePoint:endPosition withLine:CGPointZero end:gameLayer.position];
//    newPosition = [Helper movePoint:newPosition withLine:CGPointZero end:gameLayer.position];
//    playerMovementBounds.origin = [Helper movePoint:playerMovementBounds.origin withLine:CGPointZero end:gameLayer.position];

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
            //move char to end position
            endPosition = ccpLerp(startPosition, endPosition, 1.0f);
            CGPoint mapEndPosition = [Helper movePoint:currentPlayerMap.position withLine:startPosition end:endPosition];
            moveDistance = ccpDistance(startPosition, endPosition);
            moveDuration = moveDistance/moveSpeed;
            id action = [CCMoveTo actionWithDuration:moveDuration position:mapEndPosition];
            id ease = [CCEaseSineOut actionWithAction:action];
            mapMovement = ease;
            id mapMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(moveMap)];
            [playerMoveSequenceArray addObject:mapMoveAction];
            playerBlocked = NO;
        }
        //center map on player
        [playerMoveSequenceArray addObject:[self centerGameLayerWithFinalPlayerPosition:finalPlayerPosition]];
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

-(id)centerGameLayerWithFinalPlayerPosition:(CGPoint)finalPlayerPosition
{
    startPosition = finalPlayerPosition;
    endPosition = [Helper screenCenter];
    endPosition = [Helper movePoint:endPosition withLine:CGPointZero end:gameLayer.position];

    CGPoint layerCenterPosition = [Helper movePoint:gameLayer.position withLine:endPosition end:startPosition];
    float moveDistance = ccpDistance(startPosition, endPosition);
    float moveSpeed = [self setMoveSpeedWithMoveDistance:moveDistance];
    float moveDurationModifier = 1;
    moveDuration = (moveDistance/moveSpeed)*moveDurationModifier;
    id layerCenterAction = [CCMoveTo actionWithDuration:moveDuration position:layerCenterPosition];
    id layerCenterEase = [CCEaseSineInOut actionWithAction:layerCenterAction];
    layerMovement = layerCenterEase;

    id mapCenterMoveAction = [CCCallFunc actionWithTarget:self selector:@selector(centerMap)];

    return mapCenterMoveAction;
//    [playerMoveSequenceArray addObject:mapCenterMoveAction];
//            CCLOG(@"new pos x%f y%f", newPosition.x, newPosition.y);
//    CCLOG(@"new game layer at x%f y%f", layerCenterPosition.x, layerCenterPosition.y);
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
    [self updateVertexZ:tilePosition tileMap:currentPlayerMap];
}


@end
