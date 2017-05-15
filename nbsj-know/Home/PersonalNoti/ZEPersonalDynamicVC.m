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

@interface ZEPersonalDynamicVC ()<ZEPersonalNotiViewDelegate>
{
    ZEPersonalNotiView * personalNotiView;
}
@end

@implementation ZEPersonalDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getPersonalNotiList];
}

-(void)getPersonalNotiList
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
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
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO] ;
                                 [personalNotiView reloadFirstView:arr];
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
