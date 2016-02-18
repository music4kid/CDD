//
//  MessageCellBase.h
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageBase.h"

@interface MessageCellBase : UITableViewCell

@property (nonatomic, strong) ChatMessageBase*          chatMsg;

+ (NSMutableDictionary*)getRegisteredRenderCellMap;
+ (void)registerRenderCell:(Class)cellClass messageType:(int)mtype;

+ (float)calculteRenderCellHeight:(ChatMessageBase*)msg;
+ (Class)getRenderClassByMessageType:(int)msgType;

- (void)doMessageRendering;

@end
