//
//  ZEQuestionsView.h
//  nbsj-know
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
typedef NS_ENUM(NSInteger,QUESTION_SECTION_TYPE){
    QUESTION_SECTION_TYPE_RECOMMEND,
    QUESTION_SECTION_TYPE_NEWEST
};

@class ZEQuestionsView;

@protocol ZEQuestionsViewDelegate <NSObject>

/**
 *  @author Stenson, 16-07-29 16:07:10
 *
 *  更多推荐
 */
-(void)goMoreRecommend;
/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithIndexPath:(NSIndexPath *)indexPath;

@end

#import <UIKit/UIKit.h>

@interface ZEQuestionsView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) id <ZEQuestionsViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

@end
