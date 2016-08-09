//
//  ZESettingLocalData.h
//  nbsj-know
//
//  Created by Stenson on 16/8/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZESettingLocalData : NSObject

+(void)setCookie:(NSString *)str;
+(NSString *)getCookie;
+(void)deleteCookie;

@end
