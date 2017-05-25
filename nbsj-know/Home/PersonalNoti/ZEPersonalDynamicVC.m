//
//  ZEPersonalDynamicVC.m
//  nbsj-know
//
//  Created by Stenson on 17/5/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPersonalDynamicVC.h"
#import "ZEPersonalNotiView.h"

#import "ZENotiDetailVC.h"
#import "ZEQuestionsDetailVC.h"

@interface ZEPersonalDynamicVC ()<ZEPersonalNotiViewDelegate>
{
    ZEPersonalNotiView * personalNotiView;
    long _currentPageCount;
    
    ZETeamNotiCenModel * previousSelectNotiModel;
}
@end

@implementation ZEPersonalDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyLogin:) name:kVerifyLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceUnreadCount) name:kNOTI_READDYNAMIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:kNOTI_DELETE_ALL_DYNAMIC object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVerifyLogin object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_READDYNAMIC object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_DELETE_ALL_DYNAMIC object:nil];;
}

-(void)reduceUnreadCount
{
    [self getPersonalNotiList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self loadNewData];
}

-(void)verifyLogin:(NSNotification *)noti
{
    [self getPersonalNotiList];
}

-(void)getPersonalNotiList
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",_currentPageCount * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO] ;
                                 if (dataArr.count > 0) {
                                     if (_currentPageCount == 0) {
                                         [personalNotiView reloadFirstView:dataArr];
                                     }else{
                                         [personalNotiView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPageCount += 1;
                                     }
                                 }else{
                                     if (_currentPageCount > 0) {
                                         [personalNotiView loadNoMoreData];
                                         return ;
                                     }
                                     [personalNotiView reloadFirstView:dataArr];
                                     [personalNotiView headerEndRefreshing];
                                     [personalNotiView loadNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - 删除个人动态

-(void)deletePersonalDataWithSeqkey:(NSString *)seqkey
{
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":seqkey};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDelete"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO] ;
                                 if (dataArr.count > 0) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_READDYNAMIC object:nil];

                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                     hud3.mode = MBProgressHUDModeText;
                                     hud3.labelText = @"删除成功";
                                     [hud3 hide:YES afterDelay:1.0f];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView{
    personalNotiView = [[ZEPersonalNotiView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 35.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    personalNotiView.delegate = self;
    [self.view addSubview:personalNotiView];
}

#pragma mark - ZEPersonalNotiViewDelegate

-(void)didSelectTeamMessage:(ZETeamNotiCenModel *)notiModel
{
    NSLog(@">>>>  %@",notiModel.QUESTIONEXPLAIN);
    
    ZENotiDetailVC * notiDetailVC = [[ZENotiDetailVC alloc]init];
    notiDetailVC.notiCenModel = notiModel;
    [self.navigationController pushViewController:notiDetailVC animated:YES];
    if ([notiModel.DYNAMICTYPE integerValue] == 1) {
        notiDetailVC.enterTeamNotiType = ENTER_TEAMNOTI_TYPE_RECEIPT_Y;
    }else{
        notiDetailVC.enterTeamNotiType = ENTER_TEAMNOTI_TYPE_RECEIPT_N;
    }
}

-(void)didSelectQuestionMessage:(ZETeamNotiCenModel *)notiModel
{
    NSLog(@">>>>  %@",notiModel.QUESTIONEXPLAIN);
    previousSelectNotiModel = notiModel;
    ZEQuestionsDetailVC * questionDetailVC = [[ZEQuestionsDetailVC alloc]init];
    questionDetailVC.enterDetailIsFromNoti = QUESTIONDETAIL_TYPE_NOTI;
    questionDetailVC.notiCenM = notiModel;
    [self.navigationController pushViewController:questionDetailVC animated:YES];
}

-(void)didSelectDeleteBtn:(ZETeamNotiCenModel *)notiModel
{
    [self deletePersonalDataWithSeqkey:notiModel.SEQKEY];
}


-(void)loadNewData
{
    _currentPageCount = 0;
    [self getPersonalNotiList];
}

-(void)loadMoreData
{
    [self getPersonalNotiList];
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
