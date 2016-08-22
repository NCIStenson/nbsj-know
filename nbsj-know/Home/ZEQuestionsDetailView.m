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
#import "ZEAnswerInfoModel.h"

@interface ZEQuestionsDetailView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * contentTableView;
}

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,strong) ZEQuestionTypeModel * questionTypeModel;

@property (nonatomic,strong) NSArray * answerInfoArr;

@end

@implementation ZEQuestionsDetailView

-(id)initWithFrame:(CGRect)frame
  withQuestionInfo:(ZEQuestionInfoModel *)infoModel
  withQuestionType:(ZEQuestionTypeModel *)typeModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _questionInfoModel = infoModel;
        _questionTypeModel = typeModel;
        [self initView];
    }
    return self;
}

-(void)initView
{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableViewMarginLeft);
        make.top.mas_equalTo(kContentTableViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableViewWidth, kContentTableViewHeight));
    }];
    
}

-(void)reloadData:(NSArray *)arr
{
    _answerInfoArr = arr;
    [contentTableView reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _answerInfoArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
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
    questionsView.backgroundColor = [UIColor cyanColor];
    float questionHeight =[ZEUtil heightForString:_questionInfoModel.QUESTIONEXPLAIN font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * questionsLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    questionsLab.numberOfLines = 0;
    questionsLab.text = _questionInfoModel.QUESTIONEXPLAIN;
    questionsLab.font = [UIFont systemFontOfSize:kDetailMarkFontSize];
    [questionsView addSubview:questionsLab];
    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    //    if () {
//    UIImage * img = [UIImage imageNamed:@"banner.jpg"];
//    float questionImgH =  ( SCREEN_WIDTH - 40 ) / img.size.width * img.size.height;
//    
//    UIImageView * questionImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, SCREEN_WIDTH - 40, questionImgH)];
//    questionImg.image = img;
//    questionImg.contentMode = UIViewContentModeScaleAspectFit;
//    [questionsView addSubview:questionImg];
//    userY += questionImgH + 10.0f;
    //    }
    
    
//    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
//    userImg.image = [UIImage imageNamed:@"avatar_default.jpg"];
//    [questionsView addSubview:userImg];
//    userImg.clipsToBounds = YES;
//    userImg.layer.cornerRadius = 10;
    
    NSLog(@">>>  %@",_questionInfoModel.SYSCREATEDATE);
    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(20,userY,100.0f,20.0f)];
    usernameLab.text = [ZEUtil compareCurrentTime:_questionInfoModel.SYSCREATEDATE];
    usernameLab.textColor = MAIN_SUBTITLE_COLOR;
    usernameLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [questionsView addSubview:usernameLab];
    
    float praiseNumWidth = [ZEUtil widthForString:@"10 回答" font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text = @"10 回答";
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    
    // 圈组分类最右边
    float circleTypeR = SCREEN_WIDTH - praiseNumWidth - 30;
    float circleWidth = [ZEUtil widthForString:_questionTypeModel.QUESTIONTYPENAME font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(circleTypeR - circleWidth - 20.0f, userY + 2.0f, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"rateTa.png"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,circleWidth,20.0f)];
    circleLab.text = _questionTypeModel.QUESTIONTYPENAME;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, questionHeight + 50.0f, SCREEN_WIDTH, 10.0f);
    [lineLayer setBackgroundColor:[MAIN_LINE_COLOR CGColor]];
    [questionsView.layer addSublayer:lineLayer];
    
    return questionsView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float questionHeight =[ZEUtil heightForString:_questionInfoModel.QUESTIONEXPLAIN font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    return questionHeight + 60.0f;
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
    
    [self initCellContentView:cell.contentView withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[indexPath.row]];

    float answerHeight =[ZEUtil heightForString:answerInfoM.ANSWEREXPLAIN font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 65];
    
    return answerHeight + 65.0f;
}

-(void)initCellContentView:(UIView *)cellContentView withIndexPath:(NSIndexPath *)indexPath
{
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[indexPath.row]];
    
    UIButton * userImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userImageBtn.frame = CGRectMake(20, 5, 200, 30);
    userImageBtn.backgroundColor = [UIColor clearColor];
    [userImageBtn addTarget:self action:@selector(showUserMessage) forControlEvents:UIControlEventTouchUpInside];
    [cellContentView addSubview:userImageBtn];
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    userImg.userInteractionEnabled = YES;
    userImg.image = [UIImage imageNamed:@"avatar_default.jpg"];
    [userImageBtn addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 15;
    
    UILabel * ANSWERUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(35,0,100.0f,30.0f)];
    ANSWERUSERNAME.text = answerInfoM.ANSWERUSERNAME;
    ANSWERUSERNAME.userInteractionEnabled = YES;
    ANSWERUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    ANSWERUSERNAME.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [userImageBtn addSubview:ANSWERUSERNAME];
    
    float answerHeight =[ZEUtil heightForString:answerInfoM.ANSWEREXPLAIN font:[UIFont systemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 65];
    
    UILabel * ANSWEREXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(55, 35, SCREEN_WIDTH - 65, answerHeight)];
    ANSWEREXPLAIN.numberOfLines = 0;
    ANSWEREXPLAIN.text = answerInfoM.ANSWEREXPLAIN;
    ANSWEREXPLAIN.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [cellContentView addSubview:ANSWEREXPLAIN];
    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(55,answerHeight + 40.0f,100.0f,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:answerInfoM.SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [cellContentView addSubview:SYSCREATEDATE];

    float praiseNumWidth = [ZEUtil widthForString:answerInfoM.GOODNUMS font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * praiseImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 40, answerHeight + 40.0f, 15, 15)];
    praiseImg.image = [UIImage imageNamed:@"qb_praiseBtn_hand@2x.png"];
    [cellContentView addSubview:praiseImg];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,answerHeight + 40.0f,praiseNumWidth,20.0f)];
    praiseNumLab.text = answerInfoM.GOODNUMS;
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellContentView addSubview:praiseNumLab];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        return;
    }
    
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[indexPath.row]];
    if ([self.delegate respondsToSelector:@selector(acceptTheAnswerWithQuestionInfo:withAnswerInfo:)]) {
        [self.delegate acceptTheAnswerWithQuestionInfo:_questionInfoModel withAnswerInfo:answerInfoM];
    }
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
