//
//  CDDDemoBusinessObjectProtocol.h
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#ifndef CDDDemoBusinessObjectProtocol_h
#define CDDDemoBusinessObjectProtocol_h

@class UserProfile;

@protocol CDDDemoBusinessObjectProtocol <NSObject>

- (void)sendTextMessage:(NSString*)text;

- (void)gotoUserDetailView:(UserProfile*)user;

@end

#endif /* CDDDemoBusinessObjectProtocol_h */
