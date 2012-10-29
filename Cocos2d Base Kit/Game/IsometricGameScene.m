//
//  IsometricGameScene.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IsometricGameScene.h"

@implementation IsometricGameScene

-(void)didLoadFromCCB
{
//    [self initLevel:1];
}

//-(CGPoint) locationFromTouch:(UITouch*)touch
//{
//    return [CCDirector.sharedDirector convertToGL:[touch locationInView:touch.view]];
//}
//
//-(CGPoint) locationFromTouches:(NSSet*)touches
//{
//    return [self locationFromTouch:touches.anyObject];
//}
//
//-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touchLocation = [self locationFromTouches:touches];
//    [player movePlayerToPosition:touchLocation tileMap:levelTiledMap];
//}

-(void)initLevel:(int)levelNumber
{
    NSString *levelName = [NSString stringWithFormat:@"%@%i.tmx", LEVEL_NAME_PREFIX, levelNumber];

//    gameLayer = [CCNode node];
    gameLayer = [CCLayer node];


    levelTiledMap = [CCTMXTiledMap tiledMapWithTMXFile:levelName];
    [gameLayer addChild:levelTiledMap z:0];
//    levelTiledMap.anchorPoint = CGPointMake(0.5f, 0.5f);
//    levelTiledMap.position = CGPointMake(-650, -450);
    levelTiledMap.position = CGPointMake(-500, -300);
//    levelTiledMap.position = screenCenter;

    interactionLayer = [levelTiledMap layerNamed:@"InteractionLayer"];
    interactionLayer.visible = NO;
//    player = [Player player];
//    player = Player.instance;
    player = [Player playerWithMap:levelTiledMap gameLayer:gameLayer];


//    player.position = CGPointMake(Helper.screenSize.width*0.5, Helper.screenSize.height*0.5);
    player.position = Helper.screenCenter;
    player.anchorPoint = CGPointMake(0.5f, 0.5f);
//    player.currentPlayerMap = levelTiledMap;

    [gameLayer addChild:player];

//    player.gameLayer = gameLayer;
//    [gameLayer addChild:player];

    [self addChild:gameLayer];

    self.isTouchEnabled = YES;

//    [camera followPlayer:player withTiledMap:levelTiledMap];
    [player scheduleUpdate];

//    [self drawBounds];
}

-(void)endLevel:(LevelResult)levelResult
{

}

-(void) update:(ccTime)delta
{
}



//Draws the center bounding box
-(void)draw
{

// Draw the object rectangles for debugging and illustration purposes.
    float movementBoundsHeight = PLAYER_MOVEMENT_BOUNDING_BOX_HEIGHT;
    float movementBoundsWidth = PLAYER_MOVEMENT_BOUNDING_BOX_WIDTH;
    CGRect playerMovementBounds = CGRectMake(Helper.screenCenter.x - movementBoundsWidth/2, Helper.screenCenter.y - movementBoundsHeight/2, movementBoundsWidth, movementBoundsHeight);

    // make the lines thicker
    glLineWidth(2.0f * CC_CONTENT_SCALE_FACTOR());
    ccDrawColor4F(1, 0, 1, 1);

    CGPoint dest = CGPointMake(playerMovementBounds.origin.x + playerMovementBounds.size.width, playerMovementBounds.origin.y + playerMovementBounds.size.height);

    ccDrawRect(playerMovementBounds.origin, dest);

    glLineWidth(1.0f);

}

@end
