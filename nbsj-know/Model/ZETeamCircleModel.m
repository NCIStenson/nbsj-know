//
//  ZETeamCircleModel.m
//  nbsj-know
//
//  Created by Stenson on 17/3/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamCircleModel.h"

static ZETeamCircleModel * teamCircleInfo = nil;

@implementation ZETeamCircleModel

+(ZETeamCircleModel *)getDetailWithDic:(NSDictionary *)dic
{
    teamCircleInfo = [[ZETeamCircleModel alloc]init];
    
    teamCircleInfo.SEQKEY         = [dic objectForKey:@"SEQKEY"];
    teamCircleInfo.TEAMCIRCLECODE  = [dic objectForKey:@"TEAMCIRCLECODE"];
    teamCircleInfo.TEAMCIRCLECODENAME  = [dic objectForKey:@"TEAMCIRCLECODENAME"];
    teamCircleInfo.TEAMCIRCLENAME    = [dic objectForKey:@"TEAMCIRCLENAME"];
    teamCircleInfo.TEAMCIRCLEREMARK = [dic objectForKey:@"TEAMCIRCLEREMARK"];
    teamCircleInfo.TEAMMANIFESTO = [dic objectForKey:@"TEAMMANIFESTO"];
    teamCircleInfo.FILEURL        = [[[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return teamCircleInfo;
}

@end
