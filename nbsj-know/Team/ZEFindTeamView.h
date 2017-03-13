//
//  ZEFindTeamView.h
//  nbsj-know
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZEFindTeamCell : UITableViewCell


- (void)reloadCellView:(NSDictionary *)dic;

@property (nonatomic,strong) UIView * baseView;

@end

@interface ZEFindTeamView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * contentTableView;
}

@property (nonatomic,strong) NSMutableArray * teamsDataArr;
-(void)reloadFindTeamView:(NSArray *)dataArr;

@end
