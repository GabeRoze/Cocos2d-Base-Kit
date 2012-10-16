//
//  LoadingScene.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-04.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	TargetSceneINVALID = 0,
	TargetSceneFirst,
	TargetSceneSecond,
	TargetSceneMAX,
    TargetSceneMainMenu,
} TargetSceneTypes;

@interface LoadingScene : CCScene
{
    TargetSceneTypes targetScene;
}

//-(void)loadWithTargetScene:(TargetSceneTypes)sceneType;
//+(id) sceneWithTargetScene:(TargetSceneTypes)sceneType;
//-(id) initWithTargetScene:(TargetSceneTypes)sceneType;
-(CCScene*)initWithTargetScene:(TargetSceneTypes)sceneType;
+(CCScene*)loadingSceneWithTargetScene:(TargetSceneTypes)sceneType;

@end
