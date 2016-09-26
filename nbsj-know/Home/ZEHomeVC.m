//
//  ZEHomeVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#import "ZEHomeVC.h"
#import "ZEHomeView.h"
#import "ZESinginVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEQuestionsDetailVC.h"

@interface ZEHomeVC ()<ZEHomeViewDelegate>
{
    ZEHomeView * _homeView;
}
@end

@implementation ZEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self sendIsSignin];
    [self sendNewestQuestionsRequest:@""];
    [self sendExpertQuestionsRequest:@""];
    [self sendCaseQuestionsRequest:@""];
}

-(void)initView
{
    _homeView = [[ZEHomeView alloc] initWithFrame:self.view.frame];
    _homeView.delegate = self;
    [self.view addSubview:_homeView];
}

#pragma mark - Request

-(void)sendIsSignin{
    
    NSDictionary * parametersDic = @{@"limit":@"32",
                                     @"MASTERTABLE":KLB_SIGNIN_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"signindate = to_date('%@','yyyy-MM-dd')",[ZEUtil getCurrentDate:@"yyyy-MM-dd"]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"USERCODE",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"USERNAME":@"",
                                @"SIGNINDATE":@"",
                                @"PERIOD":@"",
                                @"STATUS":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SIGNIN_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 if ([[ZEUtil getServerData:data withTabelName:KLB_SIGNIN_INFO] count] >0) {
                                     [_homeView reloadSigninedView];
                                 }

//                                 [calendarPicker reloadDateData:[ZEUtil getServerData:data withTabelName:KLB_SIGNIN_INFO]];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
}

-(void)sendNewestQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 1 and ISEXPERTANSWER = 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 1 and ISEXPERTANSWER = 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_QUESTION_INFO];
                                 [_homeView reloadSection:0 withData:arr];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
    
}

-(void)sendExpertQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and ISEXPERTANSWER = 1 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and ISEXPERTANSWER = 1  and QUESTIONEXPLAIN like '%%'"];
    }
    NSLog(@">>  %@",WHERESQL);
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_QUESTION_INFO];
                                 [_homeView reloadSection:1 withData:arr];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
    
}

-(void)sendCaseQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 2 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 2 and QUESTIONEXPLAIN like '%%'"];
    }
    NSLog(@">>  %@",WHERESQL);
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_QUESTION_INFO];
                                 [_homeView reloadSection:2 withData:arr];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
    
}


#pragma mark - ZEHomeViewDelegate

-(void)goSinginView
{
    ZESinginVC * singVC = [[ZESinginVC alloc]init];
    [self.navigationController pushViewController:singVC animated:YES];
}

-(void)goMoreQuestionsView
{
    [self.tabBarController setSelectedIndex:1];
}
-(void)goMoreCaseAnswerView
{
    
}
-(void)goMoreExpertAnswerView
{
    
}
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
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
