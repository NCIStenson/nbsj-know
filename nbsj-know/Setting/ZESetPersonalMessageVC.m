//
//  ZESetPersonalMessageVC.m
//  nbsj-know
//
//  Created by Stenson on 16/8/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESetPersonalMessageVC.h"
#import "ZESetPersonalMessageView.h"
#import "ZEUserServer.h"
#import "ZELoginViewController.h"
@interface ZESetPersonalMessageVC ()<ZESetPersonalMessageViewDelegate>

@end

@implementation ZESetPersonalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self initView];
}

-(void)initView
{
    ZESetPersonalMessageView * personalMsgView = [[ZESetPersonalMessageView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    personalMsgView.delegate = self;
    [self.view addSubview:personalMsgView];
}

/**
 *  @author Stenson, 16-08-12 13:08:52
 *
 *  退出登录
 */
-(void)logout
{
    [self progressBegin:@"正在退出登录"];
    [ZEUserServer logoutSuccess:^(id data) {
        NSLog(@">>  %@",data);
        if ([[data objectForKey:@"RETMSG"] isEqualToString:@"null"]) {
            [self logoutSuccess];
        }
        
    } fail:^(NSError *error) {
        NSLog(@">>  %@",error);
    }];
}

-(void)logoutSuccess
{
    [ZESettingLocalData deleteCookie];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    keyWindow.rootViewController = loginVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
