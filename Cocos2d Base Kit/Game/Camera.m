//
//  Camera.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"
#import "IsometricTileMapHelper.h"


@implementation Camera

-(id)init
{
    if (self = [super init])
    {
//        self.isTouchEnabled = YES;
        centerMapOnPlayer = NO;
    }
    return self;
}

-(void)followPlayer:(Player *)tiledPlayer withTiledMap:(CCTMXTiledMap *)map
{
    player = tiledPlayer;
    tiledMap = map;

    float movementBoundsHeight = PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT;
    float movementBoundsWidth = PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH;

    playerMovementBounds = CGRectMake(Helper.screenCenter.x - movementBoundsWidth/2, Helper.screenCenter.y - movementBoundsHeight/2, movementBoundsWidth, movementBoundsHeight);

    CCLOG(@"player movement bounds x%f y%f", playerMovementBounds.origin.x, playerMovementBounds.origin.y);

    [self unscheduleUpdate];
    [self scheduleUpdate];
}

-(void) update:(ccTime)delta
{
    float x = player.position.x;
    float y = player.position.y;



    if (centerMapOnPlayer)
    {
        //move map

//        CGPoint playerMovePosition = ccpLerp(tiledMap.position, playerEndPosition, travelPercent);
//        CGPoint nextPlayerMovePosition = ccpLerp(startPosition, endPosition, travelPercent+travelIncrement);
//        CGPoint tilePosition = [IsometricTileMapHelper tilePosFromLocation:self.position tileMap:tiledMap];
//        CGPoint playerNextTilePosition = [IsometricTileMapHelper tilePosFromLocation:nextPlayerMovePosition tileMap:currentPlayerMap];

//        tiledMap.position = playerMovePosition;

        CGPoint tileMapMovePosition = ccpLerp(mapStartPosition, mapEndPosition, travelPercent);
        CGPoint playerMovePosition = ccpLerp(playerStartPosition, playerEndPosition, travelPercent);

        tiledMap.position = tileMapMovePosition;
        player.position = playerMovePosition;

        travelPercent += travelIncrement;
//        [player updateVertexZ:tilePosition tileMap:currentPlayerMap];


//        if ([IsometricTileMapHelper isTilePosBlocked:playerNextTilePosition tileMap:currentPlayerMap])
//        {
//            NSLog(@"BLOCKED!");
//            [self unscheduleUpdate];
//        }
//        else
        if (travelPercent >= 1.0)
        {
//            [self unscheduleUpdate];
            centerMapOnPlayer = NO;
        }


    }
    else if (x < playerMovementBounds.origin.x
            || (x > playerMovementBounds.origin.x+ PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH)
            || y < playerMovementBounds.origin.y
            || (y > playerMovementBounds.origin.y+ PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT))
    {
        CCLOG(@"OUT OF BOUNDS");

        /*

        player has shifted out of bounds

        we must move the player to the center of the screen
        map must move with the same vector


         */




        //create a movement animation to move map towards player

//        CGPoint playerPosition = player.position;
//        CGPoint mapPosition = tiledMap.position;

//        CGPoint playerDiff = ccpSub(player.position, Helper.screenCenter);

//        CGPoint newMapPosition = ccpAdd(tiledMap.position, playerDiff);

        travelTime = 0;
        travelPercent = 0;
        playerStartPosition = player.position;
//        playerEndPosition = [Helper movePoint:player.position withLine:player.position end:Helper.screenCenter];
        playerEndPosition = Helper.screenCenter;


        mapStartPosition = tiledMap.position;
        mapEndPosition = [Helper movePoint:tiledMap.position withLine:playerStartPosition end:playerEndPosition];

        float moveDistance = ccpDistance(playerStartPosition, playerEndPosition);
        float moveSpeed = PLAYER_SPEED;
        moveDuration = moveDistance/moveSpeed; // in seconds
        float deltaTime = 1.0f/60.0f;//CCDirector.sharedDirector.secondsPerFrame;
        travelIncrement = deltaTime/ moveDuration;
        centerMapOnPlayer = YES;




        //create a line from center of screen to player
        //apple that line to map
        //move map to end point of line



//            CCAction *move = [CCMoveTo actionWithDuration:0.2 position:newMapPosition];
//            [tiledMap stopAllActions];
//            [tiledMap runAction:move];
    }


}


@end
