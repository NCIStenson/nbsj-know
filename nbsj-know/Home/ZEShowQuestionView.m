//
//  ZEQuestionsView.m
//  nbsj-know
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kQuestionMarkFontSize       16.0f
#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   0.0f
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - NAV_HEIGHT

#import "ZEShowQuestionView.h"

@interface ZEShowQuestionView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UITextField * _questionSearchTF;
    NSString * _questionStr;
}

@end

@implementation ZEShowQuestionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _questionStr = @"/Users/Stenson/Xcode/zenith/nbsj-know/nbsj-know/Home/ZEHomeVC.m:18:17: Method 'goMoreExpertAnswerView' in protocol 'ZEHomeViewDelegate' not implemented";
        [self initContentTableView];
    }
    return self;
}

-(void)initContentTableView
{
    UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableMarginLeft);
        make.top.mas_equalTo(kContentTableMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableWidth, kContentTableHeight));
    }];
    
}


-(UIView *)searchTextfieldView
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    
    _questionSearchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    [searchTFView addSubview:_questionSearchTF];
    _questionSearchTF.placeholder = @"关键词筛选";
    [_questionSearchTF setReturnKeyType:UIReturnKeySearch];
    _questionSearchTF.font = [UIFont systemFontOfSize:14];
    _questionSearchTF.leftViewMode = UITextFieldViewModeAlways;
    _questionSearchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _questionSearchTF.delegate=self;
    
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 2.0f;
    
    return searchTFView;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        float questionHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        UIImage * img = [UIImage imageNamed:@"banner.jpg"];
        float questionImgH =  ( SCREEN_WIDTH - 40 ) / img.size.width * img.size.height;
        
        return questionHeight + questionImgH + 50.0f;
    
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * searchBackView = [[UIView alloc]initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, 50)];
    searchBackView.backgroundColor = MAIN_LINE_COLOR;
    
    UIView * searchTF = [self searchTextfieldView];
    searchTF.frame = CGRectMake(25, 10, SCREEN_WIDTH - 50, 30);
    [searchBackView addSubview:searchTF];
    [self addSubview:searchBackView];
    
    
    return searchBackView;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.contentView addSubview:[self createAnswerView]];
    
    return cell;
}


#pragma mark - 回答问题
-(UIView *)createAnswerView
{
    UIView *  questionsView = [[UIView alloc]init];
    
    float questionHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * questionsLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, questionHeight)];
    questionsLab.numberOfLines = 0;
    questionsLab.text = _questionStr;
    questionsLab.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
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
    usernameLab.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
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

-(UIView *)creatCaseView
{
    UIView *  caseView = [[UIView alloc]init];
    
    UIImage * img = [UIImage imageNamed:@"banner.jpg"];
    float questionImgH =  ( ( SCREEN_WIDTH - 40) / 2 - 10.0f   ) / img.size.width * img.size.height;
    
    UIImageView * questionImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH - 40) / 2 , questionImgH)];
    questionImg.image = img;
    questionImg.contentMode = UIViewContentModeScaleAspectFit;
    [caseView addSubview:questionImg];
    
    float caseContH = [ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:(SCREEN_WIDTH - 40) / 2 ];
    
    UILabel * caseContentLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2 + 20.0f ,10,(SCREEN_WIDTH - 40) / 2 ,caseContH)];
    caseContentLab.text = _questionStr;
    caseContentLab.numberOfLines = 0;
    caseContentLab.textColor = MAIN_SUBTITLE_COLOR;
    caseContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [caseView addSubview:caseContentLab];
    
    return caseView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithIndexPath:)]) {
        [self.delegate goQuestionDetailVCWithIndexPath:indexPath];
    }
}

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_questionSearchTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - ZEQuestionsViewDelegate

-(void)goMoreQuesVC:(UIButton *)button
{
//    switch (button.tag) {
//        case QUESTION_SECTION_TYPE_RECOMMEND:
//        {
//            if ([self.delegate respondsToSelector:@selector(goMoreRecommend)]) {
//                [self.delegate goMoreRecommend];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
