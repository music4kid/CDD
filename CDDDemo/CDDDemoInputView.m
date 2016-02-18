//
//  CDDDemoInputView.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDDemoInputView.h"
#import <Masonry.h>
#import "CDDDemoBusinessObjectProtocol.h"
#import "CDDContext.h"

@interface CDDDemoInputView ()
@property (nonatomic, strong) UITextView*                 textView;
@property (nonatomic, strong) UIButton*                   btnSend;


@end

@implementation CDDDemoInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)initInputView
{
    self.btnSend = [UIButton new];
    [_btnSend addTarget:self action:@selector(btnSendClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [self addSubview:_btnSend];
    [_btnSend makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80);
        make.height.equalTo(40);
        make.right.equalTo(self).offset(-4);
        make.centerY.equalTo(self);
    }];
    
    self.textView = [UITextView new];
    _textView.font = [UIFont systemFontOfSize:16];
    [self addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(4);
        make.right.equalTo(_btnSend.left).offset(-4);
        make.height.equalTo(40);
        make.centerY.equalTo(self);
    }];
}

- (void)btnSendClick
{
    NSString* text = self.textView.text;
    
    if ([self.context.businessObject respondsToSelector:@selector(sendTextMessage:)]) {
        id<CDDDemoBusinessObjectProtocol> bo = (id<CDDDemoBusinessObjectProtocol>)self.context.businessObject;
        [bo sendTextMessage:text];
    }
    
    self.textView.text = nil;
}

@end
