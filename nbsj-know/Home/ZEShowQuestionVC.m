//
//  ZEQuestionVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/28.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEShowQuestionVC.h"
#import "ZEShowQuestionView.h"

#import "ZEQuestionsDetailVC.h"
@interface ZEShowQuestionVC ()<ZEShowQuestionViewDelegate>
{
    ZEShowQuestionView * _questionsView;
}
@end

@implementation ZEShowQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_showQuestionListType == QUESTION_LIST_RECOMMEND) {
        self.title = @"推荐";
    }else{
        self.title = _QUESTIONTYPENAME;
        [self sendRequest];
    }
    
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)sendRequest
{
    //    @"WHERESQL":@"ISLOSE=1 and QUESTIONEXPLAIN like '%z%'",
    
    NSString * searchCondition = [NSString stringWithFormat:@"ISLOSE=1 and QUESTIONTYPE=%@",_typeSEQKEY];
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":searchCondition,
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
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                             success:^(id data) {
                                 NSLog(@">>   %@",data);
                                 [self progressEnd:nil];
                                 [_questionsView reloadContentViewWithArr:[ZEUtil getServerData:data withTabelName:KLB_QUESTION_INFO]];
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
}

#pragma mark -
-(void)initView
{
    _questionsView = [[ZEShowQuestionView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _questionsView.delegate = self;
    [self.view addSubview:_questionsView];
}

#pragma mark - ZEShowQuestionViewDelegate

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel
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
