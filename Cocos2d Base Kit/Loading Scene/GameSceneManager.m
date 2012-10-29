//
//  GameSceneManager.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-09.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameSceneManager.h"

@implementation GameSceneManager

-(id)init
{
    if (self = [super init])
    {
        [self displayLoadingScene];
    }
    return self;
}

-(void)displayLoadingScene
{
    [CCDirector.sharedDirector pushScene:[CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"]];
}

-(void)loadSceneWithTargetScene:(TargetSceneType)targetScene
{
    [CCDirector.sharedDirector replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"]];

    //loading shit
    //http://www.cocos2d-iphone.org/forum/topic/2242

    nextScene = targetScene;
    [self performSelector:@selector(load) withObject:nil afterDelay:1.0f];
}

-(void)load
{
    switch (nextScene)
    {
        case TargetSceneMainMenu:
            [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"]];
            break;
        case TargetSceneOptionsScene:
            [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"OptionsScene.ccbi"]];
            break;
        case TargetSceneBeginGame:
            [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"]];
            break;
        case TargetSceneIsometricGame:
            [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"IsometricGameScene.ccbi"]];
            break;
        default:
            // Always warn if an unspecified enum value was used. It's a reminder for yourself to update the switch
            // whenever you add more enum values.
//			NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene);
            break;
    }
}

+(GameSceneManager *)instance
{
    static GameSceneManager * instance = nil;

    if (!instance)
    {
        instance = [GameSceneManager new];
    }

    return instance;
}
@end
