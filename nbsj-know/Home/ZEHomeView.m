//
//  ZEHomeView.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

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
#define kContentTableMarginTop   kNavBarHeight + 70.0f
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - kNavBarHeight - 49.0f - 70.0f

#import "ZEHomeView.h"

@interface ZEHomeView ()
{
    UITextField * searchTF;
    UILabel * signinLab;
    UILabel * goSignInLab;
    NSString * _questionStr;
    
    UITableView * contentTableView;
    
    BOOL isSignin;
}

@property (nonatomic,strong) NSMutableArray * newestQuestionArr;
@property (nonatomic,strong) NSMutableArray * expertQuestionArr;
@property (nonatomic,strong) NSMutableArray * caseQuestionArr;

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
    [self initSignInView:self];
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

#pragma mark - 签到界面

-(void)initSignInView:(UIView *)fView
{
    UIButton * singInView = [UIButton buttonWithType:UIButtonTypeCustom];
    singInView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
    singInView.backgroundColor = [UIColor whiteColor];
    [singInView addTarget:self action:@selector(goSingInView) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70.0f);
    [singInView.layer addSublayer:layer];
    
    signinLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 200, 20)];
    signinLab.userInteractionEnabled = NO;
    signinLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    signinLab.text = @"今日未签到";
    [singInView addSubview:signinLab];
    
    UILabel * subTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 200, 20)];
    subTitleLable.userInteractionEnabled = NO;
    subTitleLable.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    subTitleLable.attributedText = [self getAttrText:@"您已帮助了 1 位员工"];
    [singInView addSubview:subTitleLable];
    
    goSignInLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 70, 50)];
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
    
    if (isSignin) {
        signinLab.text = @"今日已签到";
        goSignInLab.text = @"去看看 >";
    }
}


-(void)initContentView
{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.showsVerticalScrollIndicator = NO;
    
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableMarginLeft);
        make.top.mas_equalTo(kContentTableMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableWidth, kContentTableHeight));
    }];
    
}

#pragma mark - Public Method

-(void)reloadSigninedView
{
    isSignin = YES;
    signinLab.text = @"今日已签到";
    goSignInLab.text = @"去看看 >";
}

