//
//  PickUpSprite.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-11-01.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PickUpSprite : CCSprite
{
    CCTMXTiledMap *levelMap;

}


+(id)pickUpSpriteWithImage:(NSString *)image tileMap:(CCTMXTiledMap *)map;


@end
