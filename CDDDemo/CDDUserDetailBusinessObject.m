//
//  CDDUserDetailBusinessObject.m
//  CDDDemo
//
//  Created by gao feng on 16/2/16.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDUserDetailBusinessObject.h"
#import "CDDUserDetailDataHandlerProtocol.h"
#import "UserProfile.h"

@implementation CDDUserDetailBusinessObject

- (void)changeUserName:(NSString*)name
{
    id<CDDUserDetailDataHandlerProtocol> handler = (id<CDDUserDetailDataHandlerProtocol>)self.weakContext.dataHandler;
    UserProfile* user = [handler getUserProfile];
    user.userName = name;
}

@end
