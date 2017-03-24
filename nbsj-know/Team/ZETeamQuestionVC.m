//
//  ZETeamQuestionVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamQuestionVC.h"
#import "ZETeamQuestionView.h"

#import "ZETeamQuestionDetailVC.h"
#import "ZEAskTeamQuestionVC.h"

#import "ZEAnswerTeamQuestionVC.h"

#import "ZESearchTeamQuestionVC.h"

#import "ZEChatVC.h"

#import "ZECreateTeamVC.h"

@interface ZETeamQuestionVC ()<ZETeamQuestionViewDelegate,ZETeamQuestionViewDelegate>
{
    ZETeamQuestionView * _teamQuestionView;
    
    NSInteger _currentNewestPage;
    NSInteger _currentRecommandPage;
    NSInteger _currentBounsPage;

}
@end

@implementation ZETeamQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _teamCircleInfo.TEAMCIRCLENAME;
    [self addNavBarBtn];
    [self initView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTeamCircleInfo:) name:kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS object:nil];

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self sendHomeDataRequest];
}

#pragma mark - NOTI
-(void)changeTeamCircleInfo:(NSNotification *)noti
{
    if ([noti.object isKindOfClass:[ZETeamCircleModel class]]) {
        _teamCircleInfo = noti.object;
    }
}
-(void)addNavBarBtn
{
    for (int i = 0; i < 4; i ++) {
        UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.frame = CGRectMake(SCREEN_WIDTH - 145 + 33 * i, 27, 30.0, 30.0);
        _typeBtn.contentMode = UIViewContentModeScaleAspectFit;
        _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftBtn.superview addSubview:_typeBtn];
        _typeBtn.tag = i + 100;
        if (i == 0) {
            [_typeBtn setImage:[UIImage imageNamed:@"icon_team_msg" ] forState:UIControlStateNormal];
        }else if (i == 1){
            [_typeBtn setImage:[UIImage imageNamed:@"icon_team_search" ] forState:UIControlStateNormal];
        }else if (i == 2){
            [_typeBtn setImage:[UIImage imageNamed:@"icon_team_ask" ] forState:UIControlStateNormal];
        }else if (i == 3){
            [_typeBtn setImage:[UIImage imageNamed:@"icon_team_discuss" color:[UIColor whiteColor]] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 导航栏两个按钮点击

-(void)typeBtnClick:(UIButton *)btn
{
    if (btn.tag == 100) {
        [self goTeamDetailVC];
    }else if(btn.tag == 101){
        [self goSearchQuestionVC];
    }else if (btn.tag == 102){
        [self goAskTeamQuestionVC];
    }
}

-(void)goTeamDetailVC
{
    ZECreateTeamVC * createTeamVC = [[ZECreateTeamVC alloc]init];
    createTeamVC.enterType = ENTER_TEAM_DETAIL;
    createTeamVC.teamCircleInfo = _teamCircleInfo;
    createTeamVC.TEAMCODE = _teamCircleInfo.TEAMCODE;
    createTeamVC.TEAMSEQKEY = _teamCircleInfo.SEQKEY;
    [self.navigationController pushViewController:createTeamVC animated:YES];
    
}
-(void)goSearchQuestionVC
{
    ZESearchTeamQuestionVC * showQuestionsList = [[ZESearchTeamQuestionVC alloc]init];
    //    showQuestionsList.showQuestionListType = QUESTION_LIST_NEW;
    //    showQuestionsList.currentInputStr = str;
    showQuestionsList.TEAMCIRCLECODE = _teamCircleInfo.TEAMCODE;
    
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}


    
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_teamQuestionView endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ACCEPT_SUCCESS object:nil];
}


-(void)sendHomeDataRequest
{
    _currentNewestPage = 0;
    _currentRecommandPage = 0;
    _currentBounsPage = 0;
    
    [[ZEServerEngine sharedInstance] cancelAllTask];
    
    [self sendCommonQuestionsRequest:@""];
    [self sendOnlyMeAskQuestionsRequest:@""];
    [self sendMyQuestionsRequest:@""];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_QUESTION object:nil];
    [self isHaveNewMessage];
}

-(void)initView
{
    _teamQuestionView = [[ZETeamQuestionView alloc] initWithFrame:self.view.frame];
    _teamQuestionView.delegate = self;
    _teamQuestionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_teamQuestionView];
    [self.view sendSubviewToBack:_teamQuestionView];
    
    [_teamQuestionView scrollContentViewToIndex:_currentContent];
}
#pragma mark - 是否有新消息提醒
-(void)isHaveNewMessage
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"INFOCOUNT":@"",
                                @"QUESTIONCOUNT":@"",
                                @"ANSWERCOUNT":@"",
                                };
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
                                     NSString * INFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"INFOCOUNT"]];
                                     if ([INFOCOUNT integerValue] > 0) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= INFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];
    
}


