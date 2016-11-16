//
//  ZEQuestionsVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#import "ZEQuestionsVC.h"

#import "ZEQuestionsView.h"

#import "ZEShowQuestionVC.h"
#import "ZEAskQuesViewController.h"
#import "ZEQuestionsDetailVC.h"
#import "ZEQuestionTypeCache.h"
#import "JCAlertView.h"
#import "ZEShowQuestionTypeView.h"

#import "ZEQuestionTypeModel.h"

#import "ZEShowQuestionVC.h"

#import "ZEScoreView.h"

@interface ZEQuestionsVC ()<ZEQuestionsViewDelegate,ZEShowQuestionTypeViewDelegate>
{
    ZEQuestionsView * _questionView;
    JCAlertView * _alertView;
}
@end

@implementation ZEQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"问答";
//    [self.leftBtn setTitle:@"分类" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateHighlighted];
    [self.rightBtn setTitle:@"提问" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self initView];
//    [self sendRequestWithStr:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self sendRequestWithStr:nil];
}

-(void)sendRequestWithStr:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONEXPLAIN like '%%'"];
    }

    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 [_questionView reloadContentViewWithArr:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO]];
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
}



-(void)initView
{
    _questionView = [[ZEQuestionsView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 49.0f)];
    _questionView.delegate =self;
    [self.view addSubview:_questionView];
}

-(void)leftBtnClick
{
    [self showQuestionTypeViewWithData:[[ZEQuestionTypeCache instance] getQuestionTypeCaches]];
}
-(void)showQuestionTypeViewWithData:(NSArray *)optionArr
{
    ZEShowQuestionTypeView * showTypeView = [[ZEShowQuestionTypeView alloc]initWithOptionArr:optionArr];
    showTypeView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:showTypeView dismissWhenTouchedBackground:YES];
    [_alertView show];
}

#pragma mark - ZEShowQuesTypeVIewDelegate

-(void)didSeclect:(ZEShowQuestionTypeView *)showTypeView withData:(NSDictionary *)dic
{
    ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
    
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_TYPE;
    showQuestionsList.QUESTIONTYPENAME = typeM.QUESTIONTYPENAME;
    showQuestionsList.typeSEQKEY = typeM.SEQKEY;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
    
    [_alertView dismissWithCompletion:nil];
}


-(void)rightBtnClick
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    [self.navigationController pushViewController:askQues animated:YES];
}

#pragma mark - ZEQuestionsViewDelegate

-(void)goMoreRecommend
{
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goSearchWithStr:(NSString *)inputStr
{
//    [self sendRequestWithStr:inputStr];
    
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_NEW;
    showQuestionsList.currentInputStr = inputStr;
    [self.navigationController pushViewController:showQuestionsList animated:YES];

    
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
