//
//  ZETeamView.h
//  nbsj-know
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZETeamView;

@protocol ZETeamViewDelegate <NSObject>

-(void)goFindTeamVC;

@end

@interface ZETeamViewHeaderView: UIView

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,weak) ZETeamView * teamView;

@end

@interface ZETeamView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id <ZETeamViewDelegate> delegate;

@end

