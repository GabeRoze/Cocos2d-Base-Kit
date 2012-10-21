//
//  MainMenuScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-09.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameStateManager.h"

@implementation MainMenuScene

- (void) didLoadFromCCB
{
    CCLOG(@"Main menu did load==========");
}

-(void)playTapped:(id)sender
{
    CCLOG(@"====PLAY!====");
    [GameStateManager.instance loadSceneWithTargetScene:TargetSceneBeginGame];
}

-(void)optionsTapped:(id)sender
{
    CCLOG(@"====OPTIONS!====");
    [GameStateManager.instance loadSceneWithTargetScene:TargetSceneOptionsScene];
}

@end
