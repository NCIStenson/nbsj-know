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
#import "ZETeamQuestionVC.h"
@interface ZETeamVC ()<ZETeamViewDelegate>
{
    ZETeamView * teamView;
    ZETeamCircleModel * _teamCircleInfo;
    
    NSInteger _currentSelectTeam;
    
    NSArray * alreadyJoinTeam;
}
@end

@implementation ZETeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.title = @"团队";
    self.leftBtn.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAskState:) name:kNOTI_ASK_TEAM_QUESTION object:nil];;

    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self teamHomeRequest];
    
    if (_currentSelectTeam > 0 && _currentSelectTeam < alreadyJoinTeam.count) {
        _teamCircleInfo = [ZETeamCircleModel getDetailWithDic:alreadyJoinTeam[_currentSelectTeam]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ASK_TEAM_QUESTION object:_teamCircleInfo];

    }
}

-(void)changeAskState:(NSNotification *)noti
{
    
    if ([ZEUtil isNotNull:noti] && [noti.object isKindOfClass:[ZETeamCircleModel class]]) {
        _teamCircleInfo = noti.object;
        for (int i = 0 ; i < alreadyJoinTeam.count ; i ++) {
            ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:alreadyJoinTeam[i]];
            if ([teaminfo.SEQKEY isEqualToString:_teamCircleInfo.SEQKEY]) {
                _currentSelectTeam = i;
                break;
            }
        }
    }else{
        _currentSelectTeam = 0;
        _teamCircleInfo = NULL;
    }
}


-(void)teamHomeRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_USER_TEAMNAME,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamUserName",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_USER_TEAMNAME]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_TEAMCIRCLE_USER_TEAMNAME];
                                 if ([dataArr count] > 0) {
                                     alreadyJoinTeam = dataArr;
                                     [teamView reloadHeaderView:dataArr];
                                     _teamCircleInfo = [ZETeamCircleModel getDetailWithDic:dataArr[0]];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ASK_TEAM_QUESTION object:_teamCircleInfo];
                                 }else{
                                     [self showTips:@"您还没有加入任何团队，快去加一个吧"];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView
{
     teamView = [[ZETeamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    teamView.delegate = self;
    [self.view addSubview:teamView];
}

#pragma mark - ZETeamViewDelegate

-(void)goFindTeamVC
{
    ZEFindTeamVC * findTeamVC = [[ZEFindTeamVC alloc]init];
    
    [self.navigationController pushViewController:findTeamVC animated:YES];

}

-(void)goTeamQuestionVC
{
    ZETeamQuestionVC * questionVC = [[ZETeamQuestionVC alloc]init];
    questionVC.teamCircleInfo = _teamCircleInfo;
    [self.navigationController pushViewController:questionVC animated:YES];
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
