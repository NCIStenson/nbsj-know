    //
//  ZEQuestionsDetailVC.m
//  nbsj-know
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionsDetailVC.h"
#import "ZEQuestionsDetailView.h"
#import "ZEAnswerQuestionsVC.h"

@interface ZEQuestionsDetailVC ()<ZEQuestionsDetailViewDelegate>
{
    ZEQuestionsDetailView * _quesDetailView;
    UIAlertController * alertC;
}

@property (nonnull,nonatomic,strong) NSArray * datasArr;

@end

@implementation ZEQuestionsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = [NSString stringWithFormat:@"%@的提问",_questionInfoModel.NICKNAME];
    [self.rightBtn setTitle:@"回答" forState:UIControlStateNormal];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self sendSearchAnswerRequest];
}

-(void)sendSearchAnswerRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"ISPASS desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfoModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     @"DETAILTABLE":@"",};

    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
                                 [_quesDetailView reloadData:_datasArr];
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
}

-(void)initView
{
    _quesDetailView = [[ZEQuestionsDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                         withQuestionInfo:_questionInfoModel
                                                                         withQuestionType:_questionTypeModel];
    _quesDetailView.delegate = self;
    [self.view addSubview:_quesDetailView];
    [self.view sendSubviewToBack:_quesDetailView];
}

-(void)rightBtnClick
{
//    for (NSDictionary * dic in _datasArr) {
//        ZEAnswerInfoModel * answerInfo = [ZEAnswerInfoModel getDetailWithDic:dic];
//        if ([answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
//            [self showTips:@"您已回答过该问题"];
//            self.rightBtn.enabled = NO;
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

#pragma mark - ZEQuestionsDetailViewDelegate

-(void)acceptTheAnswerWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                        withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    if (!alertC) {
        alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定采纳该建议为答案？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateKLB_ANSWER_INFOWithQuestionInfo:infoModel withAnswerInfo:answerModel];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:confirmAction];
        [alertC addAction:cancelAction];
    }
    
    [self presentViewController:alertC animated:YES completion:nil];
}



-(void)updateKLB_ANSWER_INFOWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                              withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"DETAILTABLE":KLB_QUESTION_INFO,
                                     @"MASTERFIELD":@"QUESTIONID",
                                     @"DETAILFIELD":@"SEQKEY",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerTake",
                                     };

    NSDictionary * fieldsDic =@{@"SEQKEY":answerModel.SEQKEY,
                                @"QUESTIONID":answerModel.QUESTIONID,
                                @"ISPASS":@"1",
                                };
    
    NSDictionary * fieldsDic2 =@{@"ISSOLVE":@"1"};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO,KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic,fieldsDic2]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 
                                 [_quesDetailView disableSelect];
                                 [self sendSearchAnswerRequest];

                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
}

#pragma mark - 点赞

-(void)giveLikes:(NSString *)answerSeqkey
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_GOOD,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONID":_questionInfoModel.SEQKEY,
                                @"ANSWERID":answerSeqkey,
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_GOOD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 
                                 [self sendSearchAnswerRequest];
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
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
