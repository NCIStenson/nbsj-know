    //
//  ZETeamVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamVC.h"
#import "ZETeamView.h"

#import "ZEFindTeamVC.h"

@interface ZETeamVC ()<ZETeamViewDelegate>

@end

@implementation ZETeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.title = @"团队";
    self.leftBtn.hidden = YES;
    
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:nil];
}

-(void)initView
{
    ZETeamView * teamView = [[ZETeamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    teamView.delegate = self;
    [self.view addSubview:teamView];
}

#pragma mark - ZETeamViewDelegate

-(void)goFindTeamVC
{
    ZEFindTeamVC * findTeamVC = [[ZEFindTeamVC alloc]init];
    
    [self.navigationController pushViewController:findTeamVC animated:YES];

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
