//
//  CDDDemoController.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDDemoController.h"
#import "NSObject+CDD.h"

#import "CDDDemoDataHandler.h"
#import "CDDDemoBusinessObject.h"

#import "CDDDemoView.h"
#import "ChatMessageText.h"
#import "UserProfile.h"

@interface CDDDemoController ()
@property (nonatomic, strong) CDDDemoView*                 customView;
@end

@implementation CDDDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CDDDemo";
    
    [self initContext];
    
    //create custom view
    self.customView = [[CDDDemoView alloc] initWithFrame:self.view.bounds];
    self.view = _customView;
    _customView.context = self.context;
    [_customView buildDemoView];
}

- (void)initContext
{
    CDDDemoDataHandler* handler = [CDDDemoDataHandler new];
    CDDDemoBusinessObject* bo = [CDDDemoBusinessObject new];
    bo.baseController = self;
    
    self.context = [[CDDContext alloc] initWithDataHandler:handler withBusinessObject:bo];
    
    UserProfile* user = [UserProfile new];
    user.userId = @1;
    user.userName = @"MrPeak";
    user.avatarUrl = @"http://tp2.sinaimg.cn/1993445913/180/40110322733/1";
    
    //mock data source, view models should be constructed from raw models
    for (int i = 0; i < 100; i ++) {
        ChatMessageText* msg = [ChatMessageText new];
    
        msg.content = [NSString stringWithFormat:@"www.mrpeak.cn:%d", i];
        msg.isLeft = i%2==0?true:false;
        msg.msgType = @(ChatMsgType_Text);
        msg.renderHeight = 58;
        msg.fromUser = user;
        
        [handler insertNewMessage:msg];
    }
}

- (void)dealloc
{
    NSLog(@"being released");
}

@end
