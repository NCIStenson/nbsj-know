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

@end

@interface ZEPersonalNotiView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <ZEPersonalNotiViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadFirstView:(NSArray *)arr;

@end
