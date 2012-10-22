//
//  Player.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "IsometricTileMapHelper.h"

@implementation Player

@synthesize currentPlayerMap;

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

-(void) movePlayerToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap
{
    travelTime = 0;
    travelPercent = 0;
    currentPlayerMap = tileMap;
    startLocation = tileMap.position;

    CGPoint diff = ccpSub(self.position, newPosition);
    CGPoint mapDiff = ccpAdd(tileMap.position, diff);

    endLocation = mapDiff;


    float moveDistance = ccpDistance(startLocation, endLocation);
//    CCLOG(@"move distance %f", moveDistance);
    float moveSpeed = PLAYER_SPEED;
//    CCLOG(@"move speed %f", moveSpeed);
    moveDuration = moveDistance/moveSpeed; // in seconds
//    CCLOG(@"moveDuration %f", moveDuration);
    float deltaTime = 1.0f/60.0f;//CCDirector.sharedDirector.secondsPerFrame;
//    CCLOG(@"deltaTime %f", deltaTime);
//    CCLOG(@"seconds per frame %f", CCDirector.sharedDirector.secondsPerFrame);

    travelIncrement = deltaTime/ moveDuration;
//    CCLOG(@"travelIncrement %f", travelIncrement);

    [self unscheduleUpdate];
    [self scheduleUpdate];
}

-(void) update:(ccTime)delta
{
    CGPoint movePosition = ccpLerp(startLocation, endLocation, travelPercent);
    CGPoint nextMapMovePosition = ccpLerp(startLocation, endLocation, travelPercent+travelIncrement);
    CGPoint moveDifference = ccpSub(currentPlayerMap.position, nextMapMovePosition);
    CGPoint nextPlayerMovePosition = ccpAdd(self.position, moveDifference);
    CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:self.position tileMap:currentPlayerMap];
    CGPoint nextPlayerTilePosition = [IsometricTileMapHelper tilePosFromLocation:nextPlayerMovePosition tileMap:currentPlayerMap];

    currentPlayerMap.position = movePosition;
    travelPercent += travelIncrement;
    [self updateVertexZ:tilePosition tileMap:currentPlayerMap];


    if ([IsometricTileMapHelper isTilePosBlocked:nextPlayerTilePosition tileMap:currentPlayerMap])
    {
        NSLog(@"BLOCKED!");
        [self unscheduleUpdate];
    }
    else if (travelPercent >= 1.0)
    {
        [self unscheduleUpdate];
    }


}

@end
