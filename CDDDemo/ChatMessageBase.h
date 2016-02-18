//
//  ChatMessageBase.h
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ChatMsgType_Text = 0,
    ChatMsgType_Image,
    ChatMsgType_Voice,
} ChatMsgType;

@class UserProfile;

@interface ChatMessageBase : NSObject

@property (nonatomic, strong) NSNumber*         msgType;
@property (nonatomic, strong) UserProfile*      fromUser;


@property (nonatomic, assign)   float           renderWidth;
@property (nonatomic, assign)   float           renderHeight;
@property (nonatomic, assign)   BOOL            isLeft;//message position, left or right.

@end
