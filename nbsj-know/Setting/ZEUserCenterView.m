//
//  ZEUserCenterView.m
//  NewCentury
//
//  Created by Stenson on 16/4/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#define kUserTableMarginLeft    0.0f
#define kUserTableMarginTop     0.0f
#define kUserTableWidth   SCREEN_WIDTH
#define kUserTableHeight  SCREEN_HEIGHT - 49.0f

#import "UIImageView+WebCache.h"
#import "ZEUserCenterView.h"

@interface ZEUserCenterView ()
{
    UITableView * userCenterTable;
}

@end

@implementation ZEUserCenterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserCenterView];
    }
    return self;
}

-(void)initUserCenterView
{
    userCenterTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    userCenterTable.delegate = self;
    userCenterTable.dataSource = self;
    userCenterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:userCenterTable];
    userCenterTable.showsVerticalScrollIndicator = NO;
    [userCenterTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUserTableMarginLeft);
        make.top.mas_equalTo(kUserTableMarginLeft);
        make.size.mas_equalTo(CGSizeMake(kUserTableWidth, kUserTableHeight));
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSuccess) name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}

-(void)changeSuccess
{
    [userCenterTable reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [self initCellContentViewWithIndexPath:indexPath withCell:cell];
    
    return cell;
}

-(void)initCellContentViewWithIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [cell.contentView addSubview:logoImageView];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(45.0f, 0.0f, SCREEN_WIDTH - 65.0f, 44.0f)];
    [cell.contentView addSubview:contentLabel];
    contentLabel.userInteractionEnabled = YES;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(45, 43.5f, SCREEN_WIDTH - 45.0f, 0.5f);
            [cell.contentView.layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
            
            logoImageView.image = [UIImage imageNamed:@"question_icon" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的提问";
        }else{
            logoImageView.image = [UIImage imageNamed:@"askTa.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的回答";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(45, 43.5f, SCREEN_WIDTH - 45.0f, 0.5f);
            [cell.contentView.layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
            
            logoImageView.image = [UIImage imageNamed:@"loadCycle.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的圈子";
        }else{
            logoImageView.image = [UIImage imageNamed:@"my_center_seting.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"设置";
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0f;
    }
    return 210.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + 2, 20)];
    grayView.backgroundColor = MAIN_LINE_COLOR ;
    if (section == 1) {
        return grayView;
    }
    
    UIView * userMessage = [[UIView alloc]init];
    userMessage.backgroundColor = MAIN_NAV_COLOR;
    
    UIImageView * userHEAD = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    userHEAD.center = CGPointMake(SCREEN_WIDTH / 2, 95.0f);
    [userHEAD setImage:[UIImage imageNamed:@"avatar_default.jpg"]];
    [userMessage addSubview:userHEAD];
    userMessage.contentMode = UIViewContentModeScaleAspectFit;
    userHEAD.backgroundColor =[UIColor redColor];
    userHEAD.clipsToBounds = YES;
    userHEAD.layer.cornerRadius = userHEAD.frame.size.height / 2;
    userHEAD.layer.borderColor = [MAIN_LINE_COLOR CGColor];
    userHEAD.layer.borderWidth = 2;
    
    UILabel * lvLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 10)];
    lvLabel.center = CGPointMake(SCREEN_WIDTH / 2 + 30.0f, 138.0f);
    lvLabel.text = @"Lv 2";
    lvLabel.alpha = .9f;
    lvLabel.font = [UIFont systemFontOfSize:8.0f];
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.textColor = [UIColor redColor];
    lvLabel.clipsToBounds = YES;
    lvLabel.layer.cornerRadius = lvLabel.frame.size.height / 2;

    lvLabel.backgroundColor = [UIColor yellowColor];
    [userMessage addSubview:lvLabel];
    
    NSString * username = [ZESettingLocalData getNICKNAME];
    float usernameWidth = [ZEUtil widthForString:username font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREEN_WIDTH - 60, 20)];
    
    UILabel * usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - usernameWidth ) / 2, 155, usernameWidth, 20.0f)];
    usernameLabel.text = username;
    usernameLabel.font = [UIFont systemFontOfSize:16];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    [userMessage addSubview:usernameLabel];
    
    UIImageView * sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    sexImage.center = CGPointMake(usernameLabel.center.x + usernameWidth / 2 + 10.0f, usernameLabel.center.y );
    sexImage.image = [UIImage imageNamed:@"boy"];
    [userMessage addSubview:sexImage];
    
    grayView.frame = CGRectMake(0, 200, SCREEN_WIDTH, 10);
    [userMessage addSubview:grayView];
    
    return userMessage;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    if ([self.delegate respondsToSelector:@selector(goSettingVC)]) {
                        [self.delegate goSettingVC];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
