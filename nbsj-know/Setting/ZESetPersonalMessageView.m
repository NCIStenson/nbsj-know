//
//  ZESetPersonalMessageView.m
//  nbsj-know
//
//  Created by Stenson on 16/8/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESetPersonalMessageView.h"

@interface ZESetPersonalMessageView ()
{
    UITableView * contentTable;
}

@end

@implementation ZESetPersonalMessageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    contentTable.backgroundColor = MAIN_LINE_COLOR;
    contentTable.delegate = self;
    contentTable.dataSource = self;
    [self addSubview:contentTable];
    contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSuccess) name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}

-(void)changeSuccess
{
    [contentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = MAIN_LINE_COLOR;
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [cell.contentView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"用户昵称";
                    cell.detailTextLabel.text = [ZESettingLocalData getNICKNAME];
                    break;
//                case 1:
//                    cell.textLabel.text = @"性别";
//                    cell.detailTextLabel.text = @"男";
//                    break;
                case 1:
                    cell.textLabel.text = @"当前等级";
                    cell.detailTextLabel.text = @"Lv 10";
                    cell.accessoryType = UITableViewCellAccessoryNone;
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
                    cell.textLabel.text = @"清除缓存";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"意见反馈";
                    break;
                case 2:
                    cell.textLabel.text = @"关于知道";
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
            cell.textLabel.text = @"退出登录";
            break;
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    if ([self.delegate respondsToSelector:@selector(changePersonalMsg:)]) {
                        [self.delegate changePersonalMsg:CHANGE_PERSONALMSG_NICKNAME];
                    }
                }
                    break;
                    
                case 1:{
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    
                }
                    break;

                case 1:{
                    if ([self.delegate respondsToSelector:@selector(changePersonalMsg:)]) {
                        [self.delegate changePersonalMsg:CHANGE_PERSONALMSG_ADVICE];
                    }
                }
                    break;

                case 2:{
                    
                }
                    break;

                default:
                    break;
            }
        }
            break;

        case 2:
            if ([self.delegate respondsToSelector:@selector(logout)]) {
                [self.delegate logout];
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
