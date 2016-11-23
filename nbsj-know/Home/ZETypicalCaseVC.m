//
//  ZETypicalCaseVC.m
//  nbsj-know
//
//  Created by Stenson on 16/10/31.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseVC.h"
#import "ZETypicalCaseView.h"

#import "ZETypicalCaseDetailVC.h"

@interface ZETypicalCaseVC ()<ZETypicalCaseViewDelegate>
{
    ZETypicalCaseView * caseView;
    
    NSInteger _currentPage;
    
    NSString * _currentWHERESQL;
    NSString * sortOrderSQL;// 最热 最新排序
}


@end

@implementation ZETypicalCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sortOrderSQL = @"SYSCREATEDATE desc";
    _currentPage = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentWHERESQL = @"";
    if (_enterType == ENTER_CASE_TYPE_DEFAULT) {
        self.title = @"典型案例";
        [self sendRequestWithCurrentPage];
    }else{
        self.title = @"我的收藏";
        [self myCollectRequest];
    }
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreSuccess) name:kNOTI_SCORE_SUCCESS object:nil];
}

-(void)scoreSuccess
{
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)sendRequestWithCurrentPage
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":sortOrderSQL,
                                     @"WHERESQL":_currentWHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [caseView reloadFirstView:dataArr];
                                     }else{
                                         [caseView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [caseView loadNoMoreData];
                                         return ;
                                     }
                                     [caseView reloadFirstView:dataArr];
                                     [caseView headerEndRefreshing];
                                     [caseView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
}
-(void)myCollectRequest
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE DESC",
                                     @"WHERESQL":[NSString stringWithFormat:@"COLLECTUSERCODE = %@",[ZESettingLocalData getUSERCODE]],
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.CollectCase",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_COLLECT];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [caseView reloadFirstView:dataArr];
                                     }else{
                                         [caseView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [caseView loadNoMoreData];
                                         return ;
                                     }
                                     [caseView reloadFirstView:dataArr];
                                     [caseView headerEndRefreshing];
                                     [caseView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
}


-(void)initView{
    caseView = [[ZETypicalCaseView alloc]initWithFrame:self.view.frame withEnterType:_enterType];
    caseView.delegate = self;
    [self.view addSubview:caseView];
    [self.view sendSubviewToBack:caseView];
}

#pragma mark - ZETypicalCaseViewDelegate

-(void)loadNewData
{
    if (_enterType == ENTER_CASE_TYPE_DEFAULT) {
        _currentPage = 0;
        [self sendRequestWithCurrentPage];
    }else if (_enterType == ENTER_CASE_TYPE_SETTING){
        _currentPage = 0;
        [self myCollectRequest];
    }
}
-(void)loadMoreData
{
    if (_enterType == ENTER_CASE_TYPE_DEFAULT) {
        [self sendRequestWithCurrentPage];
    }else if (_enterType == ENTER_CASE_TYPE_SETTING){
        [self myCollectRequest];
    }
}

-(void)goTypicalCaseDetailVC:(id)obj
{
    ZETypicalCaseDetailVC * detailVC = [[ZETypicalCaseDetailVC alloc]init];
    detailVC.classicalCaseDetailDic = obj;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)screenFileType:(NSString *)fileType
{    
    if ([fileType isEqualToString:@"视频"]) {
        _currentWHERESQL = [NSString stringWithFormat:@"COURSEFILETYPE like '%%.mp4%%'"];
    }else if ([fileType isEqualToString:@"图片"]){
        _currentWHERESQL = [NSString stringWithFormat:@"COURSEFILETYPE like '%%.jpg%%' or COURSEFILETYPE like '%%.png%%' "];
    }else if([fileType isEqualToString:@"文档"]){
        _currentWHERESQL = [NSString stringWithFormat:@"COURSEFILETYPE like '%%.doc%%' or COURSEFILETYPE like '%%.xls%%' or COURSEFILETYPE like '%%.ppt%%' or COURSEFILETYPE like '%%.pdf%%'"];
    }else if([fileType isEqualToString:@"其他"] || [fileType isEqualToString:@"全部"]){
        _currentWHERESQL = @"";
    }
    
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
}

-(void)sortConditon:(NSString *)condition
{
    sortOrderSQL = condition;
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
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
