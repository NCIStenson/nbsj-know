//
//  AppDelegate.m
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEAppDelegate.h"
#import "ZEMainViewController.h"

#import "ZEHomeVC.h"
#import "ZEQuestionsVC.h"
#import "ZEGroupVC.h"
#import "ZEUserCenterVC.h"
#import "ZELoginViewController.h"


#import "LBTabBarController.h"

#import "ZETypicalCaseDetailVC.h"
@interface ZEAppDelegate ()

@end

@implementation ZEAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = YES;
    
//    [[ZEServerEngine sharedInstance] downloadFiletWithJsonDic:nil
//                                            withServerAddress:@"http://117.149.2.229:8056/emarkspg_klb/file/2016-11-11/cdfe838d-69e8-408d-a5bd-f240b3626806.xlsx"
//                                                     fileName:@"123.pdf"
//                                                 withProgress:^(CGFloat progress) {
//                                                     NSLog(@"======  %f",progress);
//                                                 } success:^(id data) {
//                                                     NSLog(@">>>  %@",data);
//                                                 } fail:^(NSError *error) {
//                                                     
//                                                 }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin) name:kRelogin object:nil];

    
    if([[ZESettingLocalData getUSERNAME] length] > 0 && [[ZESettingLocalData getUSERPASSWORD] length] > 0) {
        
        
//        ZEHomeVC * homeVC = [[ZEHomeVC alloc]init];
//        homeVC.tabBarItem.image = [UIImage imageNamed:@"icon_home"];
//        homeVC.tabBarItem.title = @"首页";
//        UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
//        
//        ZEQuestionsVC * quesetionsVC = [[ZEQuestionsVC alloc]init];
//        quesetionsVC.tabBarItem.image = [UIImage imageNamed:@"icon_question"];
//        quesetionsVC.tabBarItem.title = @"问答";
//        UINavigationController * quesetionsNav = [[UINavigationController alloc]initWithRootViewController:quesetionsVC];
//        
//        ZEGroupVC * groupVC = [[ZEGroupVC alloc]init];
//        groupVC.tabBarItem.image = [UIImage imageNamed:@"icon_circle"];
//        groupVC.tabBarItem.title = @"圈子";
//        UINavigationController * groupNav = [[UINavigationController alloc]initWithRootViewController:groupVC];
//        
//        ZEUserCenterVC * userCenVC = [[ZEUserCenterVC alloc]init];
//        userCenVC.tabBarItem.image = [UIImage imageNamed:@"icon_user"];
//        userCenVC.tabBarItem.title = @"我的";
//        UINavigationController * userCenNav = [[UINavigationController alloc]initWithRootViewController:userCenVC];
        
//        UITabBarController * tabBar = [[UITabBarController alloc]init];
//        tabBar.tabBar.tintColor = MAIN_NAV_COLOR;
//        tabBar.viewControllers = @[homeNav,quesetionsNav,groupNav,userCenNav];
        
        LBTabBarController *tab = [[LBTabBarController alloc] init];
        
//        CATransition *anim = [[CATransition alloc] init];
//        anim.type = @"rippleEffect";
//        anim.duration = 1.0;
        
//        [self.window.layer addAnimation:anim forKey:nil];

        self.window.rootViewController = tab;

    }else{
        ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
        self.window.rootViewController = loginVC;
    }

    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"%@",Zenith_Server);
    
    return YES;
}

- (void) _checkNet{
    //开启网络状态监控
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status==AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"当前是wifi");
        }
        if(status==AFNetworkReachabilityStatusReachableViaWWAN){
            NSLog(@"当前是3G");
        }
        if(status==AFNetworkReachabilityStatusNotReachable){
            NSLog(@"当前是没有网络");
        }
        if(status==AFNetworkReachabilityStatusUnknown){
            NSLog(@"当前是未知网络");
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self reLogin];
}

-(void)reLogin{
    if([ZESettingLocalData getUSERNAME].length > 0 && [[ZESettingLocalData getUSERPASSWORD] length] > 0){
        [self goLogin:[ZESettingLocalData getUSERNAME] password:[ZESettingLocalData getUSERPASSWORD]];
    }
}
-(void)goLogin:(NSString *)username password:(NSString *)pwd
{
    [ZEUserServer loginWithNum:username
                  withPassword:pwd
                       success:^(id data) {
                           if ([[data objectForKey:@"RETMSG"] isEqualToString:@"null"]) {
                               [ZESettingLocalData setUSERNAME:username];
                               [ZESettingLocalData setUSERPASSWORD:pwd];
                               [[NSNotificationCenter defaultCenter]postNotificationName:kVerifyLogin object:nil];
                           }else{
                               [ZESettingLocalData deleteCookie];
                               [ZESettingLocalData deleteUSERNAME];
                               [ZESettingLocalData deleteUSERPASSWORD];
                               [self goLoginVC:[data objectForKey:@"RETMSG"]];
                           }
                       } fail:^(NSError *errorCode) {
                       }];
}
-(void)goLoginVC:(NSString *)str
{
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    self.window.rootViewController = loginVC;
    [ZEUtil showAlertView:str viewController:loginVC];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}




- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
