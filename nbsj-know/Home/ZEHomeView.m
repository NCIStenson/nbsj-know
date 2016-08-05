//
//  ZEHomeView.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#define kHomeMarkFontSize       16.0f
#define kHomeTitleFontSize      kTiltlFontSize
#define kHomeSubTitleFontSize   kSubTiltlFontSize

#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH
#define kNavBarHeight       64.0f

#define kSearchTFMarginLeft   25.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 50.0f
#define kSearchTFHeight       30.0f

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   kNavBarHeight
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - kNavBarHeight - 49.0f

#import "ZEHomeView.h"

@interface ZEHomeView ()
{
    UITextField * searchTF;
    
    NSString * _questionStr;
}
@end

@implementation ZEHomeView


-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        _questionStr = @"变压器导管口有油滴渗出，但是导管并无破损，请问是什么原因？";
        [self initView];
    }
    return self;
}


-(void)initView
{
    [self initNavBar];
    [self initContentView];
    
}

-(void)initNavBar
{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectZero];
    navView.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:navView];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBarMarginTop);
        make.left.mas_equalTo(kNavBarMarginLeft);
        make.size.mas_equalTo(CGSizeMake(kNavBarWidth, kNavBarHeight));
    }];
    
    UIView * searchView = [self searchTextfieldView];
   
    [navView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSearchTFMarginTop);
        make.left.mas_equalTo(kSearchTFMarginLeft);
        make.size.mas_equalTo(CGSizeMake(kSearchTFWidth, kSearchTFHeight));
    }];
}
#pragma mark - 导航栏搜索界面

-(UIView *)searchTextfieldView
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    
    searchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    [searchTFView addSubview:searchTF];
    searchTF.placeholder = @"搜索你想知道的问题";
    [searchTF setReturnKeyType:UIReturnKeySearch];
    searchTF.font = [UIFont systemFontOfSize:14];
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    searchTF.delegate=self;

    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 2.0f;
    
    return searchTFView;
}

-(void)initContentView
{
    UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//    contentTableView.backgroundColor = [UIColor whiteColor];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableMarginLeft);
        make.top.mas_equalTo(kContentTableMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableWidth, kContentTableHeight));
    }];
    
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 110;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_TITLE_ANSWER) {
       
        float questionHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        UIImage * img = [UIImage imageNamed:@"banner.jpg"];
        float questionImgH =  ( SCREEN_WIDTH - 40 ) / img.size.width * img.size.height;
        
       return questionHeight + questionImgH + 50.0f;
  
    }else if (indexPath.section == SECTION_TITLE_EXPERT){
        
        float questionHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        UIImage * img = [UIImage imageNamed:@"banner.jpg"];
        float questionImgH =  ( SCREEN_WIDTH - 40 ) / img.size.width * img.size.height;
        
        return questionHeight + questionImgH + 50.0f;
    }else{
        
        UIImage * img = [UIImage imageNamed:@"banner.jpg"];
        float questionImgH =  ( ( SCREEN_WIDTH - 40) / 2 - 10.0f   ) / img.size.width * img.size.height;
 
        float caseContH = [ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:(SCREEN_WIDTH - 40) / 2 ];

        if (caseContH > questionImgH) {
            return caseContH + 30.0f;
        }
        
        return questionImgH + 30.0f;
    }
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = [UIColor whiteColor];
    if (section == SECTION_TITLE_ANSWER) {
        [self initSignInView:sectionView];
        UIView * sectionTitleV = [self createSectionTitleView:SECTION_TITLE_ANSWER];
        sectionTitleV.frame = CGRectMake(0, 70, SCREEN_WIDTH, 40);
        [sectionView addSubview:sectionTitleV];
    }else{
        UIView * sectionTitleV = [self createSectionTitleView:section];
        [sectionView addSubview:sectionTitleV];
    }
    
    return sectionView;
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
    
    if (indexPath.section == SECTION_TITLE_ANSWER) {
        [cell.contentView addSubview:[self createAnswerView]];
    }else if (indexPath.section == SECTION_TITLE_EXPERT){
        [cell.contentView addSubview:[self createAnswerView]];
    }else{
        [cell.contentView addSubview:[self creatCaseView]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithIndexPath:)]){
        [self.delegate goQuestionDetailVCWithIndexPath:indexPath];
    }
}



#pragma mark - 回答问题
-(UIView *)createAnswerView
{
    UIView *  questionsView = [[UIView alloc]init];
    
    float questionHeight =[ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * questionsLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, questionHeight)];
    questionsLab.numberOfLines = 0;
    questionsLab.text = _questionStr;
    questionsLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
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
    usernameLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
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

#pragma mark - 签到界面

