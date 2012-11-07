//
//  IsometricTileMapHelper.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-19.
//
//

#import <CoreGraphics/CoreGraphics.h>
#import "IsometricTileMapHelper.h"

@implementation IsometricTileMapHelper


+ (CGPoint)getStartPosForTileMap:(CCTMXTiledMap *)tileMap
{
    CGPoint startTile = CGPointZero;
    CCTMXLayer *layer = [tileMap layerNamed:@"InteractionLayer"];
    CGSize s = [layer layerSize];

    for (int x = 0; x < s.width; x++)
    {
        for (int y = 0; y < s.height; y++)
        {
            unsigned int tileGid = [layer tileGIDAt:ccp(x, y)];
            if (tileGid > 0)
            {
                NSDictionary *tileProperties = [tileMap propertiesForGID:tileGid];
                id isStartTile = [tileProperties objectForKey:@"startTile"];
                if (isStartTile)
                {
                    startTile = ccp(x, y);
                }
            }
        }
    }
    return startTile;
}

+ (void)centerTileMap:(CCTMXTiledMap *)map onTileMapPosition:(CGPoint)centerPosition
{
    // get the ground layer
    CCTMXLayer *layer = [map layerNamed:@"GroundLayer"];

    // internally tile Y coordinates are off by 1, this fixes the returned pixel coordinates
    centerPosition.y -= 1;

    // get the pixel coordinates for a tile at these coordinates
    CGPoint scrollPosition = [layer positionAt:centerPosition];
    // negate the position for scrolling
    scrollPosition = ccpMult(scrollPosition, -1);
    // add offset to screen center
    scrollPosition = ccpAdd(scrollPosition, Helper.screenCenter);

    map.position = scrollPosition;
}


+ (CGPoint)tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap *)tileMap
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
    float posX = (int) (inverseTileY + tilePosDiv.x - halfMapWidth);
    float posY = (int) (inverseTileY - tilePosDiv.x + halfMapWidth);

    // make sure coordinates are within isomap bounds
    posX = MAX(0, posX);
    posX = MIN(tileMap.mapSize.width - 1, posX);
    posY = MAX(0, posY);
    posY = MIN(tileMap.mapSize.height - 1, posY);

    pos = CGPointMake(posX, posY);

//    CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", location.x, location.y, (int)pos.x, (int)pos.y);
//    CCLOG(@"\tinverseY: %.2f -- tilePosDiv: (%.2f, %.2f) -- halfMapWidth: %.0f\n", inverseTileY, tilePosDiv.x, tilePosDiv.y, halfMapWidth);

    return pos;
}


+ (BOOL)isTilePosBlocked:(CGPoint)tilePos tileMap:(CCTMXTiledMap *)tileMap
{
//    tilePos = [IsometricTileMapHelper tilePosFromLocation:tilePos tileMap:tileMap];
    CCTMXLayer *layer = [tileMap layerNamed:@"WallLayer"];
//    NSAssert(layer != nil, @"Collisions layer not found!");

    BOOL isBlocked = NO;
    unsigned int tileGID = [layer tileGIDAt:tilePos];
    if (tileGID > 0)
    {
        NSDictionary *tileProperties = [tileMap propertiesForGID:tileGID];
        id blocks_movement = [tileProperties objectForKey:@"wall"];
        isBlocked = (blocks_movement != nil);
    }
    return isBlocked;
}

+ (BOOL)isTileEndOfLevel:(CGPoint)charPos tileMap:(CCTMXTiledMap *)tileMap
{
    CGPoint tilePos = [IsometricTileMapHelper tilePosFromLocation:charPos tileMap:tileMap];
    CCTMXLayer *layer = [tileMap layerNamed:@"InteractionLayer"];

    BOOL isEndTile = NO;
    unsigned int tileGID = [layer tileGIDAt:tilePos];
    if (tileGID > 0)
    {
        NSDictionary *tileProperties = [tileMap propertiesForGID:tileGID];
        id blocks_movement = [tileProperties objectForKey:@"endTile"];
        isEndTile = (blocks_movement != nil);
    }
    return isEndTile;
}

+ (void)centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap *)tileMap
{
    // center tilemap on the given tile pos
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint screenCenter = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);

    // get the ground layer
    CCTMXLayer *layer = [tileMap layerNamed:@"GroundLayer"];
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

    CCAction *move = [CCMoveTo actionWithDuration:0.2f position:scrollPosition];
    [tileMap stopAllActions];
    [tileMap runAction:move];
}

@end
