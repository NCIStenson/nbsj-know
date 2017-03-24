//
//  AppDelegate.h
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//


//      http://192.168.1.144:8080/nbsjzd

//  测试版     http://117.149.2.229:1622/emarkspg_nbsjzd
//  正式版     http://120.27.152.63:8888/emarkspg_nbsjzd
//  King 机器版     http://192.168.1.175:8080/nbsjzd
//  Juan 机器版     http://192.168.1.189:8080/nbsjzd


#import <UIKit/UIKit.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>


@interface ZEAppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

