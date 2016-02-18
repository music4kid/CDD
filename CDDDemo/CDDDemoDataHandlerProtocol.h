//
//  CDDDemoDataHandlerProtocol.h
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#ifndef CDDDemoDataHandlerProtocol_h
#define CDDDemoDataHandlerProtocol_h

@class CDDMutableArray;
@class ChatMessageBase;

@protocol CDDDemoDataHandlerProtocol <NSObject>

- (CDDMutableArray*)getMessages;
- (void)insertNewMessage:(ChatMessageBase*)msg;

@end

#endif /* CDDDemoDataHandlerProtocol_h */
