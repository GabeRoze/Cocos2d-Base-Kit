//
//  GameStateManager.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-09.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	TargetSceneINVALID = 0,
    TargetSceneMainMenu = 1,
    TargetSceneOptionsScene = 2,
    TargetSceneBeginGame = 3,
} TargetSceneType;

@interface GameStateManager : CCNode
{
    TargetSceneType nextScene;
}

-(void)loadSceneWithTargetScene:(TargetSceneType)targetScene;
+(GameStateManager*)instance;

@end
