//
//  ZEMarcoConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#ifndef ZEMarcoConstant_h
#define ZEMarcoConstant_h

#define RICHTEXT_IMAGE (@"[UIImageView]")

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define FRAME_WIDTH     [[UIScreen mainScreen] applicationFrame].size.width
#define FRAME_HEIGHT    [[UIScreen mainScreen] applicationFrame].size.height
#define IPHONE5_MORE     ([[UIScreen mainScreen] bounds].size.height > 480)
#define IPHONE4S_LESS    ([[UIScreen mainScreen] bounds].size.height <= 480)
#define IPHONE5     ([[UIScreen mainScreen] bounds].size.height == 568)
#define IPHONE6_MORE     ([[UIScreen mainScreen] bounds].size.height > 568)
#define IPHONE6     ([[UIScreen mainScreen] bounds].size.height == 667)
#define IPHONE6P     ([[UIScreen mainScreen] bounds].size.height == 736)

#define HTTPMETHOD_GET @"GET"
#define HTTPMETHOD_POST @"POST"

#define METHOD_SEARCH @"search"
#define METHOD_UPDATE @"updateSave"
#define METHOD_INSERT @"addSave"
#define METHOD_DELETE @"delete"

#define kTiltlFontSize 14.0f
#define kSubTiltlFontSize 12.0f

#define NAV_HEIGHT 64.0f
#define MAX_PAGE_COUNT 20

#define Zenith_Server [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ZenithServerAddress"]

#define ZENITH_IMAGEURL(fileURL) [NSURL URLWithString:[ZEUtil changeURLStrFormat:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,fileURL]]]
#define ZENITH_IMAGE_FILESTR(fileStr) [NSString stringWithFormat:@"%@/file/%@",Zenith_Server,fileStr]
#define ZENITH_PLACEHODLER_IMAGE [UIImage imageNamed:@"placeholder.png"]
#define ZENITH_PLACEHODLER_USERHEAD_IMAGE [UIImage imageNamed:@"avatar_default.jpg"]
#define kCellImgaeHeight    (SCREEN_WIDTH - 60)/3

#define kNOTI_CHANGEPERSONALMSG_SUCCESS @"NOTI_CHANGEPERSONALMSG_SUCCESS"

#define kNOTI_SCORE_SUCCESS @"NOTI_SCORE_SUCCESS"

#define kRelogin @"kRelogin"
#define kVerifyLogin @"kVerifyLogin"
#endif /* ZEMarcoConstant_h */
