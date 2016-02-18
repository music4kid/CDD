//
//  CDDContext.m
//  CDDDemo
//
//  Created by gao feng on 16/2/3.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDContext.h"
#import "UIView+CDD.h"

@implementation CDDDataHandler
@end

@implementation CDDBusinessObject
@end

@implementation CDDContext

+ (void)enableCDDContext
{
    [UIView prepareUIViewForCDD];
}

- (instancetype)initWithDataHandler:(CDDDataHandler*)dataHandler withBusinessObject:(CDDBusinessObject*)businessObject
{
    self = [super init];
    
    _dataHandler = dataHandler;
    _dataHandler.weakContext = self;
    
    _businessObject = businessObject;
    _businessObject.weakContext = self;
    
    return self;
}

- (void)dealloc
{
    NSLog(@"context being released");
}

@end
