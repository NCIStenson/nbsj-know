//
//  ZEUserCenterVC.m
//  NewCentury
//
//  Created by Stenson on 16/4/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEUserCenterVC.h"
#import "ZEUserCenterView.h"

#import "ZESetPersonalMessageVC.h"
@interface ZEUserCenterVC ()<ZEUserCenterViewDelegate>

@end

@implementation ZEUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)initView
{
    ZEUserCenterView * usView = [[ZEUserCenterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    usView.delegate = self;
    [self.view addSubview:usView];
}

#pragma mark - ZEUserCenterViewDelegate

-(void)goSettingVC
{
    ZESetPersonalMessageVC * personalMsgVC = [[ZESetPersonalMessageVC alloc]init];
    
    [self.navigationController pushViewController:personalMsgVC animated:YES];
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
