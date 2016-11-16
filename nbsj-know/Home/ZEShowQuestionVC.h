//
//  ZEQuestionVC.h
//  nbsj-know
//
//  Created by Stenson on 16/7/28.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEShowQuestionView.h"

@interface ZEShowQuestionVC : ZESettingRootVC

@property (nonatomic,assign) QUESTION_LIST showQuestionListType;

@property (nonatomic,copy) NSString * QUESTIONTYPENAME;
@property (nonatomic,copy) NSString * typeSEQKEY;

@property (nonatomic,copy) NSString * currentInputStr;

@end
