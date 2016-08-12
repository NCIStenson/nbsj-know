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

@interface ZEAppDelegate ()

@end

@implementation ZEAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = YES;
    
    NSData *cookiesdata = [ZESettingLocalData getCookie];
    if([cookiesdata length]) {
        ZEHomeVC * homeVC = [[ZEHomeVC alloc]init];
        homeVC.tabBarItem.image = [UIImage imageNamed:@"ic_titlebar_home_normal_flat.png"];
        homeVC.tabBarItem.title = @"首页";
        UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
        
        ZEQuestionsVC * quesetionsVC = [[ZEQuestionsVC alloc]init];
        quesetionsVC.tabBarItem.image = [UIImage imageNamed:@"refresh_Rank.png"];
        quesetionsVC.tabBarItem.title = @"问答";
        UINavigationController * quesetionsNav = [[UINavigationController alloc]initWithRootViewController:quesetionsVC];
        
        ZEGroupVC * groupVC = [[ZEGroupVC alloc]init];
        groupVC.tabBarItem.image = [UIImage imageNamed:@"tab_homepage_normal"];
        groupVC.tabBarItem.title = @"圈子";
        UINavigationController * groupNav = [[UINavigationController alloc]initWithRootViewController:groupVC];
        
        ZEUserCenterVC * userCenVC = [[ZEUserCenterVC alloc]init];
        userCenVC.tabBarItem.image = [UIImage imageNamed:@"tab_homepage_normal"];
        userCenVC.tabBarItem.title = @"我的";
        UINavigationController * userCenNav = [[UINavigationController alloc]initWithRootViewController:userCenVC];
        
        UITabBarController * tabBar = [[UITabBarController alloc]init];
        tabBar.tabBar.tintColor = MAIN_NAV_COLOR;
        tabBar.viewControllers = @[homeNav,quesetionsNav,groupNav,userCenNav];
        
        self.window.rootViewController = tabBar;
    }else{
        ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
        self.window.rootViewController = loginVC;
    }

    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"%@",Zenith_Server);
    
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
