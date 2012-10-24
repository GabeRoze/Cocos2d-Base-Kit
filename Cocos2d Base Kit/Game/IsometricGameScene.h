//
//  IsometricGameScene.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
#import "Camera.h"

@interface IsometricGameScene : CCLayer
{
    CCTMXTiledMap *levelTiledMap;
    CCTMXLayer *interactionLayer;
    Player *player;
    Camera *camera;

    BOOL isMoving;
    CGPoint startLocation;
    CGPoint endLocation;
    ccTime travelTime;
    float travelPercent;
    float travelIncrement;

    CCNode *gameNode;
}


@end
