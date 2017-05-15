//
//  ZETeamNotiCenVC.m
//  nbsj-know
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamNotiCenVC.h"
#import "ZETeamNotiCenView.h"

#import "ZESendNotiVC.h"
#import "ZENotiDetailVC.h"
@interface ZETeamNotiCenVC ()<ZETeamNotiCenViewDelegate>
{
    ZETeamNotiCenView * teamNotiView;
}
@end

@implementation ZETeamNotiCenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"团队通知";
    [self initView];
    self.navigationController.navigationBarHidden = YES;
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_team_sendNoti" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self getNotiList];
}

-(void)getNotiList
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_MESSAGE_SEND,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"TEAMID = '%@'",_teamID],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_MESSAGE_SEND]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_MESSAGE_SEND] ;
                                 [teamNotiView reloadCellWithArr:arr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView{
    teamNotiView = [[ZETeamNotiCenView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    teamNotiView.delegate = self;
    [self.view addSubview:teamNotiView];
}

-(void)rightBtnClick
{
    ZESendNotiVC * sendNoti =  [[ZESendNotiVC alloc]init];
    sendNoti.teamID = _teamID;
    [self.navigationController pushViewController:sendNoti animated:YES];
}

#pragma mark - ZETeamNotiCenViewDelegate

-(void)didSelectNoti:(ZETeamNotiCenModel *)notiModel
{
    ZENotiDetailVC * notiDetailVC = [[ZENotiDetailVC alloc]init];
    notiDetailVC.notiCenModel = notiModel;
    notiDetailVC.teamID = _teamID;
    [self.navigationController pushViewController:notiDetailVC animated:YES];
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
