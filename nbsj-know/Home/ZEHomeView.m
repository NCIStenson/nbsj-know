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

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f + 16.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 0.0f
#define kLeftButtonMarginTop 20.0f + 2.0f

#define kSearchTFMarginLeft   70.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 100.0f
#define kSearchTFHeight       30.0f

#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   0.0f
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      135.0f

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   ( kNavBarHeight )
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - kContentTableMarginTop - 49.0f

#import "ZEHomeView.h"
#import "PYPhotoBrowser.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"

@interface ZEHomeView ()
{
    UITextField * searchTF;
    UILabel * signinLab;
    UILabel * subSigninLab;
    UILabel * goSignInLab;
    NSString * _questionStr;
    
    UITableView * contentTableView;
    
    BOOL isSignin;
}

@property (nonatomic,strong) NSMutableArray * newestQuestionArr;

@end

@implementation ZEHomeView


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
    [self initNavBar];
    [self initContentView];
//    [self initSignInView:self];
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
    
    UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    _typeBtn.backgroundColor = [UIColor clearColor];
    _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 16.0f, 0.0f, 0.0f);
    _typeBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_typeBtn setImage:[UIImage imageNamed:@"icon_back" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_typeBtn];
    
    
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
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65.0f);
    [singInView.layer addSublayer:layer];
    
    signinLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
    signinLab.userInteractionEnabled = NO;
    signinLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    signinLab.text = @"本月已签到 0 天";
    [singInView addSubview:signinLab];
    
    subSigninLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 200, 20)];
    subSigninLab.userInteractionEnabled = NO;
    subSigninLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    subSigninLab.attributedText = [self getAttrText:@"您已帮助了 0 位员工"];
    [singInView addSubview:subSigninLab];
    
    goSignInLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 70, 50)];
    goSignInLab.text = @"去签到 >";
    goSignInLab.textColor = MAIN_NAV_COLOR;
    goSignInLab.userInteractionEnabled = NO;
    
    goSignInLab.textAlignment = NSTextAlignmentRight;
    goSignInLab.font = [UIFont systemFontOfSize:14];
    [singInView addSubview:goSignInLab];
    
    UIView * grayLine = [[UIView alloc]init];
    grayLine.frame = CGRectMake(0, 60, SCREEN_WIDTH, 5);
    [singInView addSubview:grayLine];
    grayLine.backgroundColor = MAIN_LINE_COLOR;
    
    [fView addSubview:singInView];
    
    if (isSignin) {
        signinLab.text = @"今日已签到";
        goSignInLab.text = @"去看看 >";
    }
}

#pragma mark - 经典案例

-(UIView *)createTypicalCaseView
{
    UIView * typicalCaseView = [[UIView alloc]initWithFrame:CGRectMake(kTypicalViewMarginLeft, kTypicalViewMarginTop, kTypicalViewWidth, kTypicalViewHeight)];
    typicalCaseView.backgroundColor = [UIColor whiteColor];
    
//    UIView * newestComment = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5.0f, 30.0f)];
//    newestComment.backgroundColor = MAIN_NAV_COLOR_A(0.5);
//    [typicalCaseView addSubview:newestComment];
    
    UILabel * newestLab = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 0.0f, SCREEN_WIDTH - 100.0f, 30.0f)];
    newestLab.text = @"您来挑战";
    newestLab.numberOfLines = 0;
    newestLab.font = [UIFont systemFontOfSize:12];
    [typicalCaseView addSubview:newestLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 30);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [typicalCaseView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(goMoreQuesVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * headerLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30.0f, SCREEN_WIDTH, 5.0f)];
    [typicalCaseView addSubview:headerLineView];
    headerLineView.backgroundColor = MAIN_LINE_COLOR;
    
