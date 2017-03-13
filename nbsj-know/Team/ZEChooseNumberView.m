//
//  ZEChooseNumberView.m
//  nbsj-know
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChooseNumberView.h"

@implementation ZEChooseNumberView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alreadyInviteNumbersArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}
-(void)initView
{
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
}

#pragma mark - Public Method

-(void)reloadViewWithAlreadyInviteNumbers:(NSArray *)arr
{
    [self.alreadyInviteNumbersArr addObjectsFromArray:arr];
    self.maskArr = [NSMutableArray array];
    for (int i = 0 ; i < self.alreadyInviteNumbersArr.count; i++) {
        [self.maskArr addObject:[NSString stringWithFormat:@"%@",@"0"]];
    }
    [contentView reloadData];
}

#pragma mark - 表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alreadyInviteNumbersArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * IDCell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (!cell ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic: self.alreadyInviteNumbersArr[indexPath.row]];
    UIImageView * headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 45, 45)];
    [cell.contentView addSubview:headerImageView];
    [headerImageView sd_setImageWithURL:ZENITH_IMAGEURL(userinfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    
    UILabel * numberName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, SCREEN_WIDTH - 120, 20)];
    numberName.text = userinfo.USERNAME;
    [numberName setTextColor:kTextColor];
    numberName.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:numberName];
    
    UILabel * numberCode = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH - 120, 20)];
    numberCode.text = userinfo.USERCODE;
    [numberCode setTextColor:kTextColor];
    numberCode.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:numberCode];
    
    if ([self.maskArr[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    UIButton * stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    stateBtn.frame = CGRectMake(SCREEN_WIDTH - 100 , 10 , 80, 40);
//    [stateBtn  setTitle:@"邀请加入" forState:UIControlStateNormal];
//    [cell.contentView addSubview:stateBtn];
//    stateBtn.backgroundColor = MAIN_NAV_COLOR_A(0.9);
//    //    [stateBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
//    stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    stateBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
//    stateBtn.titleLabel.numberOfLines = 0;
//    stateBtn.clipsToBounds = YES;
//    stateBtn.layer.cornerRadius = 5;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.maskArr[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.maskArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.maskArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
}



@end
