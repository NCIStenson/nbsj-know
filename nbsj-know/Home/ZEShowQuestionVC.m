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
    NSInteger _currentPage;
    
}
@end

@implementation ZEShowQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_showQuestionListType == QUESTION_LIST_NEW) {
        self.title = @"最新问题";
    }else{
        self.title = _QUESTIONTYPENAME;
    }
    [self createWhereSQL:nil];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)createWhereSQL:(NSString *)searchStr
{
    NSString * searchCondition;
    if (_showQuestionListType == QUESTION_LIST_NEW) {
        searchCondition = [NSString stringWithFormat:@"ISLOSE = 0"];
    }else if (_showQuestionListType == QUESTION_LIST_TYPE){
        searchCondition = [NSString stringWithFormat:@"ISLOSE = 0 and QUESTIONTYPECODE = %@ and QUESTIONEXPLAIN like '%%%@'",_typeSEQKEY,searchStr];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONTYPECODE = %@",_typeSEQKEY];
        }
    }
    
    [self sendRequestWithCondition:searchCondition];
}
-(void)sendRequestWithCondition:(NSString *)conditionStr
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":conditionStr,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * 20],
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
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [_questionsView reloadFirstView:dataArr];
                                     }else{
                                         [_questionsView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count%20 == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [_questionsView loadNoMoreData];
                                         return ;
                                     }
                                     [_questionsView reloadFirstView:dataArr];
                                     [_questionsView headerEndRefreshing];
                                     [_questionsView loadNoMoreData];
                                 }
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

-(void)loadNewData
{
    _currentPage = 0;
    [self createWhereSQL:nil];
}

-(void)loadMoreData
{
    [self createWhereSQL:nil];
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
