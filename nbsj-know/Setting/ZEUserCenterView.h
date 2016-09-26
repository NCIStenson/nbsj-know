//
//  ZEUserCenterView.h
//  NewCentury
//
//  Created by Stenson on 16/4/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEUserCenterView;

@protocol ZEUserCenterViewDelegate <NSObject>

/************** 我的问题  ****************/
-(void)goMyQuestionList;
/************** 我的回答列表  ****************/
-(void)goMyAnswerList;
/************** 个人信息设置列表 ****************/
-(void)goSettingVC;

@end

@interface ZEUserCenterView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <ZEUserCenterViewDelegate> delegate;


@end
