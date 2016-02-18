//
//  UIView+CDD.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "UIView+CDD.h"
#import "NSObject+CDD.h"

@implementation UIView (CDD)

+ (void)prepareUIViewForCDD
{
    [self swizzleInstanceSelector:@selector(didAddSubview:) withSelector:@selector(newDidAddSubview:)];
}

- (void)newDidAddSubview:(UIView*)view
{
    [self newDidAddSubview:view];
    
    [self buildViewContextFromSuper:view];
}

- (void)buildViewContextFromSuper:(UIView*)view
{
    CFTimeInterval start = CACurrentMediaTime();
    
    if (view.context == nil) {
        UIView* sprView = view.superview;
        while (sprView != nil) {
            if (sprView.context != nil) {
                view.context = sprView.context;
                
                [self buildViewContextForChildren:view withContext:view.context];
                break;
            }
            
            sprView = sprView.superview;
        }
    }
    
    NSLog(@"buildViewContextFromSuper costs: %f ms", (CACurrentMediaTime()-start)*1000);
}

- (void)buildViewContextForChildren:(UIView*)view withContext:(CDDContext*)context
{
    for (UIView* subview in view.subviews) {
        subview.context = context;
        
        [self buildViewContextForChildren:subview withContext:context];
    }
}

@end
