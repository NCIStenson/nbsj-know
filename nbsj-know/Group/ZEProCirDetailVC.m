//
//  ZEProCirDetailVC.m
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEProCirDetailVC.h"
#import "ZEProCirDeatilView.h"
@interface ZEProCirDetailVC ()

@end

@implementation ZEProCirDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"变电运维";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.rightBtn setTitle:@"加入他们" forState:UIControlStateNormal];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView{
    ZEProCirDeatilView * detailView = [[ZEProCirDeatilView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:detailView];
    [self.view sendSubviewToBack:detailView];
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
