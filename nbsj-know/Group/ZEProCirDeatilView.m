//
//  ZEProCirDeatilView.m
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kDynamicsHeight  80.0f
#define kMemberHeight  30.0f

#import "ZEProCirDeatilView.h"

@interface ZEProCirDeatilView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZEProCirDeatilView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    UITableView * contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 121;
    }else if (indexPath.row == 1){
        return 3 * kDynamicsHeight;
    }
    return 11 * kMemberHeight + 40 ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    while (cell.contentView.subviews.lastObject) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    [self initCellView:cell.contentView indexPath:indexPath];
    return cell;
}


-(void)initCellView:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    if (indexpath.row == 0) {
        [self initCircleMessage:superView indexPath:indexpath];
    }else if (indexpath.row == 1){
        [self initNewestCircleDynamics:superView indexPath:indexpath];
    }else{
        [self initMember:superView indexPath:indexpath];
    }
}

-(void)initCircleMessage:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    rowTitleLab.text = @"圈子成绩";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 40, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    CALayer * sLineLayer = [CALayer layer];
    sLineLayer.frame = CGRectMake(0, 120, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:sLineLayer];
    sLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    UILabel * rankingTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 80, 40)];
    rankingTitleLab.text = @"圈子排名\n1";
    rankingTitleLab.numberOfLines = 0;
    rankingTitleLab.textAlignment = NSTextAlignmentCenter;
    rankingTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rankingTitleLab];
    
    UILabel * secondRowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, 80, 30)];
    secondRowTitleLab.text = @"圈子动态";
    secondRowTitleLab.textAlignment = NSTextAlignmentCenter;
    secondRowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:secondRowTitleLab];
    secondRowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);

    CALayer * detailLineLayer = [CALayer layer];
    detailLineLayer.frame = CGRectMake(80, 80,(SCREEN_WIDTH - 80) / 5 * 3, 1);
    [superView.layer addSublayer:detailLineLayer];
    detailLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    
    for (int i = 0; i < 3; i ++ ) {
        UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * i, 40, (SCREEN_WIDTH - 80) / 5, 40)];
        detailLab.textAlignment = NSTextAlignmentCenter;
        detailLab.font = [UIFont systemFontOfSize:13];
        [superView addSubview:detailLab];
        
        CALayer * detailLineLayer = [CALayer layer];
        detailLineLayer.frame = CGRectMake(80+ (SCREEN_WIDTH - 80) / 5 * i, 40, 1, 80);
        [superView.layer addSublayer:detailLineLayer];
        detailLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

        if (i == 2) {
            CALayer * lastLineLayer = [CALayer layer];
            lastLineLayer.frame = CGRectMake(80+ (SCREEN_WIDTH - 80) / 5 * 3, 40, 1, 80);
            [superView.layer addSublayer:lastLineLayer];
            lastLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        }
        
        UILabel * detailContentLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * i, 80, (SCREEN_WIDTH - 80) / 5, 40)];
        detailContentLab.text = @"1234";
        detailContentLab.textAlignment = NSTextAlignmentCenter;
        detailContentLab.font = [UIFont systemFontOfSize:12];
        [superView addSubview:detailContentLab];
        
        switch (i) {
            case 0:
                detailLab.text = @"回答数";
                detailContentLab.text = @"1234";
                break;
            case 1:
                detailLab.text = @"采纳数";
                detailContentLab.text = @"1234";
                break;
            case 2:
                detailLab.text = @"团队积分";
                detailContentLab.text = @"1234";
                break;

                
            default:
                break;
        }
    }
    
    UILabel * currentRankingLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 3, 40, (SCREEN_WIDTH - 80) / 5, 80)];
    currentRankingLab.text = @"本\n月\n成\n绩";
    currentRankingLab.numberOfLines = 0;
    currentRankingLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    currentRankingLab.textAlignment = NSTextAlignmentCenter;
    currentRankingLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:currentRankingLab];
    
    
    UILabel * sumAnswerLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 4, 40, (SCREEN_WIDTH - 80) / 5, 40)];
    sumAnswerLab.text = @"回答数\n1999";
    sumAnswerLab.numberOfLines = 0;
    sumAnswerLab.textAlignment = NSTextAlignmentCenter;
    sumAnswerLab.font = [UIFont systemFontOfSize:13];
    [superView addSubview:sumAnswerLab];
    
    CALayer * sumLineLayer = [CALayer layer];
    sumLineLayer.frame = CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 4, 80, (SCREEN_WIDTH - 80) / 5, 1);
    [superView.layer addSublayer:sumLineLayer];
    sumLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * sumAdoptLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 4, 80, (SCREEN_WIDTH - 80) / 5, 40)];
    sumAdoptLab.text = @"采纳数\n1999";
    sumAdoptLab.numberOfLines = 0;
    sumAdoptLab.textAlignment = NSTextAlignmentCenter;
    sumAdoptLab.font = [UIFont systemFontOfSize:13];
    [superView addSubview:sumAdoptLab];

}

