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



+(void)setCookie:(NSString *)str
{
    [self Set:kSignCookie value:str];
    
}

+(NSString *)getCookie
{
    return [self GetStringWithKey:kSignCookie];
}

+(void)deleteCookie
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSignCookie];
}
@end

