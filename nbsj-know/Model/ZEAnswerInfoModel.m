//
//  ZEAnswerInfoModel.m
//  nbsj-know
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerInfoModel.h"

static ZEAnswerInfoModel * ansertInfoM = nil;

@implementation ZEAnswerInfoModel

+(ZEAnswerInfoModel *)getDetailWithDic:(NSDictionary *)dic
{
    ansertInfoM = [[ZEAnswerInfoModel alloc]init];
    
    ansertInfoM.SEQKEY         = [dic objectForKey:@"SEQKEY"];
    ansertInfoM.QUERTIONID     = [dic objectForKey:@"QUERTIONID"];
    ansertInfoM.ANSWEREXPLAIN  = [dic objectForKey:@"ANSWEREXPLAIN"];
    ansertInfoM.ANSWERIMAGE    = [dic objectForKey:@"ANSWERIMAGE"];
    ansertInfoM.ANSWERUSERCODE = [dic objectForKey:@"ANSWERUSERCODE"];
    ansertInfoM.ANSWERUSERNAME = [dic objectForKey:@"ANSWERUSERNAME"];
    ansertInfoM.ANSWERLEVEL    = [dic objectForKey:@"ANSWERLEVEL"];
    ansertInfoM.ISPASS         = [dic objectForKey:@"ISPASS"];
    ansertInfoM.ISENABLED      = [dic objectForKey:@"ISENABLED"];
    ansertInfoM.GOODNUMS       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GOODNUMS"]];
    ansertInfoM.SYSCREATEDATE  = [dic objectForKey:@"SYSCREATEDATE"];
    
    return ansertInfoM;
}

@end
