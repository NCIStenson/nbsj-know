//
//  ZEQuestionInfoModel.m
//  nbsj-know
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionInfoModel.h"
static ZEQuestionInfoModel * quesInfoM = nil;
@implementation ZEQuestionInfoModel


+(ZEQuestionInfoModel *)getDetailWithDic:(NSDictionary *)dic
{
    quesInfoM = [[ZEQuestionInfoModel alloc]init];
    
    quesInfoM.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    quesInfoM.QUESTIONTYPECODE = [dic objectForKey:@"QUESTIONTYPECODE"];
    quesInfoM.QUESTIONEXPLAIN  = [dic objectForKey:@"QUESTIONEXPLAIN"];
    quesInfoM.QUESTIONIMAGE    = [dic objectForKey:@"QUESTIONIMAGE"];
    quesInfoM.QUESTIONUSERCODE = [dic objectForKey:@"QUESTIONUSERCODE"];
    quesInfoM.QUESTIONUSERNAME = [dic objectForKey:@"QUESTIONUSERNAME"];
    quesInfoM.QUESTIONLEVEL    = [dic objectForKey:@"QUESTIONLEVEL"];
    quesInfoM.STATISTICALSRC   = [dic objectForKey:@"STATISTICALSRC"];
    quesInfoM.IMPORTLEVEL      = [dic objectForKey:@"IMPORTLEVEL"];
    quesInfoM.ISEXPERTANSWER   = [dic objectForKey:@"ISEXPERTANSWER"];
    quesInfoM.ISSOLVE          = [dic objectForKey:@"ISSOLVE"];
    quesInfoM.SYSCREATEDATE    = [dic objectForKey:@"SYSCREATEDATE"];
    quesInfoM.ANSWERSUM        = [dic objectForKey:@"ANSWERSUM"];
    quesInfoM.NICKNAME         = [dic objectForKey:@"NICKNAME"];
    quesInfoM.HEADIMAGE        = [[[dic objectForKey:@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    quesInfoM.FILEURL          = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];

    NSArray * urlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
    [imageUrlArr removeObjectAtIndex:0];
    quesInfoM.FILEURLARR = imageUrlArr;
    
    return quesInfoM;
}

@end
