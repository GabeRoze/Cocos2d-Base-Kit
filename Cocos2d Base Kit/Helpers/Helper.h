//
//  Helper.h
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-23.
//
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+(CGPoint)screenCenter;
+(CGSize)screenSize;
+(CGPoint)movePoint:(CGPoint)pointToMove withLine:(CGPoint)start end:(CGPoint)end;

@end
