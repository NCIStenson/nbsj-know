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
    UIButton * userHEAD;
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

-(void)reloadHeaderB
{
    [userHEAD sd_setImageWithURL:ZENITH_IMAGEURL([ZESettingLocalData getUSERHHEADURL]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
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
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(45, 43.5f, SCREEN_WIDTH - 45.0f, 0.5f);
    [cell.contentView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            logoImageView.image = [UIImage imageNamed:@"question_icon" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的提问";
        }else if(indexPath.row == 1){
            logoImageView.image = [UIImage imageNamed:@"askTa.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的回答";
        }else if(indexPath.row == 2){
            logoImageView.image = [UIImage imageNamed:@"tab_circle.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的圈子";
        }else if(indexPath.row == 3){
            logoImageView.image = [UIImage imageNamed:@"detail_nav_star.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"我的收藏";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
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
    return 254.0f;
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
    
    userHEAD = [UIButton buttonWithType:UIButtonTypeCustom];
    userHEAD.frame =CGRectMake(0, 0, 100, 100);
    userHEAD.center = CGPointMake(SCREEN_WIDTH / 2, 95.0f);
    [userHEAD sd_setImageWithURL:ZENITH_IMAGEURL([ZESettingLocalData getUSERHHEADURL]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [userMessage addSubview:userHEAD];
    [userHEAD addTarget:self action:@selector(goChooseImage) forControlEvents:UIControlEventTouchUpInside];
    userMessage.contentMode = UIViewContentModeScaleAspectFit;
    userHEAD.backgroundColor =[UIColor redColor];
    userHEAD.clipsToBounds = YES;
    userHEAD.layer.cornerRadius = userHEAD.frame.size.height / 2;
    userHEAD.layer.borderColor = [MAIN_LINE_COLOR CGColor];
    userHEAD.layer.borderWidth = 2;
    
//    UILabel * lvLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 10)];
//    lvLabel.center = CGPointMake(SCREEN_WIDTH / 2 + 30.0f, 138.0f);
//    lvLabel.text = @"Lv 2";
//    lvLabel.alpha = .9f;
//    lvLabel.font = [UIFont systemFontOfSize:8.0f];
//    lvLabel.textAlignment = NSTextAlignmentCenter;
//    lvLabel.textColor = [UIColor redColor];
//    lvLabel.clipsToBounds = YES;
//    lvLabel.layer.cornerRadius = lvLabel.frame.size.height / 2;
//
//    lvLabel.backgroundColor = [UIColor yellowColor];
//    [userMessage addSubview:lvLabel];
    
    NSString * username = [ZESettingLocalData getNICKNAME];
    if (![ZEUtil isStrNotEmpty:username]) {
        username = [ZESettingLocalData getNAME];
    }
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
    
    grayView.frame = CGRectMake(0, 244, SCREEN_WIDTH, 10);
    [userMessage addSubview:grayView];
    
    UIButton * personalMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalMsgBtn.frame = CGRectMake(0, 200, SCREEN_WIDTH / 2, 44.0f);
    [userMessage addSubview:personalMsgBtn];
    [personalMsgBtn setTitle:@"  个人信息" forState:UIControlStateNormal];
    personalMsgBtn.backgroundColor = [UIColor whiteColor];
    [personalMsgBtn setImage:[UIImage imageNamed:@"myTab_userInfo"] forState:UIControlStateNormal];
    personalMsgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [personalMsgBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [personalMsgBtn addTarget:self action:@selector(goSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    signInBtn.frame = CGRectMake(SCREEN_WIDTH / 2, 200, SCREEN_WIDTH / 2, 44.0f);
    [userMessage addSubview:signInBtn];
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [signInBtn setTitle:@"  签到" forState:UIControlStateNormal];
    [signInBtn setImage:[UIImage imageNamed:@"myTab_singin"] forState:UIControlStateNormal];
    signInBtn.backgroundColor = [UIColor whiteColor];
    [signInBtn addTarget:self action:@selector(goSinginVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(SCREEN_WIDTH / 2 - 0.5f, 200.0f, 1.0f, 44.0f);
    [userMessage.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
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
                    if ([self.delegate respondsToSelector:@selector(goMyQuestionList)]) {
                        [self.delegate goMyQuestionList];
                    }
                    break;
                case 1:
                    if ([self.delegate respondsToSelector:@selector(goMyAnswerList)]) {
                        [self.delegate goMyAnswerList];
                    }
                    break;
                case 2:
                    if ([self.delegate respondsToSelector:@selector(goMyGroup)]) {
                        [self.delegate goMyGroup];
                    }
                    break;
                case 3:
                    if ([self.delegate respondsToSelector:@selector(goMyCollect)]) {
                        [self.delegate goMyCollect];
                    }
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
                    if ([self.delegate respondsToSelector:@selector(goSettingVC:)]) {
                        [self.delegate goSettingVC:ENTER_SETTING_TYPE_SETTING];
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

-(void)goSinginVC
{
    if ([self.delegate respondsToSelector:@selector(goSinginVC)]) {
        [self.delegate goSinginVC];
    }
}

-(void)goSettingVC
{
    if ([self.delegate respondsToSelector:@selector(goSettingVC:)]) {
        [self.delegate goSettingVC:ENTER_SETTING_TYPE_PERSONAL];
    }
}

-(void)goChooseImage{
    if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [self.delegate takePhotosOrChoosePictures];
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
