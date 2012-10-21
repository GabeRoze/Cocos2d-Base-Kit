//
//  IsometricGameScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IsometricGameScene.h"


@implementation IsometricGameScene

-(void)didLoadFromCCB
{
    [self initLevel:1];

//    levelTileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"isometric.tmx"];
//    [self addChild:levelTileMap];// z:0 tag:TileMapNode];
//    levelTileMap.position = CGPointMake(-500, -300);

//    self.isTouchEnabled = YES;

//    CGSize screenSize = CCDirector.sharedDirector.winSize;

//    player = [Player player];
//    player.position = CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
//    player.anchorPoint = CGPointMake(0.3f, 0.1f);
//    [self addChild:player];
}

-(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
    // Tilemap position must be subtracted, in case the tilemap position is not at 0,0 due to scrolling
    CGPoint pos = ccpSub(location, tileMap.position);

    float halfMapWidth = tileMap.mapSize.width * 0.5f;
    float mapHeight = tileMap.mapSize.height;
    float pointWidth = tileMap.tileSize.width / CC_CONTENT_SCALE_FACTOR();
    float pointHeight = tileMap.tileSize.height / CC_CONTENT_SCALE_FACTOR();

    CGPoint tilePosDiv = CGPointMake(pos.x / pointWidth, pos.y / pointHeight);
    float inverseTileY = mapHeight - tilePosDiv.y;

    // Cast to int makes sure that result is in whole numbers, tile coordinates will be used as array indices
    float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
    float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);

    // make sure coordinates are within isomap bounds
    posX = MAX(0, posX);
    posX = MIN(tileMap.mapSize.width - 1, posX);
    posY = MAX(0, posY);
    posY = MIN(tileMap.mapSize.height - 1, posY);

    pos = CGPointMake(posX, posY);

//    CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", location.x, location.y, (int)pos.x, (int)pos.y);
    //CCLOG(@"\tinverseY: %.2f -- tilePosDiv: (%.2f, %.2f) -- halfMapWidth: %.0f\n", inverseTileY, tilePosDiv.x, tilePosDiv.y, halfMapWidth);

    return pos;
}

-(void) centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
    // center tilemap on the given tile pos
//    screenSize = [[CCDirector sharedDirector] winSize];
//    screenCenter = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);

    // get the ground layer
    CCTMXLayer* layer = [tileMap layerNamed:@"GroundLayer"];
    NSAssert(layer != nil, @"Ground layer not found!");

    // internally tile Y coordinates are off by 1, this fixes the returned pixel coordinates
    tilePos.y -= 1;

    // get the pixel coordinates for a tile at these coordinates
    CGPoint scrollPosition = [layer positionAt:tilePos];
    // negate the position for scrolling
    scrollPosition = ccpMult(scrollPosition, -1);
    // add offset to screen center
    scrollPosition = ccpAdd(scrollPosition, screenCenter);

//    CCLOG(@"tilePos: (%i, %i) moveTo: (%.0f, %.0f)", (int)tilePos.x, (int)tilePos.y, scrollPosition.x, scrollPosition.y);

    CCAction* move = [CCMoveTo actionWithDuration:0.2f position:scrollPosition];
    [tileMap stopAllActions];
    [tileMap runAction:move];
}

-(CGPoint) locationFromTouch:(UITouch*)touch
{
    return [CCDirector.sharedDirector convertToGL:[touch locationInView:touch.view]];
}

-(CGPoint) locationFromTouches:(NSSet*)touches
{
    return [self locationFromTouch:touches.anyObject];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // get the position in tile coordinates from the touch location
    CGPoint touchLocation = [self locationFromTouches:touches];
    CGPoint tilePos = [self tilePosFromLocation:touchLocation tileMap:levelTileMap];


    [player movePlayerToPosition:touchLocation tileMap:levelTileMap];

    // move tilemap so that touched tiles is at center of screen
//    [self centerTileMapOnTileCoord:tilePos tileMap:levelTileMap];

    //corrects player's Z position so they can be behind tiles
//    [player updateVertexZ:tilePos tileMap:levelTileMap];
}

-(void)initLevel:(int)levelNumber
{
    NSString *levelName = [NSString stringWithFormat:@"%@%i.tmx", LEVEL_NAME_PREFIX, levelNumber];

    levelTileMap = [CCTMXTiledMap tiledMapWithTMXFile:levelName];
    [self addChild:levelTileMap z:0];
    levelTileMap.position = CGPointMake(-500, -300);


    interactionLayer = [levelTileMap layerNamed:@"InteractionLayer"];
    interactionLayer.visible = NO;
    /*
    place player
    center map on player
     */

    screenSize = CCDirector.sharedDirector.winSize;

    player = [Player player];
    player.position = CGPointMake(screenSize.width*0.5, screenSize.height*0.5);

    //modify this to center player on tile (0.5,0.5) original value
    player.anchorPoint = CGPointMake(0.3f, 0.1f);
    [self addChild:player];
    player.currentPlayerMap = levelTileMap;


    self.isTouchEnabled = YES;
    [self scheduleUpdate];

}



-(void)endLevel:(LevelResult)levelResult
{

}



-(void) update:(ccTime)delta
{

    //update player character

//    CGPoint playerPosition = player.position

// if the tilemap is currently being moved, wait until it's done moving
//    if (levelTileMap.numberOfRunningActions == 0)
//    {
//        if ([self isTilePosBlocked:[self tilePosFromLocation:player.position tileMap:levelTileMap] tileMap:levelTileMap])
//        {
//            stop movement
//            [self centerTileMapOnTileCoord:[self tilePosFromLocation:screenCenter tileMap:levelTileMap] tileMap:levelTileMap];
//            NSLog(@"block");
//        }
//    }

}

@end
