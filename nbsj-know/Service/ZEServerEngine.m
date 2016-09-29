//
//  NCIServerEngine.m
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEServerEngine.h"
#import "ZESettingLocalData.h"

#import "ZELoginViewController.h"
#define kServerErrorNotLogin                @"E020601" // 用户未登陆
#define kServerErrorLoginTimeOut            @"E020602" // 登陆超时
#define kServerErrorReqTimeOut              @"E020603" // 请求超时
#define kServerErrorIllegalReq              @"E020604" // 非法请求

static ZEServerEngine *serverEngine = nil;

@implementation ZEServerEngine

+ (ZEServerEngine *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverEngine = [[ZEServerEngine alloc] initSingle];
    });
    return serverEngine;
}

-(id)initSingle
{
    self = [super init];
    if ( self) {
        
    }
    return self;
}

-(void)requestWithParams:(NSMutableDictionary *)params
                    path:(NSString * )path
              httpMethod:(NSString *)httpMethod
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock
{
    NSString * serverAdress = nil;
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([httpMethod isEqualToString:HTTPMETHOD_GET]) {
        [sessionManager GET:path parameters:nil
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                        if ([responseDic isKindOfClass:[NSDictionary class]] && [ZEUtil isNotNull:responseDic]) {
                            if (successBlock != nil) {
                                successBlock(responseDic);
                            }
                        }
        }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if (error != nil) {
                            failBlock(error);
                        }}];
    }else if ([httpMethod isEqualToString:HTTPMETHOD_POST]){
        [sessionManager POST:serverAdress
                  parameters:params progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
    }
    
    
}

-(void)requestWithJsonDic:(NSDictionary *)jsonDic
        withServerAddress:(NSString *)serverAddress
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;

    NSData *cookiesdata = [ZESettingLocalData getCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }  
    }

    [manager POST:serverAddress
              parameters:jsonDic
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
                     NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookiesArray];
                     if(![cookiesdata length]) {
                         [ZESettingLocalData setCookie:data];
                     }
                     NSError * err = nil;
                     NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
                     if ([ZEUtil isNotNull:responseObject]) {
                         successBlock(responseDic);
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (error != nil) {
                         failBlock(error);
                     }
                 }];
}

-(void)requestWithJsonDic:(NSDictionary *)jsonDic
             withImageArr:(NSArray *)arr
        withServerAddress:(NSString *)serverAddress
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
    
    NSData *cookiesdata = [ZESettingLocalData getCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
//    arr = @[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"1.jpg"]];
    
    [manager                  POST:serverAddress
                        parameters:nil
         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             [formData appendPartWithFormData:[[ZEServerEngine dictionaryToJson:jsonDic] dataUsingEncoding:NSUTF8StringEncoding]  name:@"JSONBODY"];
             
             for (int i = 0 ; i < arr.count; i ++) {
                 UIImage *image = arr[i];
                 NSData *imageData = UIImageJPEGRepresentation(image,0.1);
                 NSLog(@" 图片大小 >>>  %ld",imageData.length / 1024);
                 NSString *fileName = [NSString stringWithFormat:@"image%d.jpg",i];
                 
                 [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
             }
             
         }
                          progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookiesArray];
             if(![cookiesdata length]) {
                 [ZESettingLocalData setCookie:data];
             }
             NSError * err = nil;
             NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
             
             if ([ZEUtil isNotNull:responseObject]) {
                 successBlock(responseDic);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (error != nil) {
                 failBlock(error);
             }
         }];
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+(NSData*)returnDataWithDictionary:(NSDictionary*)dict
{
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:dict];
    [archiver finishEncoding];
    return data;
}


-(void)showLoginVC
{
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow setRootViewController:loginVC];
}



@end
