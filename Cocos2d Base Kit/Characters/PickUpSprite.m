//
//  PickUpSprite.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-11-01.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PickUpSprite.h"

/*
    need a method to create all the sprites according to the map
    sprite needs a type
        ex: enemy
        ex:

    sprite needs to initiated as either animatable, static image, or particle







 */



@implementation PickUpSprite

+(id)pickUpSpriteWithImage:(NSString *)image tileMap:(CCTMXTiledMap *)map
{
    return [[self alloc] initWithSpriteImage:image tileMap:map];
}

-(id)initWithSpriteImage:(NSString *)image tileMap:(CCTMXTiledMap *)map
{
    if ((self = [super initWithFile:image]))
    {
        levelMap = map;
    }
    return self;
}


//set position


@end
