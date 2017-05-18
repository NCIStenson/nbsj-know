//
//  ZEPersonalNotiView.h
//  nbsj-know
//
//  Created by Stenson on 17/5/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZETeamNotiCenModel.h"

@class ZEPersonalNotiView;

@protocol ZEPersonalNotiViewDelegate <NSObject>

-(void)didSelectTeamMessage:(ZETeamNotiCenModel *)notiModel;

-(void)didSelectQuestionMessage:(ZETeamNotiCenModel *)notiModel;

/**
 *  刷新界面
 */
-(void)loadNewData;

/**
 *  加载更多数据
 */
-(void)loadMoreData;


/**
 删除数据

 @param notiModel 
 */
-(void)didSelectDeleteBtn:(ZETeamNotiCenModel *)notiModel;

@end

@interface ZEPersonalNotiView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <ZEPersonalNotiViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;

@end
