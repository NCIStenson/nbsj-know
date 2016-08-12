//
//  ZESetLocalData.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZESettingLocalData.h"

static NSString * kUserInformation  = @"keyUserInformation";
static NSString * kSignCookie       = @"keySIGNCOOKIE";
static NSString * kUSERNAME         = @"kUSERNAME";
static NSString * kUSERCODE         = @"kUSERCODE";

@implementation ZESettingLocalData

+(id)Get:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSString *)GetStringWithKey:(NSString *)key
{
    id value = [self Get:key];
    
    if (value == [NSNull null] || value == nil) {
        return @"";
    }
    
    return value;
}

+(int)GetIntWithKey:(NSString *)key
{
    id value = [self Get:key];
    
    if (value == [NSNull null] || value == nil) {
        return -1;
    }
    
    return [value intValue];
}

+(void)Set:(NSString*)key value:(id)value
{
    if (value == [NSNull null] || value == nil) {
        value = @"";
    }
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - COOKIE

+(void)setCookie:(NSData *)str
{
    [self Set:kSignCookie value:str];
}

+(NSData *)getCookie
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSignCookie];
}

+(void)deleteCookie
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSignCookie];
}

#pragma mark - USERNAME
+(void)setUSERNAME:(NSString *)str
{
    [self Set:kUSERNAME value:str];
}
+(NSString *)getUSERNAME
{
    return [self Get:kUSERNAME];
}
+(void)deleteUSERNAME
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERNAME];
}

#pragma mark - USERCODE

+(void)setUSERCODE:(NSString *)str
{
    [self Set:kUSERCODE value:str];
}
+(NSString *)getUSERCODE
{
     return [self Get:kUSERCODE];
}
+(void)deleteUSERCODE
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERCODE];
}


#pragma mark - CLEAR

+(void)clearLocalData
{
    
}


@end

