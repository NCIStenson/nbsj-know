//
//  ZEUserServer.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZEServerEngine.h"

@interface ZEUserServer : NSObject

+ (void)getWeatherInfoWithCity:(NSString *)str
                       success:(ServerResponseSuccessBlock)successBlock
                          fail:(ServerResponseFailBlock)failBlock
                         error:(ServerErrorRecordBlock)errorBlock;
@end
