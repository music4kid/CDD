//
//  ViewController.m
//  CDDDemo
//
//  Created by gao feng on 16/2/3.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "CDDDemoController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int btnWidth = 100;
    int btnHeight = 100;
    
    UIButton* btn = UIButton.new;
    [btn setTitle:@"Demo" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn addTarget:self action:@selector(gotoDemoController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(btnWidth);
        make.height.equalTo(btnHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoDemoController
{
    CDDDemoController* ctrl = [CDDDemoController new];
    [self.navigationController pushViewController:ctrl animated:true];
}

@end
