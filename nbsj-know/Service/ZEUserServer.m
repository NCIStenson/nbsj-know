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
{
    NSDictionary * dataDic = [ZEPackageServerData getLoginServerDataWithUsername:username
                                                                    withPassword:password];
    
    NSString * loginServer = [NSString stringWithFormat: @"%@/do/app/login",Zenith_Server];
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dataDic
                                     withServerAddress:loginServer
                                               success:^(id data) {
                                                   successBlock(data);
                                               } fail:^(NSError *errorCode) {
                                                   NSLog(@"请求失败 >>  %@",errorCode);
                                                   failBlock(errorCode);
                                               }];
}

+(void)logoutSuccess:(ServerResponseSuccessBlock)successBlock
                fail:(ServerResponseFailBlock)failBlock
{
    NSDictionary * dataDic = [ZEPackageServerData getLogoutServerData];
    NSLog(@">>  %@",dataDic);
    NSString * logoutServer = [NSString stringWithFormat: @"%@/do/app/logout",Zenith_Server];
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dataDic
                                     withServerAddress:logoutServer
                                               success:^(id data) {
                                                   successBlock(data);
                                               } fail:^(NSError *errorCode) {
                                                   NSLog(@"请求失败 >>  %@",errorCode);
                                                   failBlock(errorCode);
                                               }];
}

+(void)getDataWithJsonDic:(NSDictionary *)dic
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock
{
    
    NSString * commonServer = [NSString stringWithFormat: @"%@/do/app/uiaction",Zenith_Server];
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dic
                                     withServerAddress:commonServer
                                               success:^(id data) {
                                                   successBlock(data);
                                               } fail:^(NSError *errorCode) {
                                                   failBlock(errorCode);
                                               }];
}


@end
