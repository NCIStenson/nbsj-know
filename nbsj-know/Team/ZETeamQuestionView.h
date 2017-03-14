//
//  ZETeamQuestionView.h
//  nbsj-know
//
//  Created by Stenson on 17/3/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZETeamQuestionView;
@protocol ZETeamQuestionViewDelegate <NSObject>


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
 加载新最新数据
 */
-(void)loadNewData:(HOME_CONTENT)contentPage;

/**
 加载更多最新数据
 */
-(void)loadMoreData:(HOME_CONTENT)contentPage;

/**
 搜索
 
 @param str
 */
-(void)goSearch:(NSString *)str;


-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel;

@end

@interface ZETeamQuestionView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) id <ZETeamQuestionViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;


// 刷新 第一页 最新的问题数据
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

// 刷新 以后 最新的问题数据
-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

/**
 没有更多最新问题数据
 */
-(void)loadNoMoreDataWithHomeContent:(HOME_CONTENT)content_page;

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshingWithHomeContent:(HOME_CONTENT)content_page;

-(void)endRefreshingWithHomeContent:(HOME_CONTENT)content_page;

-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

@end
