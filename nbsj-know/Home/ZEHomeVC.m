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
#import "ZETypicalCaseVC.h"
#import "ZETypicalCaseDetailVC.h"

#import "ZEAskQuesViewController.h"

#import "ZEAnswerQuestionsVC.h"

#import "SvUDIDTools.h"
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
    [self cacheQuestionType];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyLogin:) name:kVerifyLogin object:nil];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self storeSystemInfo];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_homeView endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kVerifyLogin object:nil];
}

- (void)verifyLogin:(NSNotification *)noti
{
    // Refresh...
    [self checkUpdate];
    [self sendIsSigninToday];
    [self sendSigninViewMessage];
    [self cacheQuestionType];
    [self sendNewestQuestionsRequest:@""];
//    [self sendCaseQuestionsRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self sendIsSigninToday];
    [self sendSigninViewMessage];
    [self sendNewestQuestionsRequest:@""];
    
    [self checkUpdate];
    
//    [self sendCaseQuestionsRequest];
}

-(void)initView
{
    _homeView = [[ZEHomeView alloc] initWithFrame:self.view.frame];
    _homeView.delegate = self;
    [self.view addSubview:_homeView];
}

#pragma mark - 检测更新

-(void)checkUpdate
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_APP_VERSION,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"MOBILETYPE='2'",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"MOBILETYPE":@"",
                                @"VERSIONCODE":@"",
                                @"VERSIONNAME":@"",
                                @"FILEURL":@"",
                                @"FILEURL2":@"",
                                @"TYPE":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_APP_VERSION]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if ([[ZEUtil getServerData:data withTabelName:SNOW_APP_VERSION] count] > 0) {
                                     NSDictionary * dic = [ZEUtil getServerData:data withTabelName:SNOW_APP_VERSION][0];
                                     NSString* localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                                     if ([localVersion floatValue] < [[dic objectForKey:@"VERSIONNAME"] floatValue]) {
                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"经检测当前版本不是最新版本，点击确定跳转更新。" preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dic objectForKey:@"FILEURL"]]];
                                         }];
                                         [alertController addAction:okAction];
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}
-(void)storeSystemInfo
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_MOBILE_DEVICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"2000",
                                     @"METHOD":@"search",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"IMEI":[SvUDIDTools UDID],
                                @"SEQKEY":@"",
                                @"LOGINTIMES":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_MOBILE_DEVICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     [self insertSystemInfo];
                                 }else{
                                     [self updateSystemInfo:[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE][0]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}
-(void)insertSystemInfo
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_MOBILE_DEVICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":@"addSave",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSMutableDictionary * fieldsDic = [NSMutableDictionary dictionaryWithDictionary:[ZEUtil getSystemInfo]];
    [fieldsDic setObject:@"1" forKey:@"LOGINTIMES"];
    [fieldsDic setObject:@"true" forKey:@"ISENABLE"];
    [fieldsDic setObject:[ZEUtil getCurrentDate:@"YYYY-MM-dd"] forKey:@"FIRSTUSE"];
    [fieldsDic setObject:[ZEUtil getCurrentDate:@"YYYY-MM-dd"] forKey:@"LATESTUSE"];
    [fieldsDic setObject:[ZEUtil getCurrentDate:@"YYYY-MM-dd"] forKey:@"SYSCREATEDATE"];
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_MOBILE_DEVICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     
                                 }else{
                                     
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
    
}

-(void)updateSystemInfo:(NSDictionary *)dic
{
    long loginTimes = [[dic objectForKey:@"LOGINTIMES"] integerValue];
    loginTimes += 1;
    
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_MOBILE_DEVICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":@"updateSave",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSMutableDictionary * fieldsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"IMEI":[SvUDIDTools UDID],
                                                                                      @"SEQKEY":[dic objectForKey:@"SEQKEY"],
                                                                                      @"LOGINTIMES":[NSString stringWithFormat:@"%ld",loginTimes],
                                                                                      @"LATESTUSE":[ZEUtil getCurrentDate:@"YYYY-MM-dd"],
                                                                                      @"SYSUPDATEDATE":[ZEUtil getCurrentDate:@"YYYY-MM-dd"]}];
    
    [fieldsDic setObject:[ZESettingLocalData getUSERNAME] forKey:@"USERACCOUNT"];
    [fieldsDic setObject:[ZESettingLocalData getNAME] forKey:@"PSNNAME"];
    [fieldsDic setObject:[ZESettingLocalData getUSERCODE] forKey:@"PSNNUM"];
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_MOBILE_DEVICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     
                                 }else{
                                     
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


#pragma mark - Request

-(void)cacheQuestionType
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_TYPE]];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

