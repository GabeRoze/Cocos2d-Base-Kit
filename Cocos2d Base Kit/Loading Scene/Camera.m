//
//  Camera.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"

@implementation Camera

@synthesize currentLevelMap;

+(Camera*)instance
{
    static Camera* instance = nil;

    if (!instance)
    {
        instance = [Camera camera];
    }

    return instance;
}

+(id)camera
{
    return [[self alloc] init];
}


-(void)begin
{
    [self scheduleUpdate];
}

-(void)end
{
    [self unscheduleUpdate];
}

- (void)moveNode:(CCNode *)node toPosition:(CGPoint)position withDelay:(float)delay
{
    nodeMovePoint = position;
    moveNode = node;
    [self performSelector:@selector(moveNode) withObject:nil afterDelay:delay];
}

-(void)moveNode
{
    moveNode.position = nodeMovePoint;
//    currentLevelMap.position = nodeMovePoint;
}

-(void) moveMapToPosition:(CGPoint)newPosition tileMap:(CCTMXTiledMap *)tileMap
{
    travelTime = 0;
    travelPercent = 0;
    currentLevelMap = tileMap;
    mapStartLocation = tileMap.position;

//    mapEndLocation = [self movePoint:tileMap.position withLine:self.position end:newPosition];


    float moveDistance = ccpDistance(mapStartLocation, mapEndLocation);
    float moveSpeed = PLAYER_SPEED;
    moveDuration = moveDistance/moveSpeed; // in seconds
    float deltaTime = 1.0f/60.0f;//CCDirector.sharedDirector.secondsPerFrame;
    travelIncrement = deltaTime/ moveDuration;

    [self unscheduleUpdate];
    [self scheduleUpdate];
}


-(void) update:(ccTime)delta
{
    CCLOG(@"update");
    //check the position of the player
    // if the players position is not in the center of the screen log shit

//    CGPoint playerPosition = Player.instance

    [self followPlayer];

}


-(void)followPlayer
{
    CGPoint playerPosition = Player.instance.position;
    CCLOG(@"player pos x%f y%f", playerPosition.x, playerPosition.y);

//    CGSize screenSize = SCREEN_SIZE;

//    NSLog(@"screen size %@", screenSize);

}

@end
