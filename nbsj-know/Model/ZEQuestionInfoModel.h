//
//  ZEQuestionInfoModel.h
//  nbsj-know
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEQuestionInfoModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * QUESTIONTYPECODE;
@property (nonatomic,copy) NSString * QUESTIONEXPLAIN;
@property (nonatomic,copy) NSString * QUESTIONIMAGE;
@property (nonatomic,copy) NSString * QUESTIONUSERCODE;
@property (nonatomic,copy) NSString * QUESTIONUSERNAME;
@property (nonatomic,copy) NSString * QUESTIONLEVEL;
@property (nonatomic,copy) NSString * STATISTICALSRC;
@property (nonatomic,copy) NSString * IMPORTLEVEL;
@property (nonatomic,copy) NSString * ISLOSE;
@property (nonatomic,copy) NSString * ISEXPERTANSWER;
@property (nonatomic,copy) NSString * ISSOLVE;
@property (nonatomic,copy) NSString * SYSCREATEDATE;
@property (nonatomic,copy) NSString * ANSWERSUM;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * HEADIMAGE;
@property (nonatomic,copy) NSString * NICKNAME;

+(ZEQuestionInfoModel *)getDetailWithDic:(NSDictionary *)dic;

@end
