//
//  ZESetPersonalMessageVC.m
//  nbsj-know
//
//  Created by Stenson on 16/8/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESetPersonalMessageVC.h"
#import "ZESetPersonalMessageView.h"
#import "ZEUserServer.h"
#import "ZELoginViewController.h"
#import "ZEChangePersonalMsgVC.h"

#import "ZEQuestionTypeCache.h"

@interface ZESetPersonalMessageVC ()<ZESetPersonalMessageViewDelegate>
{
    ZESetPersonalMessageView * personalMsgView;
}
@end

@implementation ZESetPersonalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self getCurrentUserLevel];
}


-(void)getCurrentUserLevel
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"stary":@"0",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",[ZESettingLocalData getUSERCODE]],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO];
                                 if(arr.count > 0){
                                     [personalMsgView reloadDataWithDic:arr[0]];
                                 }
                             }
                                fail:^(NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                }];
}


-(void)initView
{
    personalMsgView = [[ZESetPersonalMessageView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    personalMsgView.delegate = self;
    [self.view addSubview:personalMsgView];
}

#pragma mark - ZESetPersonalMessageViewDelegate

-(void)changePersonalMsg:(CHANGE_PERSONALMSG_TYPE)type
{
    ZEChangePersonalMsgVC * personalMsgVC = [[ZEChangePersonalMsgVC alloc]init];
    personalMsgVC.changeType = type;
    [self.navigationController pushViewController:personalMsgVC animated:YES];
}

/**
 *  @author Stenson, 16-08-12 13:08:52
 *
 *  退出登录
 */
-(void)logout
{
    [self progressBegin:@"正在退出登录"];
    [ZEUserServer logoutSuccess:^(id data) {
        [self progressEnd:nil];
        NSLog(@" 正在退出登录 >>  %@",data);
//        if ([ZEUtil isSuccess:[data objectForKey:@"RETMSG"]]) {
        [self logoutSuccess];
//        }
    } fail:^(NSError *error) {
        [self progressEnd:nil];
    }];
}

-(void)logoutSuccess
{
    [ZESettingLocalData clearLocalData];
    [[ZEQuestionTypeCache instance] clear];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    keyWindow.rootViewController = loginVC;
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
