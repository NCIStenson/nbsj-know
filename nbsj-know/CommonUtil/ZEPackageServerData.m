//
//  ZEPackageServerData.m
//  nbsj-know
//
//  Created by Stenson on 16/8/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPackageServerData.h"

@implementation ZEPackageServerData


+(NSDictionary *)getLoginServerDataWithUsername:(NSString *)username
                                   withPassword:(NSString *)pwd
{
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
    
    ZEPackageServerData * pack = [[ZEPackageServerData alloc]init];
    
    [mutableDic setObject:[pack DATASWithUsername:username withPassword:pwd] forKey:@"DATAS"];
    [mutableDic setObject:[pack PARAMETERS] forKey:@"PARAMETERS"];
    [mutableDic setObject:[pack COMMAND] forKey:@"COMMAND"];
    
    return @{@"NCI":mutableDic};
}

-(NSArray *)DATASWithUsername:(NSString *)username
                 withPassword:(NSString *)pwd
{
    NSArray * arr = @[@{@"name":@"UUM_USER",
                        @"fields":@[@{@"name":@"LOGINPWD",
                                           @"value":pwd},
                                       @{@"name":@"USERACCOUNT",
                                         @"value":username}]}];
    return arr;
}

-(NSDictionary *)PARAMETERS
{
    NSDictionary * dic =@{@"PARA":@[]};
    return dic;
}

-(NSDictionary *)COMMAND
{
    NSDictionary * dic =@{@"mobileapp":@"true"};
    return dic;
}

#pragma mark - COMMONSERVERDATA

+(NSDictionary *)getCommonServerData
{
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
    
    ZEPackageServerData * pack = [[ZEPackageServerData alloc]init];
    
    [mutableDic setObject:[pack commonDATAS] forKey:@"DATAS"];
    [mutableDic setObject:[pack commonPARAMETERS] forKey:@"PARAMETERS"];
    [mutableDic setObject:[pack commonCOMMAND] forKey:@"COMMAND"];
    
    return @{@"NCI":mutableDic};
}

-(NSArray *)commonDATAS
{
    NSArray * arr = @[@{@"name":@"EPM_TEAM_RATION_COMMON",@"fields":@[]}];
    return arr;
}

-(NSDictionary *)commonPARAMETERS
{
    NSDictionary * dic = @{@"PARA":@[@{@"name":@"limit",@"value":@"20"},
                                     @{@"name":@"MASTERTABLE",@"value":@"EPM_TEAM_RATION_COMMON"},
                                     @{@"name":@"MENUAPP",@"value":@"EMARK_APP"},
                                     @{@"name":@"ORDERSQL",@"value":@"DISPLAYORDER"},
                                     @{@"name":@"WHERESQL",@"value":@"orgcode in (#TEAMORGCODES#) and suitunit='#SUITUNIT#'"},
                                     @{@"name":@"start",@"value":@"0"},
                                     @{@"name":@"METHOD",@"value":@"search"},
                                     @{@"name":@"MASTERFIELD",@"value":@"SEQKEY"},
                                     @{@"name":@"DETAILFIELD",@"value":@""},
                                     @{@"name":@"CLASSNAME",@"value":@"com.nci.app.operation.business.AppBizOperation"},
                                     @{@"name":@"DETAILTABLE",@"value":@""}]};
    return dic;
}

-(NSDictionary *)commonCOMMAND
{
    NSDictionary * dic =@{@"mobileapp":@"true",
                          @"actionflag":@"select"};
    return dic;
}

@end