-(void)initSignInView:(UIView *)fView
{
//    CALayer * grayLine = [CALayer layer];
//    grayLine.frame = CGRectMake(0, 50, SCREEN_WIDTH, 10);
//    [singInView.layer addSublayer:grayLine];
//    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];

    UIButton * singInView = [UIButton buttonWithType:UIButtonTypeCustom];
    singInView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    singInView.backgroundColor = [UIColor whiteColor];
    [singInView addTarget:self action:@selector(goSingInView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 200, 20)];
    titleLable.userInteractionEnabled = NO;
    titleLable.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    titleLable.attributedText = [self getAttrText:@"已连续签到 4 天"];
    [singInView addSubview:titleLable];
    
    UILabel * subTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 200, 20)];
    subTitleLable.userInteractionEnabled = NO;
    subTitleLable.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    subTitleLable.attributedText = [self getAttrText:@"您已帮助了 1 位员工"];
    [singInView addSubview:subTitleLable];
    
    UILabel * goSignInLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 70, 50)];
    goSignInLab.text = @"去签到 >";
    goSignInLab.textColor = MAIN_NAV_COLOR;
    goSignInLab.userInteractionEnabled = NO;

    goSignInLab.textAlignment = NSTextAlignmentRight;
    goSignInLab.font = [UIFont systemFontOfSize:14];
    [singInView addSubview:goSignInLab];
    
    CALayer * grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, 60, SCREEN_WIDTH, 10);
    [singInView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    [fView addSubview:singInView];
}

-(NSMutableAttributedString *)getAttrText:(NSString * )titleText
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleText];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont boldSystemFontOfSize:16.0]
     
                          range:NSMakeRange(0, 8)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(0, 8)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:kHomeTitleFontSize]
     
                          range:NSMakeRange(0, 5)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor blackColor]
     
                          range:NSMakeRange(0, 5)];
    
    return AttributedStr;
}

#pragma mark -  区头文字

-(UIView * )createSectionTitleView:(SECTION_TITLE)sectionType
{
    UIButton * sectionTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionTitleBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    sectionTitleBtn.backgroundColor = [UIColor whiteColor];
    [sectionTitleBtn addTarget:self action:@selector(goMoreQuesVC:) forControlEvents:UIControlEventTouchUpInside];
    [sectionTitleBtn setTag:sectionType];
    
    UIImageView * sectionIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 18, 20)];
    sectionIcon.userInteractionEnabled = NO;
    [sectionTitleBtn addSubview:sectionIcon];
    
    UILabel * sectionTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
    sectionTitleLab.userInteractionEnabled = NO;
    switch (sectionType) {
        case SECTION_TITLE_ANSWER:
            sectionIcon.image = [UIImage imageNamed:@"forum_list_post.png"];
            sectionTitleLab.text = @"您来解答";
            break;
        case SECTION_TITLE_EXPERT:
            sectionIcon.image = [UIImage imageNamed:@"forum_list_post.png"];
            sectionTitleLab.text = @"专家解答";
            break;
        case SECTION_TITLE_CASE:
            sectionIcon.image = [UIImage imageNamed:@"forum_list_post.png"];
            sectionTitleLab.text = @"典型案例";
            break;
            
        default:
            break;
    }
    sectionTitleLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    [sectionTitleBtn addSubview:sectionTitleLab];
    
    UILabel * sectionSubTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 40)];
    sectionSubTitleLab.text = @"查看更多>>>";
    sectionSubTitleLab.userInteractionEnabled = NO;
    sectionSubTitleLab.textAlignment = NSTextAlignmentRight;
    sectionSubTitleLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    [sectionTitleBtn addSubview:sectionSubTitleLab];
    
    return sectionTitleBtn;
}

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - ZEHomeViewDelegate

-(void)goSingInView
{
    if ([self.delegate respondsToSelector:@selector(goSinginView)]) {
        [self.delegate goSinginView];
    }
}

-(void)goMoreQuesVC:(UIButton *)button
{
    switch (button.tag) {
        case SECTION_TITLE_ANSWER:
        {
            if([self.delegate respondsToSelector:@selector(goMoreQuestionsView)]){
                [self.delegate goMoreQuestionsView];
            }
        }
            break;
        case SECTION_TITLE_EXPERT:
        {
            if([self.delegate respondsToSelector:@selector(goMoreExpertAnswerView)]){
                [self.delegate goMoreExpertAnswerView];
            }
        }
            break;
        case SECTION_TITLE_CASE:
        {
            if([self.delegate respondsToSelector:@selector(goMoreCaseAnswerView)]){
                [self.delegate goMoreCaseAnswerView];
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
