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
}

@property (nonnull,nonatomic,strong) NSArray * datasArr;

@end

@implementation ZEQuestionsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = [NSString stringWithFormat:@"%@的提问",_questionInfoModel.QUESTIONUSERNAME];
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
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"ISPASS desc",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"QUERTIONID",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};

    NSDictionary * fieldsDic =@{@"QUERTIONID":_questionInfoModel.SEQKEY,
                                @"SEQKEY":@"",
                                @"ANSWEREXPLAIN":@"",
                                @"ANSWERIMAGE":@"",
                                @"ANSWERUSERCODE":@"",
                                @"ANSWERUSERNAME":@"",
                                @"ANSWERLEVEL":@"",
                                @"ISPASS":@"",
                                @"ISENABLED":@"0",
                                @"GOODNUMS":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 _datasArr = [ZEUtil getServerData:data withTabelName:KLB_ANSWER_INFO];
                                 [_quesDetailView reloadData:[ZEUtil getServerData:data withTabelName:KLB_ANSWER_INFO]];
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
    for (NSDictionary * dic in _datasArr) {
        ZEAnswerInfoModel * answerInfo = [ZEAnswerInfoModel getDetailWithDic:dic];
        if ([answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            [self showTips:@"您已回答过该问题"];
            self.rightBtn.enabled = NO;
            return;
        }
    }
    
    ZEAnswerQuestionsVC * answerQuesVC = [[ZEAnswerQuestionsVC alloc]init];
    answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
    [self.navigationController pushViewController:answerQuesVC animated:YES];
}

#pragma mark - ZEQuestionsDetailViewDelegate

-(void)acceptTheAnswerWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                        withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定采纳该建议为答案？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateKLB_ANSWER_INFOWithQuestionInfo:infoModel withAnswerInfo:answerModel];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:confirmAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)updateKLB_ANSWER_INFOWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                              withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"updateSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    NSDictionary * fieldsDic =@{@"SEQKEY":answerModel.SEQKEY,
                                @"ISPASS":@"1",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 NSLog(@">>  %@",data);
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];

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
