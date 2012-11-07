//
//  IsometricGameScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IsometricGameScene.h"
#import "IsometricTileMapHelper.h"

@implementation IsometricGameScene

- (void)didLoadFromCCB
{
}

- (void)initLevel:(int)levelNumber
{
    NSString *levelName = [NSString stringWithFormat:@"%@%i.tmx", LEVEL_NAME_PREFIX, levelNumber];

    gameLayer = [CCLayer node];


    levelTiledMap = [CCTMXTiledMap tiledMapWithTMXFile:levelName];
    CGPoint startPos = [IsometricTileMapHelper getStartPosForTileMap:levelTiledMap];
    [IsometricTileMapHelper centerTileMap:levelTiledMap onTileMapPosition:startPos];
    [gameLayer addChild:levelTiledMap z:0];


    interactionLayer = [levelTiledMap layerNamed:@"InteractionLayer"];
    interactionLayer.visible = NO;

    player = [Player playerWithMap:levelTiledMap gameLayer:gameLayer];
    player.position = Helper.screenCenter;
    player.anchorPoint = CGPointMake(0.5f, 0.5f);
    [gameLayer addChild:player];

    [self addChild:gameLayer];

    self.isTouchEnabled = YES;

    [player scheduleUpdate];
    [self scheduleUpdate];
}

- (void)endLevel:(LevelResult)levelResult
{

}

- (void)update:(ccTime)delta
{
    if ([IsometricTileMapHelper isTileEndOfLevel:player.position tileMap:levelTiledMap])
    {
        [self endLevel:LevelWon];
    }
}

//Draws the center bounding box
- (void)draw
{
    // Draw the object rectangles for debugging and illustration purposes.
    float movementBoundsHeight = PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT;
    float movementBoundsWidth = PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH;
    CGRect playerMovementBounds = CGRectMake(Helper.screenCenter.x - movementBoundsWidth / 2, Helper.screenCenter.y - movementBoundsHeight / 2, movementBoundsWidth, movementBoundsHeight);

    // make the lines thicker
    glLineWidth(2.0f * CC_CONTENT_SCALE_FACTOR());
    ccDrawColor4F(1, 0, 1, 1);

    CGPoint dest = CGPointMake(playerMovementBounds.origin.x + playerMovementBounds.size.width, playerMovementBounds.origin.y + playerMovementBounds.size.height);

    ccDrawRect(playerMovementBounds.origin, dest);

    glLineWidth(1.0f);

}
@end
