//
//  Config.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//
//
\
#import <Foundation/Foundation.h>

@interface Config : NSObject

/*
    Name your level files LEVEL_NAME_PREFIX(int)
    example: Level1
    DO NOT USE TRAILING ZEROS (ex 01, 02) IN YOUR LEVEL NAMES!
 */
#define LEVEL_NAME_PREFIX @"Level"

//Player config
#define PLAYER_SPEED 200.0

@end