#pragma mark - Request
/**
 你问我答列表
 
 @param searchStr 推荐问题搜索
 */
-(void)sendCommonQuestionsRequest:(NSString *)searchStr
{
    //    NSString * WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 0 and TEAMCIRCLECODE = @ and QUESTIONEXPLAIN like '%%%@%%'",,searchStr];
    //    if (![ZEUtil isStrNotEmpty:searchStr]) {
    NSString *  WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 0 and TEAMCIRCLECODE = '%@' and TARGETUSERCODE is NULL",_teamCircleInfo.TEAMCODE];
    //    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" ANSWERSUM,SYSCREATEDATE desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentRecommandPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO ];
                                 if (dataArr.count > 0) {
                                     if (_currentRecommandPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_RECOMMAND ];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_RECOMMAND];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentRecommandPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                     }
                                 }else{
                                     if (_currentRecommandPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_RECOMMAND];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:HOME_CONTENT_RECOMMAND];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:HOME_CONTENT_RECOMMAND];
                             }];
    
}

/************* 我来挑战问题列表 *************/
-(void)sendOnlyMeAskQuestionsRequest:(NSString *)searchStr
{
    NSString *  WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 0 and TEAMCIRCLECODE = '%@' and TARGETUSERCODE like '%%%@%%'",_teamCircleInfo.TEAMCODE,[ZESettingLocalData getUSERCODE]];
    //    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" SYSCREATEDATE,ANSWERSUM desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentNewestPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO ];
                                 if (dataArr.count > 0) {
                                     if (_currentNewestPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_NEWEST ];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_NEWEST];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentNewestPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                     }
                                 }else{
                                     if (_currentNewestPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_NEWEST];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:HOME_CONTENT_NEWEST];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:HOME_CONTENT_NEWEST];
                             }];

}


/**
 我的问题列表
 
 @param searchStr 高悬赏问题搜索
 */
-(void)sendMyQuestionsRequest:(NSString *)searchStr
{
    NSString *  WHERESQL = [NSString stringWithFormat:@" TEAMCIRCLECODE = '%@' and QUESTIONUSERCODE = '%@'",_teamCircleInfo.TEAMCODE,[ZESettingLocalData getUSERCODE]];

    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentBounsPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentBounsPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_BOUNS ];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_BOUNS];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentBounsPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                     }
                                 }else{
                                     if (_currentBounsPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_BOUNS];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:HOME_CONTENT_BOUNS];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:HOME_CONTENT_BOUNS];
                             }];
}


#pragma mark - ZEHomeViewDelegate

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;
{
    ZETeamQuestionDetailVC * detailVC = [[ZETeamQuestionDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel
{
    
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self showTips:@"您不能对自己的提问进行回答"];
        return;
    }
    
    if ([_questionInfoModel.ISSOLVE boolValue]) {
        [self showTips:@"该问题已有答案被采纳"];
        return;
    }
    
    if (_questionInfoModel.ISANSWER) {
        ZEChatVC * chatVC = [[ZEChatVC alloc]init];
        chatVC.questionInfo = _questionInfoModel;
        chatVC.enterChatVCType = 1;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    }else{
        ZEAnswerTeamQuestionVC * answerQuesVC = [[ZEAnswerTeamQuestionVC alloc]init];
        answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
        [self.navigationController pushViewController:answerQuesVC animated:YES];
    }
    
}

-(void)goAskTeamQuestionVC
{
    ZEAskTeamQuestionVC * askQues = [[ZEAskTeamQuestionVC alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_TABBAR;
    askQues.teamInfoModel = _teamCircleInfo;
    [self presentViewController:askQues animated:YES completion:nil];

}

- (void)showTips:(NSString *)labelText {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.labelText = labelText;
    [hud3 hide:YES afterDelay:1.0f];
}


-(void)loadNewData:(HOME_CONTENT)contentPage
{
    switch (contentPage) {
        case HOME_CONTENT_RECOMMAND:
            _currentRecommandPage = 0;
            [self sendCommonQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_NEWEST:
            _currentNewestPage = 0;
            [self sendOnlyMeAskQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_BOUNS:
            _currentBounsPage = 0;
            [self sendMyQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

-(void)loadMoreData:(HOME_CONTENT)contentPage
{
    switch (contentPage) {
        case HOME_CONTENT_RECOMMAND:
            [self sendCommonQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_NEWEST:
            [self sendOnlyMeAskQuestionsRequest:@""];
            
            break;
            
        case HOME_CONTENT_BOUNS:
            [self sendMyQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
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
