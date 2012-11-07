//
//  MainGameScene.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
/*
    Contains functions standard to all games

 */
@interface MainGameScene : CCLayer {

}


-(void)pause;

+(MainGameScene*)instance;
@end
