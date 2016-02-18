//
//  CDDContext.h
//  CDDDemo
//
//  Created by gao feng on 16/2/3.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CDD.h"

@class CDDContext;

//DataHandler owns data source, handle data changes
@interface CDDDataHandler : NSObject
@property (nonatomic, weak) CDDContext*                 weakContext;
@end

//BusinessObject takes care of all business logic
@interface CDDBusinessObject : NSObject
@property (nonatomic, weak) CDDContext*                 weakContext;
@property (nonatomic, weak) UIViewController*           baseController;

@end



//Context bridges everything automatically, no need to pass it around manually
@interface CDDContext : NSObject

@property (nonatomic, strong, readonly) CDDDataHandler*         dataHandler;//handle viewModel change
@property (nonatomic, strong, readonly) CDDBusinessObject*      businessObject;//handle business logic

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (void)enableCDDContext;

- (instancetype)initWithDataHandler:(CDDDataHandler*)dataHandler withBusinessObject:(CDDBusinessObject*)businessObject NS_DESIGNATED_INITIALIZER;

@end
