//
//  Camera.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface Camera : CCNode
{
    CGPoint nodeMovePoint;
    CCNode *moveNode;

    CGPoint mapStartLocation;
    CGPoint mapEndLocation;

    ccTime travelTime;
    float moveDuration;
    float travelPercent;
    float travelIncrement;
}

@property (strong, nonatomic) CCTMXTiledMap *currentLevelMap;
@property (strong, nonatomic) Player *player;

-(void)begin;
-(void)end;
- (void)moveNode:(CCNode *)node toPosition:(CGPoint)position withDelay:(float)delay;
+(Camera*)instance;
+(id)camera;

-(void) moveMapToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap;



@end
