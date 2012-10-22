//
//  Camera.m
//  Cocos2d Base Kit
//
//  Created by Gabe Rozenberg on 12-10-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"


@implementation Camera







+(Camera*)instance
{
    static Camera* instance = nil;

    if (!instance)
    {
        instance = [Camera new];
    }

    return instance;
}

@end
