//
//  ZEHomeView.h
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

typedef NS_ENUM (NSInteger,SECTION_TITLE){
    SECTION_TITLE_ANSWER = 0,
    SECTION_TITLE_EXPERT = 1,
    SECTION_TITLE_CASE = 2
};

#import <UIKit/UIKit.h>

@class ZEHomeView;
@protocol ZEHomeViewDelegate <NSObject>

/**
 *  @author Stenson, 16-07-27 10:07:18
 *
 *  去签到
 */
-(void)goSinginView;
/**
 *  @author Stenson, 16-07-27 10:07:18
 *
 *  去经典案例详情
 */
-(void)goTypicalDetail:(NSDictionary *)detailDic;

/**
 *  @author Stenson, 16-07-29 09:07:17
 *
 *  更多问题
 */
-(void)goMoreQuestionsView;
/**
 *  @author Stenson, 16-07-29 09:07:46
 *
 *  更多专家解答
 */
-(void)goMoreExpertAnswerView;

/**
 *  @author Stenson, 16-07-29 09:07:16
 *
 *  更多典型案例
 */
-(void)goMoreCaseAnswerView;

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;



/**
 加载新数据
 */
-(void)loadNewData;
/**
 搜索

 @param str 
 */
-(void)goSearch:(NSString *)str;

@end

@interface ZEHomeView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) id <ZEHomeViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

/**** 已经签到过界面 ***/
-(void)reloadSigninedViewDay:(NSString *)dayStr numbers:(NSString *)number;

-(void)reloadSection:(NSInteger)section withData:(NSArray *)arr;

-(void)reloadSectionView:(NSArray *)data;

-(void)hiddenSinginView;

@end
