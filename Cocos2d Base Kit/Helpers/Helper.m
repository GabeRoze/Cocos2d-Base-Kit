//
//  Helper.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-23.
//
//

#import "Helper.h"

@implementation Helper

+(CGSize)screenSize
{
    return CCDirector.sharedDirector.winSize;
}

+(CGPoint)screenCenter
{
    return CGPointMake(Helper.screenSize.width * 0.5f, Helper.screenSize.height * 0.5f);
}

+(CGPoint)movePoint:(CGPoint)pointToMove withLine:(CGPoint)start end:(CGPoint)end
{
    CGPoint diff = ccpSub(start, end);
    CGPoint newPoint = ccpAdd(pointToMove, diff);
    return newPoint;
}


@end
