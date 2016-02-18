//
//  CDDUserDetailDataHandler.m
//  CDDDemo
//
//  Created by gao feng on 16/2/16.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDUserDetailDataHandler.h"

@interface CDDUserDetailDataHandler ()
@property (nonatomic, strong) UserProfile*                 user;
@end

@implementation CDDUserDetailDataHandler

- (void)setUserProfile:(UserProfile*)user
{
    self.user = user;
}

- (UserProfile*)getUserProfile
{
    return self.user;
}

@end