//    UIScrollView * typicalScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 20.0f, SCREEN_WIDTH - 20.0f, kTypicalViewHeight - 25.0f)];
//    typicalScrollView.showsHorizontalScrollIndicator = NO;
//    [typicalCaseView addSubview:typicalScrollView];
//    
//    for (int i = 0 ; i < self.caseQuestionArr.count; i ++ ) {
//        ZEKLB_CLASSICCASE_INFOModel * classicalCaseM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.caseQuestionArr[i]];
//        
//        UIButton * typicalImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        typicalImageBtn.frame = CGRectMake( (SCREEN_WIDTH - 20) / 3 * i , 0, (SCREEN_WIDTH - 20) / 3 - 10, kTypicalViewHeight - 55);
//        typicalImageBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
//        [typicalScrollView addSubview:typicalImageBtn];
//        [typicalImageBtn addTarget:self action:@selector(goTypicalCaseDetail:) forControlEvents:UIControlEventTouchUpInside];
//        typicalImageBtn.tag = i;
//        if ([ZEUtil isStrNotEmpty:classicalCaseM.FILEURL]) {
//            NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(classicalCaseM.FILEURL)] ;
//            [typicalImageBtn sd_setImageWithURL:fileURL forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
//        }
//        if (i == 3) {
//            typicalScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 20) / 3 * 4 - 10, kTypicalViewHeight - 55);
//        }
//        
//        UILabel * typicalLab = [[UILabel alloc]initWithFrame:CGRectMake(typicalImageBtn.frame.origin.x, typicalImageBtn.frame.origin.y + typicalImageBtn.frame.size.height, typicalImageBtn.frame.size.width, 15.0f)];
//        typicalLab.text = classicalCaseM.CASENAME;
//        typicalLab.numberOfLines = 0;
//        typicalLab.textAlignment = NSTextAlignmentCenter;
//        typicalLab.font = [UIFont systemFontOfSize:12];
//        [typicalScrollView addSubview:typicalLab];
//        
//        UIButton * browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        browseBtn.frame = CGRectMake(typicalImageBtn.frame.origin.x, typicalImageBtn.frame.origin.y + typicalImageBtn.frame.size.height + 15.0f, typicalImageBtn.frame.size.width, 15.0f);
//        browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [browseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        if (![ZEUtil isStrNotEmpty:classicalCaseM.CLICKCOUNT]) {
//            [browseBtn setTitle:@" 0" forState:UIControlStateNormal];
//        }else{
//            [browseBtn setTitle:[NSString stringWithFormat:@" %@",classicalCaseM.CLICKCOUNT] forState:UIControlStateNormal];
//        }
//        [browseBtn setImage:[UIImage imageNamed:@"discuss_pv.png" color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
//        [typicalScrollView addSubview:browseBtn];        
//    }
//    
//    CALayer * grayLine = [CALayer layer];
//    grayLine.frame = CGRectMake(0, kTypicalViewHeight - 5.0f, SCREEN_WIDTH, 5);
//    [typicalCaseView.layer addSublayer:grayLine];
//    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    return  typicalCaseView;
}

-(void)initContentView
{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];

    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.frame = CGRectMake(kContentTableMarginLeft, kContentTableMarginTop, kContentTableWidth, kContentTableHeight);
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    contentTableView.mj_header = header;
}



#pragma mark - Public Method

-(void)reloadSigninedViewDay:(NSString *)dayStr numbers:(NSString *)number
{
    isSignin = YES;
    signinLab.text = [NSString stringWithFormat:@"本月已签到%@天",dayStr];
    if ([dayStr integerValue] > 0){
        signinLab.attributedText = [self getAttrText:[NSString stringWithFormat:@"本月已签到 %@ 天",dayStr]];
    }
    if ([number integerValue] > 0){
        subSigninLab.attributedText = [self getAttrText:[NSString stringWithFormat:@"您已帮助了 %@ 位员工",number]];
    }
    goSignInLab.text = @"去看看 >";
}

