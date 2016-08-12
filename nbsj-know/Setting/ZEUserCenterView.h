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


-(void)goSettingVC;

@end

@interface ZEUserCenterView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <ZEUserCenterViewDelegate> delegate;


@end
