//
//  ZETeamCircleModel.h
//  nbsj-know
//
//  Created by Stenson on 17/3/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZETeamCircleModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * FILEURL;   // 团队头像
@property (nonatomic,copy) NSString * SYSCREATEDATE;  // 团队创建日期
@property (nonatomic,copy) NSString * TEAMCIRCLECODE; // 团队所属分类code
@property (nonatomic,copy) NSString * TEAMCIRCLENAME; // 团队名称
@property (nonatomic,copy) NSString * TEAMCIRCLECODENAME; // 团队所属分类name

@property (nonatomic,copy) NSString * TEAMCIRCLEREMARK;  // 团队简介
@property (nonatomic,copy) NSString * TEAMMEMBERS;  // 团队成员
@property (nonatomic,copy) NSString * TEAMMANIFESTO;     //  团队宣言
@property (nonatomic,copy) NSString * SYSCREATORID;     //  创建班组圈的工号
+(ZETeamCircleModel *)getDetailWithDic:(NSDictionary *)dic;

@end
