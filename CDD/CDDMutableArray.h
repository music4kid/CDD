//
//  CDDMutableArray.h
//  CDDDemo
//
//  Created by gao feng on 16/2/18.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDDMutableArray;

@protocol CDDMutableArrayDelegate <NSObject>

- (void)didAddObject:(id)anObject withinArr:(CDDMutableArray*)arr;
- (void)didRemoveObject:(id)anObject withinArr:(CDDMutableArray*)arr;

@end

@interface CDDMutableArray : NSMutableArray

- (void)addArrayObserver:(id<CDDMutableArrayDelegate>)observer;
- (void)removeArrayObserver:(id<CDDMutableArrayDelegate>)observer;

@end
