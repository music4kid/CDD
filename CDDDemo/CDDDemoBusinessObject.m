//
//  CDDDemoBusinessObject.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDDemoBusinessObject.h"
#import "CDDUserDetailController.h"
#import "ChatMessageText.h"
#import "CDDDemoDataHandlerProtocol.h"
#import "UserProfile.h"

@implementation CDDDemoBusinessObject

- (void)sendTextMessage:(NSString *)text
{
    UserProfile* user = [UserProfile new];
    user.userId = @1;
    user.userName = @"MrPeak";
    user.avatarUrl = @"http://tp2.sinaimg.cn/1993445913/180/40110322733/1";
    
    ChatMessageText* msg = [ChatMessageText new];
    msg.content = text;
    msg.isLeft = false;
    msg.msgType = @(ChatMsgType_Text);
    msg.renderHeight = 58;
    msg.fromUser = user;
    
    //ignore db access here, since we don't have a service layer, let's pretend msg is saved to db automatically...
    id<CDDDemoDataHandlerProtocol> handler = (id<CDDDemoDataHandlerProtocol>)self.weakContext.dataHandler;
    [handler insertNewMessage:msg];
}

- (void)gotoUserDetailView:(UserProfile*)user
{
    CDDUserDetailController* ctrl = [CDDUserDetailController new];
    ctrl.user = user;
    [self.baseController.navigationController pushViewController:ctrl animated:true];
}

@end