-(void)reloadSectionwithData:(NSArray *)arr
{
    self.newestQuestionArr = [NSMutableArray arrayWithArray:arr];
    
    [contentTableView.mj_header endRefreshingWithCompletionBlock:nil];
    [contentTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(void)hiddenSinginView
{
    contentTableView.frame = CGRectMake(kContentTableMarginLeft, kContentTableMarginTop - 60.0, kContentTableWidth, kContentTableHeight + 60.0f);
    
    [signinLab.superview removeFromSuperview];
}
-(void)endRefreshing
{
    [contentTableView.mj_header endRefreshing];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.newestQuestionArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    datasDic = self.newestQuestionArr[indexPath.row];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;

    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    if(quesInfoM.FILEURLARR.count > 0){
        return questionHeight + kCellImgaeHeight + 85.0f;
    }
    return questionHeight + 75.0f;
  
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createTypicalCaseView];
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
    
    [cell.contentView addSubview:[self createAnswerViewWithIndexpath:indexPath]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    datasDic = self.newestQuestionArr[indexPath.row];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    ZEQuestionTypeModel * questionTypeM = nil;
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.CODE isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:withQuestionType:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:quesInfoM withQuestionType:questionTypeM];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

#pragma mark - 回答问题

-(UIView *)createAnswerViewWithIndexpath:(NSIndexPath *)indexpath
{
    NSDictionary * datasDic = nil;
    datasDic = self.newestQuestionArr[indexpath.row];
    UIView *  questionsView = [[UIView alloc]init];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont boldSystemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONEXPLAIN];
    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    for (int i = 0; i < quesInfoM.FILEURLARR.count; i ++) {
        UIButton * questionImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        questionImageBtn.userInteractionEnabled = YES;
        questionImageBtn.frame = CGRectMake(20 + (kCellImgaeHeight + 10) * i, userY, kCellImgaeHeight, kCellImgaeHeight);
        questionImageBtn.tag = indexpath.section * 10000000 + indexpath.row * 10000 + i;
        questionImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [questionImageBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        [questionImageBtn  sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.FILEURLARR[i]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        
        [questionsView addSubview:questionImageBtn];
        questionImageBtn.clipsToBounds = YES;
        
        if (i == quesInfoM.FILEURLARR.count - 1) {
            userY += kCellImgaeHeight + 10.0f;
        }
    }
    
    
    ZEQuestionTypeModel * questionTypeM = nil;
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.CODE isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
//     圈组分类最右边
    
    float circleWidth = [ZEUtil widthForString:questionTypeM.NAME font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, userY, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,circleWidth,15.0f)];
    circleLab.text = questionTypeM.NAME;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];

    userY += 20.0f;
    
    UIView * messageLineView = [[UIView alloc]initWithFrame:CGRectMake(0, userY, SCREEN_WIDTH, 0.5)];
    messageLineView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:messageLineView];
    
    userY += 5.0f;
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [questionsView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
    [QUESTIONUSERNAME sizeToFit];
    QUESTIONUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    QUESTIONUSERNAME.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONUSERNAME];
    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(QUESTIONUSERNAME.frame.origin.x + QUESTIONUSERNAME.frame.size.width + 5.0f,userY,100.0f,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:quesInfoM.SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = NO;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:12];
    [questionsView addSubview:SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;

    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[quesInfoM.ANSWERSUM integerValue]];

    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 70,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text  = praiseNumLabText;
    praiseNumLab.font = [UIFont boldSystemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    
    // 10 回答 | （图标）回答  分割线
    
    UIView * answerLineView = [[UIView alloc]initWithFrame:CGRectMake( praiseNumLab.frame.origin.x + praiseNumLab.frame.size.width + 5.0f , userY, 1.0f, 20.0f)];
    answerLineView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:answerLineView];
    
    
    UIButton * answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    answerBtn.frame = CGRectMake(SCREEN_WIDTH - 60 , userY, 50, 20);
    [answerBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [answerBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [answerBtn setTitle:@" 回答" forState:UIControlStateNormal];
    answerBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [questionsView addSubview:answerBtn];
    answerBtn.tag = indexpath.row;
    answerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [answerBtn addTarget:self action:@selector(answerQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 5.0f)];
    grayView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:grayView];
    
    questionsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 30.0f);
    
    return questionsView;
}

