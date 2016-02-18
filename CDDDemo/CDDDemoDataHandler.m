//
//  CDDDemoDataHandler.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDDemoDataHandler.h"
#import "ChatMessageBase.h"

@interface CDDDemoDataHandler ()
@property (nonatomic, strong) CDDMutableArray*                 messages;
@end

@implementation CDDDemoDataHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messages = [CDDMutableArray new];
    }
    return self;
}

- (CDDMutableArray*)getMessages
{
    return self.messages;
}

- (void)insertNewMessage:(ChatMessageBase*)msg
{
    [_messages addObject:msg];
}

@end
