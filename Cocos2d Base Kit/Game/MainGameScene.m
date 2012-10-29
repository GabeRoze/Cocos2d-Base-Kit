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
//    [GameSceneManager.instance loadSceneWithTargetScene:TargetSceneIsometricGame]; //creates the loading scene and loads main menu
//    [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"IsometricGameScene.ccbi"]];

//    CCLayer gameLayer = [CCBReader scene]
    CCNode *node = [CCBReader nodeGraphFromFile:@"IsometricGameScene.ccbi"];
    IsometricGameScene *isometricGameScene = (IsometricGameScene *)node;
    [isometricGameScene initLevel:1];
//    CCScene *gameScene = [CCBReader sceneWithNodeGraphFromFile:@"IsometricGameScene.ccbi"];

//    [gameScene initLevel:1];
    [self addChild:isometricGameScene z:1];


    CCScene *userInterfaceScene = [CCBReader sceneWithNodeGraphFromFile:@"UserInterfaceScene.ccbi"];
    [self addChild:userInterfaceScene z:0];
}

-(void)pause
{
    [[CCDirector sharedDirector] pause];

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

}

-(void) returnToMainMenu
{
    [self unscheduleAllSelectors];
    [[CCDirector sharedDirector] resume];
    [GameSceneManager.instance loadSceneWithTargetScene:TargetSceneMainMenu];
}

-(void)restartGame
{
    [self unscheduleAllSelectors];
    [[CCDirector sharedDirector] resume];
//    LoadingScene *loadingScene = [LoadingScene sceneWithTargetScene:TargetSceneMultiLayerGameScene];
//    [[CCDirector sharedDirector] replaceScene:loadingScene];
}

@end
