//
//  IsometricGameScene.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

typedef enum
{
    TileMapNode = 50,
} Tags;

typedef enum
{
    LevelSuccess,
    LevelFail,
    LevelQuit,
    LevelRestart,

} LevelResult;

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface IsometricGameScene : CCLayer
{
    CCTMXTiledMap *levelTileMap;
    CCTMXLayer *interactionLayer;
    Player *player;

    CGSize screenSize;
    CGPoint screenCenter;
}


@end
