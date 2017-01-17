//
//  ZELoginViewController.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZELoginViewController.h"
#import "MBProgressHUD.h"
#import "ZELoginView.h"

#import "ZEUserServer.h"

#import "ZEHomeVC.h"
#import "ZEQuestionsVC.h"
#import "ZEGroupVC.h"
#import "ZEUserCenterVC.h"

@interface ZELoginViewController ()<ZELoginViewDelegate>

@end

@implementation ZELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"用户登录";
    [self disableLeftBtn];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

-(void)initView
{
    ZELoginView * loginView = [[ZELoginView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}
-(void)dealloc
{
    
}
#pragma mark - ZELoginViewDelegate

-(void)goLogin:(NSString *)username password:(NSString *)pwd
{
//    if ([username isEqualToString:@""]) {
//        if (IS_IOS8) {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户名不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//        }else{
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"用户名不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        return;
//    }else if (![ZEUtil isStrNotEmpty:pwd]){
//        if (IS_IOS8) {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码不能为空"
//                                                                                     message:nil
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
//                                                               style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//        }else{
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"密码不能为空"
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"好的"
//                                                      otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        return;
//    }
//    __block ZELoginViewController * safeSelf = self;
    

    [ZEUserServer loginWithNum:username
                  withPassword:pwd
                       success:^(id data) {
                           [self progressEnd:nil];
                           if ([[data objectForKey:@"RETMSG"] isEqualToString:@"null"]) {
                                NSLog(@"登陆成功  %@",[data objectForKey:@"RETMSG"]);
                               [ZESettingLocalData setUSERNAME:username];
                               [ZESettingLocalData setUSERPASSWORD:pwd];
                               [self commonRequest:username];
                           }else{
                               [ZESettingLocalData deleteCookie];
                               [ZESettingLocalData deleteUSERNAME];
                               [ZESettingLocalData deleteUSERPASSWORD];
                               NSLog(@"登陆失败   %@",[data objectForKey:@"RETMSG"]);
                               [ZEUtil showAlertView:[data objectForKey:@"RETMSG"] viewController:self];
                           }

                       } fail:^(NSError *errorCode) {
                           [self progressEnd:nil];
                       }];
    
}

#pragma mark - 获取个人信息

-(void)commonRequest:(NSString *)username
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":@"",
                                @"USERNAME":@"",
                                @"NICKNAME":@"",
                                @"SEQKEY":@"",
                                @"EXPERTDATE":@"",
                                @"EXPERTTYPE":@"",
                                @"STATUS":@"",
                                @"EXPERTFRADE":@"",
                                @"USERACCOUNT":username,
                                @"FILEURL":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
                                     NSMutableDictionary * userinfoDic = [NSMutableDictionary dictionaryWithDictionary:arr[0]];
                                     [userinfoDic setObject:[userinfoDic objectForKey:@"USERNAME"] forKey:@"NAME"];
                                     [ZESettingLocalData setUSERINFODic:userinfoDic];
                                     NSLog(@">>>  %@",userinfoDic);
                                     if([ZEUtil isStrNotEmpty:[userinfoDic objectForKey:@"FILEURL"]]){
                                         NSArray * headUrlArr = [[userinfoDic objectForKey:@"FILEURL"] componentsSeparatedByString:@","];
                                         [ZESettingLocalData changeUSERHHEADURL:headUrlArr[1]];
                                     }
                                 }
                                 [self goHome];
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];

}

#pragma mark - 查询该用户是否为专家

//-(void)isExpert
//{
//    NSDictionary * parametersDic = @{@"limit":@"20",
//                                     @"MASTERTABLE":KLB_EXPERT_INFO,
//                                     @"MENUAPP":@"EMARK_APP",
//                                     @"ORDERSQL":@"",
//                                     @"WHERESQL":@"",
//                                     @"start":@"0",
//                                     @"METHOD":@"search",
//                                     @"MASTERFIELD":@"SEQKEY",
//                                     @"DETAILFIELD":@"",
//                                     @"CLASSNAME":BASIC_CLASS_NAME,
//                                     @"DETAILTABLE":@"",};
//    
//    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERNAME],
//                                @"USERNAME":@"",
//                                @"EXPERTDATE":@"",
//                                @"EXPERTTYPE":@"",
//                                @"STATUS":@"",
//                                @"EXPERTFRADE":@"",
//                                @"SEQKEY":@""};
//    
//    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_EXPERT_INFO]
//                                                                           withFields:@[fieldsDic]
//                                                                       withPARAMETERS:parametersDic
//                                                                       withActionFlag:nil];
//    
//    [ZEUserServer getDataWithJsonDic:packageDic
//                       showAlertView:NO
//                             success:^(id data) {
//                                 NSDictionary * dataDic = [ZEUtil getServerDic:data withTabelName:KLB_EXPERT_INFO];
//                                 if ([[dataDic objectForKey:@"totalCount"] integerValue] == 0) {
//                                     [ZESettingLocalData setISEXPERT:NO];
//                                 }else{
//                                     [ZESettingLocalData setISEXPERT:YES];
//                                 }
//                                 
//                             } fail:^(NSError *errorCode) {
//                                 NSLog(@">>  %@",errorCode);
//                             }];
//}


-(void)showAlertView:(NSString *)alertMes
{
   
    if (IS_IOS8) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:alertMes message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                           style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alertMes
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)goHome
{
    ZEHomeVC * homeVC = [[ZEHomeVC alloc]init];
    homeVC.tabBarItem.image = [UIImage imageNamed:@"icon_home"];
    homeVC.tabBarItem.title = @"首页";
    UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    ZEQuestionsVC * quesetionsVC = [[ZEQuestionsVC alloc]init];
    quesetionsVC.tabBarItem.image = [UIImage imageNamed:@"icon_question"];
    quesetionsVC.tabBarItem.title = @"问答";
    UINavigationController * quesetionsNav = [[UINavigationController alloc]initWithRootViewController:quesetionsVC];
    
    ZEGroupVC * groupVC = [[ZEGroupVC alloc]init];
    groupVC.tabBarItem.image = [UIImage imageNamed:@"icon_circle"];
    groupVC.tabBarItem.title = @"圈子";
    UINavigationController * groupNav = [[UINavigationController alloc]initWithRootViewController:groupVC];
    
    ZEUserCenterVC * userCenVC = [[ZEUserCenterVC alloc]init];
    userCenVC.tabBarItem.image = [UIImage imageNamed:@"icon_user"];
    userCenVC.tabBarItem.title = @"我的";
    UINavigationController * userCenNav = [[UINavigationController alloc]initWithRootViewController:userCenVC];
    
    UITabBarController * tabBar = [[UITabBarController alloc]init];
    tabBar.tabBar.tintColor = MAIN_NAV_COLOR;
    tabBar.viewControllers = @[homeNav,quesetionsNav,groupNav,userCenNav];
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = tabBar;
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
