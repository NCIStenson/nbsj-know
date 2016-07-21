//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#define kWeatherInfo Zenith_Server

#import "ZEUserServer.h"

@implementation ZEUserServer

+ (void)getWeatherInfoWithCity:(NSString *)str
                       success:(ServerResponseSuccessBlock)successBlock
                          fail:(ServerResponseFailBlock)failBlock
                         error:(ServerErrorRecordBlock)errorBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:nil
                                                 path:kWeatherInfo
                                           httpMethod:@"GET"
                                              success:^(NSString *successMsg, id data) {
                                                  successBlock(@"请求成功",data);
                                              } fail:^(NSError * error) {
                                                  failBlock(error);
     }];
}

@end
