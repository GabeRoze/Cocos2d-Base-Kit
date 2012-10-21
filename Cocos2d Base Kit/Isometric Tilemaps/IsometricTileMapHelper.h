//
//  IsometricTileMapHelper.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-19.
//
//

#import <Foundation/Foundation.h>

@interface IsometricTileMapHelper : NSObject

+(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap;
+(BOOL) isTilePosBlocked:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+(void) centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;

@end
