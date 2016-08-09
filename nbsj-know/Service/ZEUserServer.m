//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEPackageServerData.h"
#import "ZEUserServer.h"

@implementation ZEUserServer


+(void)loginWithNum:(NSString *)username
       withPassword:(NSString *)password
            success:(ServerResponseSuccessBlock)successBlock
               fail:(ServerResponseFailBlock)failBlock
              error:(ServerErrorRecordBlock)errorBlock
{
    
    
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic1 options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@">.  %@",jsonStr);
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:[ZEPackageServerData getLoginServerDataWithUsername:@"060600-01-100823"
                                                                                              withPassword:password] success:^(id data) {
//        NSLog(@"请求成功 >>  %@",data);
    } fail:^(NSError *errorCode) {
        
    }];
}

+(void)getDataSuccess:(ServerResponseSuccessBlock)successBlock
                 fail:(ServerResponseFailBlock)failBlock
                error:(ServerErrorRecordBlock)errorBlock
{
    
//    {"NCI":{"DATAS":[{"name":"EPM_TEAM_RATION_COMMON","fields":[]}],"PARAMETERS":{"PARA":[{"name":"limit","value":"20"},{"name":"MASTERTABLE","value":"EPM_TEAM_RATION_COMMON"},{"name":"MENUAPP","value":"EMARK_APP"},{"name":"ORDERSQL","value":"DISPLAYORDER"},{"name":"WHERESQL","value":"orgcode in (#TEAMORGCODES#) and suitunit='#SUITUNIT#'"},{"name":"start","value":"0"},{"name":"METHOD","value":"search"},{"name":"MASTERFIELD","value":"SEQKEY"},{"name":"DETAILFIELD","value":""},{"name":"CLASSNAME","value":"com.nci.app.operation.business.AppBizOperation"},{"name":"DETAILTABLE","value":""}]},"COMMAND":{"mobileapp":"true","actionflag":"select"}}}
    
    NSLog(@">>  %@",[ZEPackageServerData getCommonServerData] );
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:[ZEPackageServerData getCommonServerData] success:^(id data) {
        NSLog(@"请求成功 >>  %@",data);
    } fail:^(NSError *errorCode) {
        
    }];
}


@end