//-(UIView *)creatCaseView:(NSIndexPath *)indexpath
//{
//    NSDictionary * datasDic = nil;
//    datasDic = self.caseQuestionArr[indexpath.row];
//    
//    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
//    
//    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
//    
//    UIView *  caseView = [[UIView alloc]init];
//
//    UIImage * img = [UIImage imageNamed:@"banner.jpg"];
//    float questionImgH =  ( ( SCREEN_WIDTH - 40) / 2 - 10.0f   ) / img.size.width * img.size.height;
//    
//    UIImageView * questionImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH - 40) / 2 , questionImgH)];
//   
//    NSMutableArray * imgFileUrlArr;
//
//    if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
//        imgFileUrlArr = [NSMutableArray arrayWithArray:[quesInfoM.FILEURL componentsSeparatedByString:@","]];
//        [imgFileUrlArr removeObjectAtIndex:0];
//    }
//
//    if (imgFileUrlArr.count > 0) {
//        [questionImg sd_setImageWithURL:ZENITH_IMAGEURL(imgFileUrlArr[0]) placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
//    }
//    questionImg.contentMode = UIViewContentModeScaleAspectFit;
//    [caseView addSubview:questionImg];
//    
//    float caseContH = [ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kSubTiltlFontSize] andWidth:(SCREEN_WIDTH - 40) / 2 ];
//    
//    UILabel * caseContentLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2 + 20.0f ,10,(SCREEN_WIDTH - 40) / 2 ,caseContH)];
//    caseContentLab.text = QUESTIONEXPLAINStr;
//    caseContentLab.numberOfLines = 0;
//    caseContentLab.textColor = MAIN_SUBTITLE_COLOR;
//    caseContentLab.font = [UIFont boldSystemFontOfSize:kSubTiltlFontSize];
//    [caseView addSubview:caseContentLab];
//
//    return caseView;
//}

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

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
    return YES;
}


#pragma mark - ZEHomeViewDelegate

-(void)loadNewData
{
    if([self.delegate respondsToSelector:@selector(loadNewData)]){
        [self.delegate loadNewData];
    }
}

//-(void)goTypicalCaseDetail:(UIButton *)btn
//{
//    if([self.delegate respondsToSelector:@selector(goTypicalDetail:)]){
//        [self.delegate goTypicalDetail:self.newestQuestionArr[btn.tag]];
//    }
//}

-(void)goSingInView
{
    if ([self.delegate respondsToSelector:@selector(goSinginView)]) {
        [self.delegate goSinginView];
    }
}

-(void)goMoreQuesVC:(UIButton *)button
{
//    switch (button.tag) {
//        case SECTION_TITLE_ANSWER:
//        {
            if([self.delegate respondsToSelector:@selector(goMoreQuestionsView)]){
                [self.delegate goMoreQuestionsView];
            }
//        }
//            break;
//        case SECTION_TITLE_EXPERT:
//        {
//            if([self.delegate respondsToSelector:@selector(goMoreExpertAnswerView)]){
//                [self.delegate goMoreExpertAnswerView];
//            }
//        }
//            break;
//        case SECTION_TITLE_CASE:
//        {
//            if([self.delegate respondsToSelector:@selector(goMoreCaseAnswerView)]){
//                [self.delegate goMoreCaseAnswerView];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
}

//  分类图标点击

-(void)typeBtnClick
{
    if ([self.delegate respondsToSelector:@selector(goTypeQuestionVC)]) {
        [self.delegate goTypeQuestionVC];
    }
}


/**
 页面直接回答问题
 */
-(void)answerQuestion:(UIButton *)btn
{
    NSDictionary * datasDic = self.newestQuestionArr[btn.tag];

    ZEQuestionInfoModel * questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    if ([self.delegate respondsToSelector:@selector(goAnswerQuestionVC:)]) {
        [self.delegate goAnswerQuestionVC:questionInfoModel];
    }
    
}


-(void)showImage:(UIButton *)btn
{
    NSDictionary * datasDic = nil;
//    if (btn.tag / 10000000 == SECTION_TITLE_ANSWER) {
        datasDic = self.newestQuestionArr[btn.tag / 10000];
//    }else{
//        datasDic = self.expertQuestionArr[btn.tag / 10000];
//    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];

    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in quesInfoM.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    
    PYPhotoBrowseView *browser = [[PYPhotoBrowseView alloc] init];
    browser.imagesURL = urlsArr; // 图片总数
    browser.currentIndex = btn.tag % 10;
    [browser show];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
