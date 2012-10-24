//
//  Camera.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface Camera : CCLayer
{
    CCTMXTiledMap *tiledMap;
    Player *player;
    CGRect playerMovementBounds;
    BOOL centerMapOnPlayer;

    CGPoint playerStartPosition;
    CGPoint playerEndPosition;

    CGPoint mapStartPosition;
    CGPoint mapEndPosition;


    ccTime travelTime;
    float moveDuration;
    float travelPercent;
    float travelIncrement;

}

-(void)followPlayer:(Player *)tiledPlayer withTiledMap:(CCTMXTiledMap *)map;

@end
