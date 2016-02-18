//
//  CDDUserDetailView.m
//  CDDDemo
//
//  Created by gao feng on 16/2/16.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDUserDetailView.h"
#import <Masonry.h>
#import "CDDUserDetailBusinessObjectProtocol.h"
#import "CDDUserDetailDataHandlerProtocol.h"
#import <FBKVOController.h>
#import "UserProfile.h"
#import "CDDContext.h"

@interface CDDUserDetailView ()
@property (nonatomic, strong) UILabel*                 lbName;
@property (nonatomic, strong) UIButton*                btnChange;

@end

@implementation CDDUserDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    return self;
}

- (void)initDetailView
{
    self.lbName = [UILabel new];
    _lbName.backgroundColor = [UIColor clearColor];
    _lbName.font = [UIFont systemFontOfSize:16];
    _lbName.textColor = [UIColor blackColor];
    _lbName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lbName];
    
    [_lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(150);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(18);
    }];
    
    self.btnChange = [UIButton new];
    _btnChange.backgroundColor = [UIColor darkGrayColor];
    [_btnChange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnChange setTitle:@"Change" forState:UIControlStateNormal];
    [self addSubview:_btnChange];
    [_btnChange addTarget:self action:@selector(btnChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnChange makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbName.bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.equalTo(120);
        make.height.equalTo(60);
    }];
    
    
    id<CDDUserDetailDataHandlerProtocol> handler = (id<CDDUserDetailDataHandlerProtocol>)self.context.dataHandler;
    
    //observe value change
    __weak __typeof(self) weakSelf = self;
    [self.KVOController unobserveAll];
    
    [self.KVOController observe:[handler getUserProfile] keyPath:@"userName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf detectUserNameChange:change];
        });
    }];
}

- (void)detectUserNameChange:(NSDictionary*)info
{
    NSString* name = info[NSKeyValueChangeNewKey];
    _lbName.text = name;
}

- (void)btnChangeClick:(id)sender
{
    id<CDDUserDetailBusinessObjectProtocol> bo = (id<CDDUserDetailBusinessObjectProtocol>)self.context.businessObject;
    NSString* randomName = [NSString stringWithFormat:@"MrPeak-%d", arc4random()%1000];
    if ([bo respondsToSelector:@selector(changeUserName:)]) {
        [bo changeUserName:randomName];
    }
}

@end