/************* 今日是否签到 *************/
-(void)sendIsSigninToday
{
    NSString * whereSQL = [NSString stringWithFormat:@"SIGNINDATE = to_date('%@','yyyy-mm-dd') AND USERCODE = '%@'",[ZEUtil getCurrentDate:@"yyyy-MM-dd"],[ZESettingLocalData getUSERCODE]];
    NSDictionary * parametersDic = @{@"limit":@"32",
                                     @"MASTERTABLE":KLB_SIGNIN_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"USERCODE",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SIGNIN_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_SIGNIN_INFO];
                                 if ([dataArr count] > 0) {
                                     [_homeView hiddenSinginView];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)sendSigninViewMessage{
    
    NSString * whereSQL = [NSString stringWithFormat:@"PERIOD='%@'",[ZEUtil getCurrentDate:@"yyyy-MM"]];
    
    NSDictionary * parametersDic = @{@"limit":@"32",
                                     @"MASTERTABLE":V_KLB_HELPPERSONS_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"HELPPERSONS":@"",
                                @"SIGNINSUM":@""};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_HELPPERSONS_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_HELPPERSONS_INFO];
                                 if ([arr count] >0) {
                                     NSDictionary * dic = arr[0];
                                     [_homeView reloadSigninedViewDay:[NSString stringWithFormat:@"%@",[dic objectForKey:@"SIGNINSUM"]] numbers:[dic objectForKey:@"HELPPERSONS"]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];

}
/************* 查询最新问题 *************/
-(void)sendNewestQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 [_homeView reloadSectionwithData:arr];
                             } fail:^(NSError *errorCode) {
                                 [_homeView endRefreshing];
                             }];
    
}

/************* 查询典型案例 *************/
//-(void)sendCaseQuestionsRequest
//{
//    NSDictionary * parametersDic = @{@"limit":@"3",
//                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
//                                     @"MENUAPP":@"EMARK_APP",
//                                     @"ORDERSQL":@"CLICKCOUNT desc",
//                                     @"WHERESQL":@"",
//                                     @"start":@"0",
//                                     @"METHOD":METHOD_SEARCH,
//                                     @"MASTERFIELD":@"SEQKEY",
//                                     @"DETAILFIELD":@"",
//                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
//                                     @"DETAILTABLE":@"",};
//    
//    NSDictionary * fieldsDic =@{};
//    
//    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
//                                                                           withFields:@[fieldsDic]
//                                                                       withPARAMETERS:parametersDic
//                                                                       withActionFlag:nil];
//    [ZEUserServer getDataWithJsonDic:packageDic
//                       showAlertView:NO
//                             success:^(id data) {
//                                 if ([[ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO] count] > 0) {
//                                     [_homeView reloadSectionView:[ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO]];
//                                 }
//
//                             } fail:^(NSError *errorCode) {
//                                 
//                             }];
//    
//}


#pragma mark - ZEHomeViewDelegate
-(void)goTypicalDetail:(NSDictionary *)detailDic
{
    ZETypicalCaseDetailVC * caseDetailVC = [[ZETypicalCaseDetailVC alloc]init];
    caseDetailVC.classicalCaseDetailDic = detailDic;
    [self.navigationController pushViewController:caseDetailVC animated:YES];
}

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
    ZETypicalCaseVC * caseVC = [[ZETypicalCaseVC alloc]init];
    caseVC.enterType = ENTER_CASE_TYPE_DEFAULT;
    [self.navigationController pushViewController:caseVC animated:YES];
}
-(void)goMoreExpertAnswerView
{    
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_EXPERT;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goSearch:(NSString *)str
{
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_NEW;
    showQuestionsList.currentInputStr = str;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goTypeQuestionVC
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_SETTING;
    [self.navigationController pushViewController:askQues animated:YES];
}

-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel
{
    
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self showTips:@"您不能对自己的提问进行回答"];
        return;
    }
    
//    for (NSDictionary * dic in _datasArr) {
//        ZEAnswerInfoModel * answerInfo = [ZEAnswerInfoModel getDetailWithDic:dic];
//        if ([answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
//            [self acceptTheAnswerWithQuestionInfo:_questionInfoModel
//                                   withAnswerInfo:answerInfo];
//            return;
//        }
//    }
    
    if ([_questionInfoModel.ISSOLVE boolValue]) {
        [self showTips:@"该问题已有答案被采纳"];
        return;
    }
    
    ZEAnswerQuestionsVC * answerQuesVC = [[ZEAnswerQuestionsVC alloc]init];
    answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
    [self.navigationController pushViewController:answerQuesVC animated:YES];
}

- (void)showTips:(NSString *)labelText {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.labelText = labelText;
    [hud3 hide:YES afterDelay:1.0f];
}


-(void)loadNewData
{
    [self sendNewestQuestionsRequest:@""];
//    [self sendCaseQuestionsRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    [[SDImageCache sharedImageCache] clearDisk];

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
