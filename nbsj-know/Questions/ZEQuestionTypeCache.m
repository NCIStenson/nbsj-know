//
//  ZEQuestionTypeCache.m
//  nbsj-know
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionTypeCache.h"

@interface ZEQuestionTypeCache (){
    
}
@property (nonatomic,strong) NSArray * questionTypeArr;

@end

static ZEQuestionTypeCache * questionTypeCache = nil;
@implementation ZEQuestionTypeCache

-(id)initSingle
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(ZEQuestionTypeCache *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        questionTypeCache = [[ZEQuestionTypeCache alloc]initSingle];
    });
    return questionTypeCache;
}


/**
 *  存储用户第一次请求问题分类列表，APP运行期间 只请求一次问题分类列表
 */
- (void)setQuestionTypeCaches:(NSArray *)typeArr
{
    self.questionTypeArr = typeArr;
}
- (NSArray *)getQuestionTypeCaches
{
    return self.questionTypeArr;
}


- (void)clear
{
    self.questionTypeArr = nil;
}

@end
