//
//  IsometricTileMapHelper.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-19.
//
//

#import <Foundation/Foundation.h>

@interface IsometricTileMapHelper : NSObject

+ (void)centerTileMap:(CCTMXTiledMap *)map onTileMapPosition:(CGPoint)centerPosition;
+ (CGPoint)getStartPosForTileMap:(CCTMXTiledMap *)tileMap;
+(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap;
+(BOOL) isTilePosBlocked:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+ (BOOL)isTileEndOfLevel:(CGPoint)charPos tileMap:(CCTMXTiledMap *)tileMap;
+(void) centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;

@end
