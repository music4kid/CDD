//
//  CDDMutableArray.m
//  CDDDemo
//
//  Created by gao feng on 16/2/18.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#define SEMA_W(sema) dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
#define SEMA_S(sema) dispatch_semaphore_signal(sema);

#import "CDDMutableArray.h"

@interface CDDMutableArrayObserverProxy : NSObject
@property (nonatomic, weak) id<CDDMutableArrayDelegate>                 realObserver;
@end
@implementation CDDMutableArrayObserverProxy
@end

@interface CDDMutableArray ()
@property (nonatomic, strong) NSMutableArray*                 arr;
@property (nonatomic, strong) NSMutableArray*                 observers;
@property (nonatomic, strong) dispatch_semaphore_t            sema_arr;
@property (nonatomic, strong) dispatch_semaphore_t            sema_observer;
@end

@implementation CDDMutableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr = [NSMutableArray new];
        self.observers = [NSMutableArray new];
        self.sema_arr = dispatch_semaphore_create(1);
        self.sema_observer = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addObject:(id)anObject
{
    SEMA_W(_sema_arr)
    [_arr addObject:anObject];
    SEMA_S(_sema_arr)
    
    SEMA_W(_sema_observer)
    for (CDDMutableArrayObserverProxy* ob in self.observers) {
        if ([ob.realObserver respondsToSelector:@selector(didAddObject:withinArr:)]) {
            [ob.realObserver didAddObject:anObject withinArr:self];
        }
    }
    SEMA_S(_sema_observer)
}

- (void)removeObject:(id)anObject
{
    SEMA_W(_sema_arr)
    [_arr removeObject:anObject];
    SEMA_S(_sema_arr)
    
    SEMA_W(_sema_observer)
    for (CDDMutableArrayObserverProxy* ob in self.observers) {
        if ([ob.realObserver respondsToSelector:@selector(didRemoveObject:withinArr:)]) {
            [ob.realObserver didRemoveObject:anObject withinArr:self];
        }
    }
    SEMA_S(_sema_observer)
}

- (void)addArrayObserver:(id<CDDMutableArrayDelegate>)observer
{
    if (observer &&
        [observer conformsToProtocol:@protocol(CDDMutableArrayDelegate)]) {
        
        SEMA_W(_sema_observer)
        
        BOOL contains = false;
        for (CDDMutableArrayObserverProxy* proxy in self.observers) {
            if (proxy.realObserver == observer) {
                contains = true;
            }
        }
        if (contains == false) {
            CDDMutableArrayObserverProxy* proxy = [CDDMutableArrayObserverProxy new];
            proxy.realObserver = observer;
            [self.observers addObject:proxy];
        }
        
        SEMA_S(_sema_observer)
    }
}

- (void)removeArrayObserver:(id<CDDMutableArrayDelegate>)observer
{
    if (observer &&
        [observer conformsToProtocol:@protocol(CDDMutableArrayDelegate)]) {
        
        SEMA_W(_sema_observer)
        
        CDDMutableArrayObserverProxy* targetProxy = nil;
        for (CDDMutableArrayObserverProxy* proxy in self.observers) {
            if (proxy.realObserver == observer) {
                targetProxy = proxy;
            }
        }
        
        if (targetProxy != nil) {
            [self.observers removeObject:targetProxy];
        }
        
        SEMA_S(_sema_observer)
    }
}

#pragma mark- NSMutableArray methods

- (NSUInteger)count {
    SEMA_W(_sema_arr)
    NSUInteger c = _arr.count;
    SEMA_S(_sema_arr)
    return c;
}

- (id)objectAtIndex:(NSUInteger)index {
    SEMA_W(_sema_arr)
    id obj = [_arr objectAtIndex:index];
    SEMA_S(_sema_arr)
    return obj;
}

- (BOOL)containsObject:(id)anObject {
    SEMA_W(_sema_arr)
    BOOL contains = [_arr containsObject:anObject];
    SEMA_S(_sema_arr)
    return contains;
}

- (void)dealloc
{
    [self.observers removeAllObjects];
}

@end
