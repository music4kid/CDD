//
//  MessageCellText.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "MessageCellText.h"
#import "ChatMessageText.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <Masonry.h>
#import "CDDContext.h"
#import "CDDDemoBusinessObjectProtocol.h"
#import "UserProfile.h"
#import <FBKVOController.h>

#define kMessageCellTextAvatarSize          48

@interface MessageCellText ()

@property (nonatomic, strong) UIImageView*                 imgCellBg;
@property (nonatomic, strong) UIButton*                    imgAvatar;
@property (nonatomic, strong) UILabel*                     lbFromName;
@property (nonatomic, strong) UILabel*                     lbContent;

@end

@implementation MessageCellText

+ (void)load
{
    [super registerRenderCell:[self class] messageType:ChatMsgType_Text];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgCellBg = [UIImageView new];
        _imgCellBg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgCellBg];
        
        self.imgAvatar = [UIButton new];
        _imgAvatar.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgAvatar];
        [_imgAvatar addTarget:self action:@selector(btnAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.lbFromName = [UILabel new];
        _lbFromName.backgroundColor = [UIColor clearColor];
        _lbFromName.font = [UIFont systemFontOfSize:11];
        _lbFromName.textColor = [UIColor grayColor];
        _lbFromName.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_lbFromName];
        
        self.lbContent = [UILabel new];
        _lbContent.backgroundColor = [UIColor clearColor];
        _lbContent.font = [UIFont systemFontOfSize:16];
        _lbContent.textColor = [UIColor blackColor];
        _lbContent.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_lbContent];
        
    }
    return self;
}

+ (float)calculteRenderCellHeight:(ChatMessageBase*)msg
{
    int height = 0;
    
    height = 48+10;

    return height;
}

- (void)doMessageRendering
{
    ChatMessageText* msg = (ChatMessageText*)self.chatMsg;
    
    //do layout
    [_imgAvatar makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kMessageCellTextAvatarSize);
        make.height.equalTo(kMessageCellTextAvatarSize);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView);
    }];
    
    [_lbFromName makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgAvatar.left).offset(-10);
        make.top.equalTo(_imgAvatar.top);
        make.height.equalTo(12);
        make.width.equalTo(100);
    }];
    
    [_lbContent makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgAvatar.left).offset(-10);
        make.top.equalTo(_lbFromName.top).offset(10);
        make.height.equalTo(17);
        make.width.equalTo(200);
    }];
    
    _lbContent.text = msg.content;
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:msg.fromUser.avatarUrl] forState:UIControlStateNormal];
    
    
    //observe value change
    __weak __typeof(self) weakSelf = self;
    [self.KVOController unobserveAll];
    
    [self.KVOController observe:msg.fromUser keyPath:@"userName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf detectUserNameChange:change];
        });
    }];
}

- (void)detectUserNameChange:(NSDictionary*)info
{
    NSString* name = info[NSKeyValueChangeNewKey];
    _lbFromName.text = name;
}

- (void)btnAvatarClicked:(id)sender
{
    if ([self.context.businessObject respondsToSelector:@selector(gotoUserDetailView:)]) {
        id<CDDDemoBusinessObjectProtocol> bo = (id<CDDDemoBusinessObjectProtocol>)self.context.businessObject;
        [bo gotoUserDetailView:self.chatMsg.fromUser];
    }
}

@end
