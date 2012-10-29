//
//  UserInterfaceScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInterfaceScene.h"
#import "Player.h"
#import "MainGameScene.h"


@implementation UserInterfaceScene

-(CGPoint) locationFromTouch:(UITouch*)touch
{
    return [CCDirector.sharedDirector convertToGL:[touch locationInView:touch.view]];
}

-(CGPoint) locationFromTouches:(NSSet*)touches
{
    return [self locationFromTouch:touches.anyObject];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self locationFromTouches:touches];
    CCLOG(@"touch at x%f y%f", touchLocation.x, touchLocation.y);
    [Player.instance movePlayerToPosition:touchLocation];
}

-(IBAction)pauseTapped:(id)sender
{
    MainGameScene.instance.pause;
}

@end
