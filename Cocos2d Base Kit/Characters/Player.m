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
    startLocation = self.position;
    endLocation = newPosition;
    CGPoint p = ccpLerp(self.position, newPosition, 0.0);


    float moveDistance = ccpDistance(startLocation, endLocation);
    float moveSpeed = PLAYER_SPEED;
    float time = moveDistance/moveSpeed; // in seconds

//    double animationInterval = CCDirector.sharedDirector.animationInterval;

    float deltaTime = CCDirector.sharedDirector.secondsPerFrame;


    travelIncrement = deltaTime/time;

//    CCLOG(@"delta time %f", deltaTime);
//    CCLOG(@"travel increment %f", travelIncrement);
//    CCLOG(@"move speed %f", PLAYER_SPEED);
//    CCLOG(@"move distance %f", moveDistance);
//    CCLOG(@"time %f", time);
//    CCLOG(@"animinterval %f", deltaTime);
//    CCLOG(@"travel Percent 0 %f", travelPercent);

//    CCLOG(@"lerp 1 x%f y%f", p.x, p.y);

    [self unscheduleUpdate];
    [self scheduleUpdate];


//    if (denominator != 0 && numerator != 0)
//    {
//        slope = numerator/denominator;
//
//        float lowX = MIN(newPosition.x, self.position.x);
//        float highX = MAX(newPosition.x, self.position.x);
//
//        for (float i = lowX; i <= highX; i++)
//        {
//            float newY = i*slope;
//            [moveLine addObject:[NSValue valueWithCGPoint:CGPointMake(i, newY)]];
//        }
//    }
//    else if (numerator == 0)
//    {
//        float lowX = MIN(newPosition.x, self.position.x);
//        float highX = MAX(newPosition.x, self.position.x);
//
//        for (float i = lowX; i <= highX; i++)
//        {
//            [moveLine addObject:[NSValue valueWithCGPoint:CGPointMake(i, self.position.y)]];
//        }
//    }
//    else if (denominator == 0)
//    {
//        float lowY = MIN(newPosition.y, self.position.y);
//        float highY = MAX(newPosition.y, self.position.y);
//
//        for (float i = lowY; i <= highY; i++)
//        {
//            [moveLine addObject:[NSValue valueWithCGPoint:CGPointMake(self.position.x, i)]];
//        }
//    }
//
//    for (int i = 0; i < moveLine.count; i++)
//    {
//        CGPoint linePoint = [[moveLine objectAtIndex:i] CGPointValue];
//
//        if ([IsometricTileMapHelper isTilePosBlocked:linePoint tileMap:tileMap])
//        {
//            CCLOG(@"line x:%f line y:%f", linePoint.x, linePoint.y);
//            //todo move player to previous position in line array
//
////            CGPoint temp = ccpSub(1, <#(CGPoint const)v2#>)
//
//            [self unscheduleUpdate];
//            [self scheduleUpdate];
////            CCAction* move = [CCMoveTo actionWithDuration:0.2f position:linePoint];
////            [self stopAllActions];
////            [self runAction:move];
//        }
//
//    }




}

-(void)centerScreenOnPlayer
{

}


-(void) update:(ccTime)delta
{
//    CCLOG(@"delta %f", delta);
//    travelTime += delta;


    CGPoint movePosition = ccpLerp(startLocation, endLocation, travelPercent);
    self.position = movePosition;
    [self updateVertexZ:movePosition tileMap:currentPlayerMap];

//    currentPlayerMap.position = movePosition;

//    [IsometricTileMapHelper centerTileMapOnTileCoord:movePosition tileMap:currentPlayerMap];

    travelPercent += travelIncrement;

//    CCLOG(@"travel percent %f", travelPercent);
//    CCLOG(@"travel increment %f", travelIncrement);

    if (travelPercent >= 1.0)
    {
        [self unscheduleUpdate];
    }

    //depending on distance, travel percent will change





    //camera zoom over player



}

@end
