//
//  MessageCellBase.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "MessageCellBase.h"

@implementation MessageCellBase

static NSMutableDictionary* registeredRenderCellMap = NULL;

+ (NSMutableDictionary*)getRegisteredRenderCellMap
{
    return registeredRenderCellMap;
}

+ (void)registerRenderCell:(Class)cellClass messageType:(int)mtype
{
    if (!registeredRenderCellMap) {
        registeredRenderCellMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredRenderCellMap setObject:className forKey:[NSNumber numberWithInt:mtype]];
}

+ (float)calculteRenderCellHeight:(ChatMessageBase*)msg
{
    return 0;
}

+ (Class)getRenderClassByMessageType:(int)msgType
{
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [MessageCellBase getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInt:msgType]];
    if (!className) {
        className = @"CCMessageCellUnknown";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}

- (void)doMessageRendering
{
    
}

@end
