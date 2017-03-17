//
//  ZEQuestionsDetailVC.h
//  nbsj-know
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZEQuestionsDetailVC : ZESettingRootVC

@property (nonatomic,assign) QUESTION_LIST enterQuestionDetailType;

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,strong) ZEQuestionTypeModel * questionTypeModel;

@end
