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
#import "ZEButton.h"

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
        return 2;
    }
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    contentLabel.textColor = kTextColor;
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(45, 43.5f, SCREEN_WIDTH - 45.0f, 0.5f);
    [cell.contentView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    if (indexPath.section == 1) {
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
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            logoImageView.image = [UIImage imageNamed:@"icon_setting.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"设置";
        }else if(indexPath.row == 1){
            logoImageView.image = [UIImage imageNamed:@"icon_phone.png" color:MAIN_NAV_COLOR];
            contentLabel.text = @"客服";
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0f;
    }
    return 300.0f + 100.0f;
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
    userHEAD.center = CGPointMake(SCREEN_WIDTH / 2, 150.0f);
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
    float usernameWidth = [ZEUtil widthForString:username font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH - 60, 20)];
    
    UILabel * usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - usernameWidth ) / 2, 60, usernameWidth, 20.0f)];
    usernameLabel.text = username;
    usernameLabel.font = [UIFont boldSystemFontOfSize:18];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    [userMessage addSubview:usernameLabel];
    
    UIImageView * sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    sexImage.center = CGPointMake(usernameLabel.center.x + usernameWidth / 2 + 10.0f, usernameLabel.center.y );
    sexImage.image = [UIImage imageNamed:@"boy"];
    [userMessage addSubview:sexImage];
    
    grayView.frame = CGRectMake(0, 244, SCREEN_WIDTH, 10);
    [userMessage addSubview:grayView];
    
    ZEButton * personalMsgBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
    personalMsgBtn.frame = CGRectMake(0, 220, SCREEN_WIDTH / 2, 60.0f);
    personalMsgBtn.backgroundColor = MAIN_NAV_COLOR;
    [userMessage addSubview:personalMsgBtn];
    [personalMsgBtn setTitle:@"个人信息" forState:UIControlStateNormal];
    [personalMsgBtn setImage:[UIImage imageNamed:@"icon_person_msg"] forState:UIControlStateNormal];
    personalMsgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [personalMsgBtn addTarget:self action:@selector(goSettingVC) forControlEvents:UIControlEventTouchUpInside];
    personalMsgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    ZEButton * signInBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
    signInBtn.frame = CGRectMake(SCREEN_WIDTH / 2, 220, SCREEN_WIDTH / 2, 60.0f);
    [userMessage addSubview:signInBtn];
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signInBtn setImage:[UIImage imageNamed:@"icon_signin"] forState:UIControlStateNormal];
    signInBtn.backgroundColor = MAIN_NAV_COLOR;
    [signInBtn addTarget:self action:@selector(goSinginVC) forControlEvents:UIControlEventTouchUpInside];
    signInBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 30, 25, 25.0f);
    [userMessage addSubview:setBtn];
    [setBtn setImage:[UIImage imageNamed:@"icon_setting_up" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    setBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    setBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    
    UIView * _dashView= [[UIView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH / 2, 220, 1, 40.0f)];
    [userMessage addSubview:_dashView];
    
    [ZEUtil drawDashLine:_dashView lineLength:3 lineSpacing:2 lineColor:[UIColor whiteColor]];

    for (int i = 0; i < 3; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(0 + SCREEN_WIDTH / 3 * i, 290, SCREEN_WIDTH / 3, 100);
        [userMessage addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = 100 + i;
        UIView * lineLayer = [UIView new];
        lineLayer.frame = CGRectMake( optionBtn.frame.size.width - 1, 0, 1.0f, 100);
        [optionBtn addSubview:lineLayer];
        lineLayer.backgroundColor = MAIN_LINE_COLOR;
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"icon_my_question"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"我的问题" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"icon_my_answer"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"我的回答" forState:UIControlStateNormal];
                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"icon_my_circle"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"我的圈子" forState:UIControlStateNormal];
                break;

            default:
                break;
        }
    
    }
    
    
    UIView * spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 290 + 100.0f, SCREEN_WIDTH , 10)];
    spaceView.backgroundColor = MAIN_LINE_COLOR ;
    [userMessage addSubview: spaceView];
    
    return userMessage;
}

-(void)didSelectMyOption:(UIButton *)btn
{
    switch (btn.tag - 100) {
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

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
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
            
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if ([self.delegate respondsToSelector:@selector(goSettingVC:)]) {
                        [self.delegate goSettingVC:ENTER_SETTING_TYPE_SETTING];
                    }
                }
                    break;
                    
                case 1:
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:0571-123456"]];
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
