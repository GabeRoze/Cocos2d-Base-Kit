//
//  OptionsMenuScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsMenuScene.h"
#import "GameSceneManager.h"

@implementation OptionsMenuScene


-(IBAction)backTapped:(id)sender
{
    CCLOG(@"back to main menu=================");
    [GameSceneManager.instance loadSceneWithTargetScene:TargetSceneMainMenu];
}

@end
