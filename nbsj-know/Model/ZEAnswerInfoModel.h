//
//  ZEAnswerInfoModel.h
//  nbsj-know
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEAnswerInfoModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * QUERTIONID;
@property (nonatomic,copy) NSString * ANSWEREXPLAIN;
@property (nonatomic,copy) NSString * ANSWERIMAGE;
@property (nonatomic,copy) NSString * ANSWERUSERCODE;
@property (nonatomic,copy) NSString * ANSWERUSERNAME;
@property (nonatomic,copy) NSString * ANSWERLEVEL;
@property (nonatomic,copy) NSString * ISPASS;
@property (nonatomic,copy) NSString * ISENABLED;
@property (nonatomic,copy) NSString * GOODNUMS;
@property (nonatomic,copy) NSString * SYSCREATEDATE;

+(ZEAnswerInfoModel *)getDetailWithDic:(NSDictionary *)dic;

@end