-(void)reloadSection:(NSInteger)section withData:(NSArray *)arr
{
    switch (section) {
        case SECTION_TITLE_ANSWER:
            self.newestQuestionArr = [NSMutableArray arrayWithArray:arr];
            break;
        case SECTION_TITLE_EXPERT:
            self.expertQuestionArr = [NSMutableArray arrayWithArray:arr];
            break;
        case SECTION_TITLE_CASE:
            self.caseQuestionArr = [NSMutableArray arrayWithArray:arr];
            break;
        default:
            break;
    }
    
    [contentTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_TITLE_ANSWER:
            return  self.newestQuestionArr.count;
            break;
        case SECTION_TITLE_EXPERT:
            return  self.expertQuestionArr.count;
            break;
        case SECTION_TITLE_CASE:
            return  self.caseQuestionArr.count;
            break;
        default:
            break;
    }

    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != SECTION_TITLE_ANSWER){
        return 60;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    if (indexPath.section == SECTION_TITLE_ANSWER) {
        datasDic = self.newestQuestionArr[indexPath.row];
    }else if(indexPath.section == SECTION_TITLE_EXPERT){
        datasDic = self.expertQuestionArr[indexPath.row];
    }else{
        datasDic = self.caseQuestionArr[indexPath.row];
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;

    if (indexPath.section == SECTION_TITLE_ANSWER) {
       
        float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
            return questionHeight + kCellImgaeHeight + 60.0f;
        }
       return questionHeight + 50.0f;
  
    }else if (indexPath.section == SECTION_TITLE_EXPERT){
        
        float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
            return questionHeight + 60.0f + kCellImgaeHeight;
        }
        return questionHeight + 50.0f;
    }else{
        
        UIImage * img = [UIImage imageNamed:@"banner.jpg"];
        float questionImgH =  ( ( SCREEN_WIDTH - 40) / 2 - 10.0f   ) / img.size.width * img.size.height;
 
        float caseContH = [ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:(SCREEN_WIDTH - 40) / 2 ];

        if (caseContH > questionImgH) {
            return caseContH + 30.0f;
        }
        
        return questionImgH + 30.0f;
    }
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 40.0f, SCREEN_WIDTH, 10);
    [sectionView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    

    
    UIView * sectionTitleV = [self createSectionTitleView:section];
    [sectionView addSubview:sectionTitleV];
    
    if(section != SECTION_TITLE_ANSWER){
        sectionTitleV.frame = CGRectMake(0, 10, 0, 0);
        lineLayer.frame = CGRectMake(0, 50.0f, SCREEN_WIDTH, 10);

        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        [sectionView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
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
        [cell.contentView addSubview:[self createAnswerView:SECTION_TITLE_ANSWER withIndexpath:indexPath]];
    }else if (indexPath.section == SECTION_TITLE_EXPERT){
        [cell.contentView addSubview:[self createAnswerView:SECTION_TITLE_EXPERT withIndexpath:indexPath]];
    }else{
        [cell.contentView addSubview:[self creatCaseView:indexPath]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    if (indexPath.section == SECTION_TITLE_ANSWER) {
        datasDic = self.newestQuestionArr[indexPath.row];
    }else if(indexPath.section == SECTION_TITLE_EXPERT){
        datasDic = self.expertQuestionArr[indexPath.row];
    }else{
        datasDic = self.caseQuestionArr[indexPath.row];
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    ZEQuestionTypeModel * questionTypeM = nil;
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.SEQKEY isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:withQuestionType:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:quesInfoM withQuestionType:questionTypeM];
    }
}



#pragma mark - 回答问题
-(UIView *)createAnswerView:(SECTION_TITLE)section withIndexpath:(NSIndexPath *)indexpath
{
    NSDictionary * datasDic = nil;
    if (section == SECTION_TITLE_ANSWER) {
        datasDic = self.newestQuestionArr[indexpath.row];
    }else{
        datasDic = self.expertQuestionArr[indexpath.row];
    }
    UIView *  questionsView = [[UIView alloc]init];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONEXPLAIN];
    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    NSArray * imgFileUrlArr;
    
    if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
        imgFileUrlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
    }
    
    for (int i = 0; i < imgFileUrlArr.count; i ++) {
        UIButton * questionImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        questionImageBtn.frame = CGRectMake(20 + (kCellImgaeHeight + 10) * i, userY, kCellImgaeHeight, kCellImgaeHeight);
        questionImageBtn.tag = i;
        questionImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [questionImageBtn  sd_setImageWithURL:ZENITH_IMAGEURL(imgFileUrlArr[i]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        
        [questionsView addSubview:questionImageBtn];
        questionImageBtn.clipsToBounds = YES;
        
        if (i == imgFileUrlArr.count - 1) {
            userY += kCellImgaeHeight + 10.0f;
        }
    }
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [questionsView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
    QUESTIONUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    QUESTIONUSERNAME.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONUSERNAME];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[quesInfoM.ANSWERSUM integerValue]];

    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text  = praiseNumLabText;
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    ZEQuestionTypeModel * questionTypeM = nil;
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.SEQKEY isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
    // 圈组分类最右边
    float circleTypeR = SCREEN_WIDTH - praiseNumWidth - 30;
    
    float circleWidth = [ZEUtil widthForString:questionTypeM.QUESTIONTYPENAME font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(circleTypeR - circleWidth - 20.0f, userY + 2.0f, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"rateTa.png"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,circleWidth,20.0f)];
    circleLab.text = questionTypeM.QUESTIONTYPENAME;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    
    return questionsView;
}

-(UIView *)creatCaseView:(NSIndexPath *)indexpath
{
    NSDictionary * datasDic = nil;
    datasDic = self.caseQuestionArr[indexpath.row];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    UIView *  caseView = [[UIView alloc]init];

    UIImage * img = [UIImage imageNamed:@"banner.jpg"];
    float questionImgH =  ( ( SCREEN_WIDTH - 40) / 2 - 10.0f   ) / img.size.width * img.size.height;
    
    UIImageView * questionImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH - 40) / 2 , questionImgH)];
   
    NSArray * imgFileUrlArr;

    if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
        imgFileUrlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
    }

    if (imgFileUrlArr.count > 0) {
        [questionImg sd_setImageWithURL:ZENITH_IMAGEURL(imgFileUrlArr[0]) placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }
    questionImg.contentMode = UIViewContentModeScaleAspectFit;
    [caseView addSubview:questionImg];
    
    float caseContH = [ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:(SCREEN_WIDTH - 40) / 2 ];
    
    UILabel * caseContentLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2 + 20.0f ,10,(SCREEN_WIDTH - 40) / 2 ,caseContH)];
    caseContentLab.text = QUESTIONEXPLAINStr;
    caseContentLab.numberOfLines = 0;
    caseContentLab.textColor = MAIN_SUBTITLE_COLOR;
    caseContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [caseView addSubview:caseContentLab];

    return caseView;
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
