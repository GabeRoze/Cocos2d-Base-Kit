//
//  AlertHelper.m
//  Dealio
//
//  Created by Gabe Rozenberg on 12-09-02.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "AlertHelper.h"
#import "UIAlertView+Blocks.h"

@implementation AlertHelper

+(void)displayAlertWithTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)firstTitle firstAction:(void (^)())firstAction secondButton:(NSString *)secondTitle secondAction:(void (^)())secondAction
{
    RIButtonItem *firstButton = [RIButtonItem item];
    firstButton.label = firstTitle;
    firstButton.action = firstAction;

    RIButtonItem *secondButton = [RIButtonItem item];
    secondButton.label = secondTitle;
    secondButton.action = secondAction;

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:nil
                                               otherButtonItems:firstButton, secondButton, nil];
    alertView.show;
}


+(void)displayAlertWithOKButtonUsingTitle:(NSString *)title andAction:(void (^)())action
{
    RIButtonItem *buttonItem = [RIButtonItem new];
    buttonItem.label = @"OK";
    buttonItem.action = action;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" cancelButtonItem:buttonItem otherButtonItems:nil];
    [alertView show];
}

+(void)displayAlertWithOKButtonUsingTitle:(NSString *)title withMessage:(NSString *)message andAction:(void (^)())action
{
    RIButtonItem *buttonItem = [RIButtonItem new];
    buttonItem.label = @"OK";
    buttonItem.action = action;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:buttonItem otherButtonItems:nil];
    [alertView show];
}

+(void)displayAlertWithOKButtonAndCancelButtonUsingTitle:(NSString *)title withMessage:(NSString *)message andAction:(void (^)())action
{
    RIButtonItem *cancelButton = [RIButtonItem new];
    cancelButton.label = @"Cancel";
    RIButtonItem *buttonItem = [RIButtonItem new];
    buttonItem.label = @"OK";
    buttonItem.action = action;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:cancelButton otherButtonItems:buttonItem, nil];
    [alertView show];
}

+(void)displayWebConnectionFail
{
    RIButtonItem *buttonItem = [RIButtonItem new];
    buttonItem.label = @"OK";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable To Reach Dealio" message:@"" cancelButtonItem:buttonItem otherButtonItems:nil];
    [alertView show];
}


@end
