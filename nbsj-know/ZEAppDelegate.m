//
//  AppDelegate.m
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEAppDelegate.h"
#import "ZEPersonalNotiVC.h"
#import "ZELoginViewController.h"
#import "LBTabBarController.h"

#import "ZETeamNotiCenVC.h"

#import "ZETeamChatRoomVC.h"

@interface ZEAppDelegate ()

@end

@implementation ZEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin) name:kRelogin object:nil];

    if([[ZESettingLocalData getUSERNAME] length] > 0 && [[ZESettingLocalData getUSERPASSWORD] length] > 0) {
        LBTabBarController *tab = [[LBTabBarController alloc] init];
        self.window.rootViewController = tab;

    }else{
        ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
        self.window.rootViewController = loginVC;
    }
    
    NSDictionary *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSDictionary *dict = [localNotif valueForKey:@"aps"];
    if([ZEUtil isNotNull:dict]){
        ZEPersonalNotiVC * notiVC = [[ZEPersonalNotiVC alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:notiVC];
        nav.navigationBarHidden = YES;
        notiVC.enterPerNotiType = ENTER_PERSONALNOTICENTER_TYPE_NOTI;
        self.window.rootViewController = nav;
    }
    
    
//    ZETeamNotiCenVC * loginVC = [[ZETeamNotiCenVC alloc]init];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
//    self.window.rootViewController = nav;


#pragma mark - 注册通知
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:JMESSAGE_APPKEY
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    [JMessage setupJMessage:launchOptions
                     appKey:JMESSAGE_APPKEY
                    channel:@"App Store"
           apsForProduction:NO
                   category:nil];
    [JMessage addDelegate:self withConversation:nil];

//    NSLog(@"%@",NSHomeDirectory());
//    NSLog(@"%@",Zenith_Server);
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    if ([ZESettingLocalData getUSERCODE] > 0) {
        [JPUSHService setAlias:[ZESettingLocalData getUSERCODE] callbackSelector:nil object:nil];
    }
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)setAliasSuccess
{
    NSLog(@">>>>  设置唯一标识符成功");
}

#pragma mark -实现注册APNs失败接口（可选）

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark - 添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    ZEPersonalNotiVC * notiVC = [[ZEPersonalNotiVC alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:notiVC];
    notiVC.enterPerNotiType = ENTER_PERSONALNOTICENTER_TYPE_NOTI;
    nav.navigationBarHidden = YES;
    if ([[userInfo objectForKey:@"_j_type"] isEqualToString:@"jmessage"]) {
        notiVC.enterPerNotiType = ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT;
    }
    self.window.rootViewController = nav;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@">>>>> ========  %@",userInfo);
    
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *apnsType = [userInfo objectForKey:@"_j_type"];
    if (application.applicationState == UIApplicationStateActive) {
        UIViewController * vc = [ZEUtil getCurrentVC];
        [MBProgressHUD hideHUDForView:vc.view animated:YES];
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = alert;
        [hud3 hide:YES afterDelay:2];
        hud3.yOffset = SCREEN_HEIGHT / 2 - 80;
    }else if (application.applicationState == UIApplicationStateBackground ||application.applicationState == UIApplicationStateInactive){
        
        ZEPersonalNotiVC * notiVC = [[ZEPersonalNotiVC alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:notiVC];
        notiVC.enterPerNotiType = ENTER_PERSONALNOTICENTER_TYPE_NOTI;
        if ([apnsType isEqualToString:@"jmessage"]) {
            notiVC.enterPerNotiType = ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT;
        }
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    }
    [application setApplicationIconBadgeNumber:0];
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
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

#pragma - mark JMessageDelegate
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
        case kJMSGEventNotificationCurrentUserInfoChange:{
            NSLog(@"Current user info change Notification Event ");
        }
            break;
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend:
        {
            //JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"Friend Notification Event");
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"Receive Server Friend update Notification Event");
            break;
            
            
        case kJMSGEventNotificationLoginKicked:
            [self goLoginVC:@"您的账号在其他设备登录，请重新登录"];
            break;
        case kJMSGEventNotificationServerAlterPassword:{
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"AlterPassword Notification Event ");
            }
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"User login status unexpected Notification Event ");
            }
        }
            break;
            
        default:
            break;
    }
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
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
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
    //  退出成功注销JPush别名
    if ([ZESettingLocalData getUSERCODE] > 0) {
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            if (iResCode == 0) {//对应的状态码返回为0，代表成功
                [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
            }
        }];
    }
    [ZESettingLocalData clearLocalData];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        
    }];

    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    self.window.rootViewController = loginVC;
    if (str.length > 0) {
        [ZEUtil showAlertView:str viewController:loginVC];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
