//
//  ZEQuestionsDetailView.m
//  nbsj-know
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kDetailMarkFontSize       16.0f
#define kDetailTitleFontSize      kTiltlFontSize
#define kDetailSubTitleFontSize   kSubTiltlFontSize

#define kContentTableViewMarginLeft 0.0f
#define kContentTableViewMarginTop  NAV_HEIGHT
#define kContentTableViewWidth      SCREEN_WIDTH
#define kContentTableViewHeight     SCREEN_HEIGHT - NAV_HEIGHT

#import "ZEQuestionsDetailView.h"

@interface ZEQuestionsDetailView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _questionStr;
}
@end

@implementation ZEQuestionsDetailView

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
    _questionStr = @"UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];";
    UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTableView.backgroundColor = [UIColor cyanColor];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableViewMarginLeft);
        make.top.mas_equalTo(kContentTableViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableViewWidth, kContentTableViewHeight));
    }];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    headerView.backgroundColor = [UIColor redColor];
    
    [headerView addSubview:[self createQuestionDetailView]];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)createQuestionDetailView
{
    UIView *  questionsView = [[UIView alloc]init];
    
    float questionHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * questionsLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, questionHeight)];
    questionsLab.numberOfLines = 0;
    questionsLab.text = _questionStr;
    questionsLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [questionsView addSubview:questionsLab];
    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 15.0f;
    
    //    if () {
    UIImage * img = [UIImage imageNamed:@"banner.jpg"];
    float questionImgH =  ( SCREEN_WIDTH - 40 ) / img.size.width * img.size.height;
    
    UIImageView * questionImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, SCREEN_WIDTH - 40, questionImgH)];
    questionImg.image = img;
    questionImg.contentMode = UIViewContentModeScaleAspectFit;
    [questionsView addSubview:questionImg];
    userY += questionImgH + 10.0f;
    //    }
    
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    userImg.image = [UIImage imageNamed:@"avatar_default.jpg"];
    [questionsView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    usernameLab.text = @"test1";
    usernameLab.textColor = MAIN_SUBTITLE_COLOR;
    usernameLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [questionsView addSubview:usernameLab];
    
    float praiseNumWidth = [ZEUtil widthForString:@"10 回答" font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    //    UIImageView * praiseImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 30, userY + 2.0f, 15, 15)];
    //    praiseImg.image = [UIImage imageNamed:@"qb_praiseBtn_hand@2x.png"];
    //    [questionsView addSubview:praiseImg];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text = @"10 回答";
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    
    // 圈组分类最右边
    float circleTypeR = SCREEN_WIDTH - praiseNumWidth - 30;
    float circleWidth = [ZEUtil widthForString:@"高压用电检查" font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(circleTypeR - circleWidth - 20.0f, userY + 2.0f, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"rateTa.png"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,circleWidth,20.0f)];
    circleLab.text = @"高压用电检查";
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    
    return questionsView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 280;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        UIView * lastView = cell.contentView.subviews.lastObject;
        [lastView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initCellContentView:cell.contentView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float answerHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    return answerHeight + 55;
}

-(void)initCellContentView:(UIView *)cellContentView
{
    UIButton * userImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userImageBtn.frame = CGRectMake(20, 5, 200, 20);
    userImageBtn.backgroundColor = [UIColor clearColor];
    [userImageBtn addTarget:self action:@selector(showUserMessage) forControlEvents:UIControlEventTouchUpInside];
    [cellContentView addSubview:userImageBtn];
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    userImg.userInteractionEnabled = YES;
    userImg.image = [UIImage imageNamed:@"avatar_default.jpg"];
    [userImageBtn addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(25,0,100.0f,20.0f)];
    usernameLab.text = @"test2";
    usernameLab.userInteractionEnabled = YES;
    usernameLab.textColor = MAIN_SUBTITLE_COLOR;
    usernameLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [userImageBtn addSubview:usernameLab];
    
    
    float answerHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * questionsLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 40, answerHeight)];
    questionsLab.numberOfLines = 0;
    questionsLab.text = _questionStr;
    questionsLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [cellContentView addSubview:questionsLab];
    
    UILabel * timeLab = [[UILabel alloc]initWithFrame:CGRectMake(20,answerHeight + 35.0f,100.0f,20.0f)];
    timeLab.text = [ZEUtil compareCurrentTime:@"2016-07-28 17:08:50"];
    timeLab.userInteractionEnabled = YES;
    timeLab.textColor = MAIN_SUBTITLE_COLOR;
    timeLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [cellContentView addSubview:timeLab];

    float praiseNumWidth = [ZEUtil widthForString:@"1000" font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * praiseImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 40, answerHeight + 35.0f, 15, 15)];
    praiseImg.image = [UIImage imageNamed:@"qb_praiseBtn_hand@2x.png"];
    [cellContentView addSubview:praiseImg];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,answerHeight + 35.0f,praiseNumWidth,20.0f)];
    praiseNumLab.text = @"1000";
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellContentView addSubview:praiseNumLab];

}

#pragma mark - ZEQuestionsDetailViewDelegate

-(void)showUserMessage
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
