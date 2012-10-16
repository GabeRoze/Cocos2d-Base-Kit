//
//  LoadingScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-04.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"

@implementation LoadingScene

+(id)sceneWithTargetScene:(TargetSceneTypes)sceneType
{
    CCLOG(@"===========================================");
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);

    // This creates an autorelease object of self.
    // In class methods self refers to the current class and in this case is equivalent to LoadingScene.
    return [[self alloc] initWithTargetScene:sceneType];
//    return
}

+(CCScene*)loadingSceneWithTargetScene:(TargetSceneTypes)sceneType
{
    CCLOG(@"===========================================");
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);

    CCScene *loadingScene = [CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"];
    [CCDirector.sharedDirector replaceScene:loadingScene];

    return nil;

}

-(CCScene*)initWithTargetScene:(TargetSceneTypes)sceneType
{
    return nil;
}


- (void) didLoadFromCCB
{
//    sharedScene = self;

//    self.score = 0;

    // Load the level
//    level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];

    // And add it to the game scene
//    [levelLayer addChild:level];
}


//-(id) initWithTargetScene:(TargetSceneTypes)sceneType
//{
//	if ((self = [super init]))
//	{
//		targetScene = sceneType;
//
//		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Marker Felt" fontSize:64];
//		CGSize size = [CCDirector sharedDirector].winSize;
//		label.position = CGPointMake(size.width / 2, size.height / 2);
//		[self addChild:label];
//        CCScene *loadingScene = [CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"];
//        [CCDirector.sharedDirector pushScene:loadingScene];

//

// Must wait at least one frame before loading the target scene!
// Two reasons: first, it would crash if not. Second, the Loading label wouldn't be displayed.
// In this case delay is set to > 0.0f just so you can actually see the LoadingScene.
// If you use the LoadingScene in your own code, be sure to set the delay to 0.0f
//		[self scheduleOnce:@selector(loadScene:) delay:2.0f];
//	}
//	return self;
//}

-(void)loadWithTargetScene:(TargetSceneTypes)sceneType
{
    targetScene = sceneType;

    //		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Marker Felt" fontSize:64];
    //		CGSize size = [CCDirector sharedDirector].winSize;
    //		label.position = CGPointMake(size.width / 2, size.height / 2);
    //		[self addChild:label];
    CCScene *loadingScene = [CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"];
    [CCDirector.sharedDirector pushScene:loadingScene];

    //

    // Must wait at least one frame before loading the target scene!
    // Two reasons: first, it would crash if not. Second, the Loading label wouldn't be displayed.
    // In this case delay is set to > 0.0f just so you can actually see the LoadingScene.
    // If you use the LoadingScene in your own code, be sure to set the delay to 0.0f
    [self scheduleOnce:@selector(loadScene:) delay:2.0f];
}


-(void) loadScene:(ccTime)delta
{
    // Decide which scene to load based on the TargetScenes enum.
    // You could also use TargetScene to load the same with using a variety of transitions.
    switch (targetScene)
    {
        case TargetSceneFirst:
//			[[CCDirector sharedDirector] replaceScene:[FirstLayer scene]];
            break;
        case TargetSceneSecond:
//			[[CCDirector sharedDirector] replaceScene:[SecondLayer scene]];
            break;
        case TargetSceneMainMenu:
//            CCScene *mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
            [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"]];
        default:
            // Always warn if an unspecified enum value was used. It's a reminder for yourself to update the switch
            // whenever you add more enum values.
//			NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene);
            break;
    }

    // Tip: example usage of the INVALID and MAX enum values to iterate over all enum values
//	for (TargetSceneTypes i = TargetSceneINVALID + 1; i < TargetSceneMAX; i++)
//	{
//	}
}

@end
