//
//  CDDUserDetailDataHandlerProtocol.h
//  CDDDemo
//
//  Created by gao feng on 16/2/18.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserProfile;

@protocol CDDUserDetailDataHandlerProtocol <NSObject>

- (void)setUserProfile:(UserProfile*)user;
- (UserProfile*)getUserProfile;

@end