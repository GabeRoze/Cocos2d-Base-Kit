//
//  MainGameScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainGameScene.h"
#import "GameSceneManager.h"
#import "IsometricGameScene.h"
#import "AlertHelper.h"

@implementation MainGameScene

static MainGameScene *instance;

+(MainGameScene*)instance
{
    return instance;
}

-(void)didLoadFromCCB
{
    instance = self;
    //todo switch game scene to desired game type

//    CCLayer gameLayer = [CCBReader scene]
    CCNode *node = [CCBReader nodeGraphFromFile:@"IsometricGameScene.ccbi"];
    IsometricGameScene *isometricGameScene = (IsometricGameScene *)node;
    [isometricGameScene initLevel:1];

//    [gameScene initLevel:1];
    [self addChild:isometricGameScene z:1];

    CCScene *userInterfaceScene = [CCBReader sceneWithNodeGraphFromFile:@"UserInterfaceScene.ccbi"];
    [self addChild:userInterfaceScene z:0];
}

-(void)pause
{
    [[CCDirector sharedDirector] pause];

    //todo present a pause overlay screen? or go with something more simple
    [AlertHelper displayAlertWithTitle:@"Game Paused"
                               message:nil
                           firstButton:@"Resume" firstAction:^{
                                CCDirector.sharedDirector.resume;
                           } secondButton:@"Quit" secondAction:^{
                                [self returnToMainMenu];
                            }];
}

-(void)gameOver
{
    //todo present player with the game over scene (overlay) with their options (retry, main menu)
}

-(void)levelSuccess:(int)levelNumber
{
    //todo present level victory screen showing what you've won
    //take user to the level select scene
}

-(void) returnToMainMenu
{
    [self unscheduleAllSelectors];
    [[CCDirector sharedDirector] resume];
    [GameSceneManager.instance loadSceneWithTargetScene:TargetSceneMainMenu];
}

-(void)restartLevel
{
    //todo restart game

    [self unscheduleAllSelectors];
    [[CCDirector sharedDirector] resume];
//    LoadingScene *loadingScene = [LoadingScene sceneWithTargetScene:TargetSceneMultiLayerGameScene];
//    [[CCDirector sharedDirector] replaceScene:loadingScene];
}

@end
