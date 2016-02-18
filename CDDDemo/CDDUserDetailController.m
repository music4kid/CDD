//
//  CDDUserDetailController.m
//  CDDDemo
//
//  Created by gao feng on 16/2/16.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDUserDetailController.h"
#import "CDDUserDetailView.h"
#import "CDDUserDetailDataHandler.h"
#import "CDDUserDetailBusinessObject.h"

@interface CDDUserDetailController ()
@property (nonatomic, strong) CDDUserDetailView*                 customView;
@end

@implementation CDDUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CDDUserDetail";
    
    [self initContext];
    
    //create custom view
    self.customView = [[CDDUserDetailView alloc] initWithFrame:self.view.bounds];
    self.view = _customView;
    _customView.context = self.context;
    [_customView initDetailView];
}

- (void)initContext
{
    CDDUserDetailDataHandler* handler = [CDDUserDetailDataHandler new];
    [handler setUserProfile:self.user];
    CDDUserDetailBusinessObject* bo = [CDDUserDetailBusinessObject new];
    bo.baseController = self;
    
    self.context = [[CDDContext alloc] initWithDataHandler:handler withBusinessObject:bo];
}

- (void)dealloc
{
    NSLog(@"being released");
}

@end
