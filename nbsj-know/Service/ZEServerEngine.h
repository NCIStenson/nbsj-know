//
//  NCIServerEngine.h
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^ServerResponseBlock) (NSDictionary *result);
typedef void (^ServerResponseSuccessBlock) (NSString *successMsg, id data);
typedef void (^ServerResponseFailBlock) (NSError *errorCode);
typedef void (^ServerErrorRecordBlock) (void);  // 记录服务器错误block

@interface ZEServerEngine : NSObject

+ (ZEServerEngine *)sharedInstance;

-(void)requestWithParams:(NSMutableDictionary *)params
                    path:(NSString * )path
              httpMethod:(NSString *)httpMethod
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock;

@end