-(void)initNewestCircleDynamics:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    for (int i = 0; i < 3;  i ++) {
        
        CALayer * sumLineLayer = [CALayer layer];
        sumLineLayer.frame = CGRectMake(0, kDynamicsHeight * (i + 1), SCREEN_WIDTH, 1);
        [superView.layer addSublayer:sumLineLayer];
        sumLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

        CALayer * vLineLayer = [CALayer layer];
        vLineLayer.frame = CGRectMake(80, kDynamicsHeight * i, 1, kDynamicsHeight);
        [superView.layer addSublayer:vLineLayer];
        vLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

        
        UILabel * timeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, kDynamicsHeight * i , 80, kDynamicsHeight)];
        timeTitleLab.text = @"10分钟前";
        timeTitleLab.textAlignment = NSTextAlignmentCenter;
        timeTitleLab.font = [UIFont systemFontOfSize:14];
        [superView addSubview:timeTitleLab];

    }
}

-(void)initMember:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    rowTitleLab.text = @"团队成员";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];

    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 40, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    CALayer * fLineLayer = [CALayer layer];
    fLineLayer.frame = CGRectMake(40, 40, 1, kMemberHeight * 11);
    [superView.layer addSublayer:fLineLayer];
    fLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    CALayer * sLineLayer = [CALayer layer];
    sLineLayer.frame = CGRectMake(40 + (SCREEN_WIDTH - 40) / 3 , 40, 1, kMemberHeight * 11);
    [superView.layer addSublayer:sLineLayer];
    sLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    CALayer * tLineLayer = [CALayer layer];
    tLineLayer.frame = CGRectMake(40 + (SCREEN_WIDTH - 40) / 3 * 2, 40, 1, kMemberHeight * 11);
    [superView.layer addSublayer:tLineLayer];
    tLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    
    for (int i = 0; i < 11;  i ++) {
        
        CALayer * sumLineLayer = [CALayer layer];
        sumLineLayer.frame = CGRectMake(0, 40 + kMemberHeight * (i + 1), SCREEN_WIDTH, 1);
        [superView.layer addSublayer:sumLineLayer];
        sumLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        
        UILabel * timeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,40 + kMemberHeight * i , 40, kMemberHeight)];
        timeTitleLab.text = [NSString stringWithFormat:@"%dth",i];
        timeTitleLab.textAlignment = NSTextAlignmentCenter;
        timeTitleLab.font = [UIFont systemFontOfSize:14];
        [superView addSubview:timeTitleLab];
        
        if (i == 0) {
            timeTitleLab.text = @"排名";
        }else if (i == 1){
            timeTitleLab.text = @"1st";
        }else if (i == 2){
            timeTitleLab.text = @"2nd";
        }else if (i == 3){
            timeTitleLab.text = @"3rd";
        }
        
        for (int j = 0; j < 3; j ++ ) {
            UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(40 + (SCREEN_WIDTH - 40) / 3 * j, 40 + kMemberHeight * i , (SCREEN_WIDTH - 40) / 3, kMemberHeight)];
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.font = [UIFont systemFontOfSize:14];
            [superView addSubview:contentLab];
            
            if(i == 0){
                switch (j) {
                    case 0:
                        contentLab.text = @"姓名";
                        break;
                    case 1:
                        contentLab.text = @"月度个人积分";
                        break;
                    case 2:
                        contentLab.text = @"本月回答";
                        break;
                    default:
                        break;
                }
            }else{
                
            }
        }
        
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
