//
//  ZEFindTeamVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEFindTeamVC.h"
#import "ZEFindTeamView.h"

#import "ZECreateTeamVC.h"
@interface ZEFindTeamVC ()
{
    ZEFindTeamView * findTeamView;
}
@end

@implementation ZEFindTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现团队";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.rightBtn setTitle:@"创建" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(goCreateTeamVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self initView];
}

-(void)initView{
    findTeamView = [[ZEFindTeamView alloc]initWithFrame:CGRectZero];
    findTeamView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:findTeamView];
    [self.view sendSubviewToBack:findTeamView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self findTeamRequest];
}

-(void)findTeamRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_TEAMCIRCLE_INFO];
                                 if ([dataArr count] > 0) {
                                     [findTeamView reloadFindTeamView:dataArr];
                                 }else{
                                     [self showTips:@"暂时没有发现任何团队~"];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - ZEFindTeamViewDelegate

-(void)goCreateTeamVC
{
    ZECreateTeamVC * createTeamVC = [[ZECreateTeamVC alloc]init];
    [self.navigationController pushViewController:createTeamVC animated:YES];
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
