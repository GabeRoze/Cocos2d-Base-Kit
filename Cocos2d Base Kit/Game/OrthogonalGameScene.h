//
//  OrthogonalGameScene.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    TileMapNode = 50,
} Tags;


@interface OrthogonalGameScene : CCLayer
{
    CCTMXTiledMap *tileMap;
}

@end
