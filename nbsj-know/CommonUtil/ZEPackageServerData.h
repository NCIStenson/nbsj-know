//
//  ZEPackageServerData.h
//  nbsj-know
//
//  Created by Stenson on 16/8/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEPackageServerData : NSObject

+(NSDictionary *)getLoginServerDataWithUsername:(NSString *)username
                                   withPassword:(NSString *)pwd;

+(NSDictionary *)getCommonServerData;

@end
