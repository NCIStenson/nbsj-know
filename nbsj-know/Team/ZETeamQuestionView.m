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

#define kLabelScrollViewMarginTop     (64.0f + SCREEN_WIDTH / 4 )

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 15.0f
#define kLeftButtonMarginTop 20.0f + 2.0f

#define kSearchTFMarginLeft   70.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 90.0f
#define kSearchTFHeight       30.0f

#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   0.0f
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      135.0f

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   ( kLabelScrollViewMarginTop + 35.0f )
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      (SCREEN_HEIGHT - kContentTableMarginTop)

#import "ZETeamQuestionView.h"
#import "PYPhotoBrowser.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"
#import "ZEButton.h"


@interface ZETeamQuestionView ()
{
    UITextField * searchTF;
    
    UIView * optionView;  // 团队不同功能选项按钮
    
    UIScrollView * _labelScrollView;  // 展示出的分类名称
    UIScrollView * _contentScrollView; // 展示出的问题内容
    
    YYAnimatedImageView * gifImageView;  //  GIF 动态
    UIImageView * _lineImageView;
    
    NSArray * _allTypeArr;
    
    BOOL isSignin;
    
    float _historyY;
    
    NSInteger _currentHomeContentPage; // 当前显示的页面 0 你问我答 1 指定回答 2已采纳 3我的问题
}

@property (nonatomic,strong) NSMutableArray * newestQuestionArr; //   最新

@property (nonatomic,strong) NSMutableArray * targetQuestionArr;  //  你问我答

@property (nonatomic,strong) NSMutableArray * solvedQuestionArr;  //  已解决

@property (nonatomic,strong) NSMutableArray * myQuestionArr;  //  我的问题

@end

@implementation ZETeamQuestionView


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
    _allTypeArr = @[@"我来挑战",@"你问我答",@"已解决",@"我的问题"];
    
    _currentHomeContentPage = TEAM_CONTENT_NEWEST;
    
    [self initContentView];
    [self addSubview:[self createTypicalCaseView]];
}

#pragma mark - 经典案例

-(void)initOptionView
{
    optionView = [UIView new];
    [self addSubview:optionView];
    optionView.left = 0.0;
    optionView.top = NAV_HEIGHT;
    optionView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 4);
    
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(SCREEN_WIDTH / 4 * i, 0, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        [optionView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateSelected];

        
        UIView * lineLayer = [UIView new];
        lineLayer.frame = CGRectMake( optionBtn.frame.size.width - 1, 0, 1.0f, optionBtn.frame.size.height);
        [optionBtn addSubview:lineLayer];
        lineLayer.backgroundColor = MAIN_LINE_COLOR;
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_queAsk" color:MAIN_NAV_COLOR] forState:UIControlStateSelected];
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_queAsk"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"问一问" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_practice" color:MAIN_NAV_COLOR] forState:UIControlStateSelected];
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_practice"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"练一练" forState:UIControlStateNormal];
                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_ranking" color:MAIN_NAV_COLOR] forState:UIControlStateSelected];
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_ranking"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"比一比" forState:UIControlStateNormal];
                break;
            case 3:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_chat" color:MAIN_NAV_COLOR] forState:UIControlStateSelected];
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_chat"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        if (i == 0) {
            [optionBtn setSelected:YES];
        }
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, SCREEN_WIDTH / 4 - 1, SCREEN_WIDTH, 1);
    [optionView addSubview:lineView];
    lineView.backgroundColor = MAIN_LINE_COLOR;
}

-(UIView *)createTypicalCaseView
{
    _labelScrollView = [[UIScrollView alloc]init];
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.left = 0.0f;
    _labelScrollView.top = kLabelScrollViewMarginTop;
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.height = 35.0f;
    
    _lineImageView = [[UIImageView alloc]init];
    _lineImageView.frame = CGRectMake(0, 33.0f, SCREEN_WIDTH / _allTypeArr.count, 2.0f);
    _lineImageView.backgroundColor = MAIN_GREEN_COLOR;
    [_labelScrollView addSubview:_lineImageView];
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < _allTypeArr.count; i ++) {
        UIButton * labelContentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        labelContentBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [_labelScrollView addSubview:labelContentBtn];
        [labelContentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i == 0){
            [labelContentBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
        }
        labelContentBtn.top = 0.0f;
        labelContentBtn.height = 33.0f;
        [labelContentBtn setTitle:_allTypeArr[i] forState:UIControlStateNormal];
        [labelContentBtn addTarget:self action:@selector(selectDifferentType:) forControlEvents:UIControlEventTouchUpInside];
        labelContentBtn.tag = 100 + i;
        labelContentBtn.width = SCREEN_WIDTH / _allTypeArr.count;
        labelContentBtn.left = marginLeft;
        
        marginLeft += labelContentBtn.width;
    }
    
    
    return _labelScrollView;
}

-(void)initContentView
{

    [self initOptionView];
    
    _contentScrollView = [[UIScrollView alloc]init];
    [self addSubview:_contentScrollView];
    _contentScrollView.left = kContentTableMarginLeft;
    _contentScrollView.top = kContentTableMarginTop;
    _contentScrollView.size = CGSizeMake(kContentTableWidth, kContentTableHeight);
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _allTypeArr.count, kContentTableHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.contentOffset = CGPointMake(100, 100);
    
    for (int i = 0; i < _allTypeArr.count; i ++) {
        UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        [_contentScrollView addSubview:contentTableView];
        contentTableView.showsVerticalScrollIndicator = NO;
        contentTableView.frame = CGRectMake(kContentTableMarginLeft + SCREEN_WIDTH * i, 0, kContentTableWidth, kContentTableHeight);
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.tag = 100 + i;
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
        contentTableView.mj_header = header;
    }
}
#pragma mark - 选择不同选项 比一比 练一练等

-(void)didSelectMyOption:(UIButton *)btn
{
    if (btn.tag == 3) {
        if ([self.delegate respondsToSelector:@selector(goTeamChatRoom)]) {
            [self.delegate goTeamChatRoom];
        }
        return;
    }

    for (int i = 0; i < optionView.subviews.count - 1; i ++ ) {
        id obj = optionView.subviews[i];
        if ([obj isKindOfClass:[ZEButton class]]) {
            ZEButton * button = (ZEButton *) obj;
            if (i == btn.tag) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
        }
    }
    
    if (btn.tag == 0) {
        [self hiddenBuildingView];
    }else if(btn.tag == 1 || btn.tag == 2){
        [self showBuildingView:self];
    }
    
}

#pragma mark - 选择上方分类

-(void)selectDifferentType:(UIButton *)btn
{
    _currentHomeContentPage = btn.tag - 100;
    
    UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:btn.tag];
    [contentView reloadData];
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < _allTypeArr.count; i ++) {
        
        UIButton * button = [btn.superview viewWithTag:100 + i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //        float btnWidth = [ZEUtil widthForString:_allTypeArr[i] font:[UIFont systemFontOfSize:kTiltlFontSize] maxSize:CGSizeMake(SCREEN_WIDTH, 33.0f)] + 20.0f;
        float btnWidth = SCREEN_WIDTH / _allTypeArr.count;
        if (btn.tag - 100 == i) {
            [UIView animateWithDuration:0.35 animations:^{
                _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
                _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * i, 0);
            }];
        }
        marginLeft += btnWidth;
    }
    [btn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
}

#pragma mark - 显示建设中页面

-(void)showBuildingView:(UIView *)superView
{
    _labelScrollView.hidden = YES;
    _contentScrollView.hidden = YES;
    
    if (!gifImageView) {
        gifImageView = [YYAnimatedImageView new];
        [superView addSubview:gifImageView];
        gifImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        gifImageView.center = CGPointMake(superView.centerX, superView.centerY + 30);
        NSURL *path = [[NSBundle mainBundle]URLForResource:@"building" withExtension:@"gif"];
        gifImageView.imageURL = path;
        gifImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel * tipLab = [UILabel new];
        tipLab.frame = CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 40);
        tipLab.text = @"功能建设中,敬请期待!";
        tipLab.textColor = kTextColor;
        tipLab.font = [UIFont boldSystemFontOfSize:20];
        [gifImageView addSubview:tipLab];
        [tipLab setTextAlignment:NSTextAlignmentCenter];
        
        [superView sendSubviewToBack:tipLab];
        [superView sendSubviewToBack:gifImageView];
    }else{
        gifImageView.hidden = NO;
    }
}

-(void)hiddenBuildingView
{
    _labelScrollView.hidden = NO;
    _contentScrollView.hidden = NO;
    gifImageView.hidden = YES;
}


#pragma mark - Public Method

#pragma mark - 最新页面

/**
 刷新第一页面最新数据
 
 @param dataArr 数据内容
 */
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;
{
    UITableView * contentTableView;
    
    switch (content_page) {
        case TEAM_CONTENT_NEWEST:
            self.newestQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case TEAM_CONTENT_TARGETASK:
            self.targetQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case TEAM_CONTENT_SOLVED:
            self.solvedQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case TEAM_CONTENT_MYQUESTION:
            self.myQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        default:
            break;
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    contentTableView.mj_footer = footer;
    
    [contentTableView.mj_header endRefreshingWithCompletionBlock:nil];
    [contentTableView reloadData];
}
/**
 刷新其他页面最新数据
 
 @param dataArr 数据内容
 */

-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;
{
    UITableView * contentTableView;
    
    switch (content_page) {
        case TEAM_CONTENT_NEWEST:
            [self.newestQuestionArr addObjectsFromArray:dataArr];
            break;
        case TEAM_CONTENT_TARGETASK:
            [self.targetQuestionArr addObjectsFromArray:dataArr];
            break;
        case TEAM_CONTENT_SOLVED:
            [self.solvedQuestionArr addObjectsFromArray:dataArr];
            break;
        case TEAM_CONTENT_MYQUESTION:
            [self.myQuestionArr addObjectsFromArray:dataArr];
            break;
        default:
            break;
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    
    [contentTableView.mj_header endRefreshing];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView reloadData];
}
-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page
{
    
}
/**
 没有更多最新问题数据
 */
-(void)loadNoMoreDataWithHomeContent:(TEAM_CONTENT)content_page;
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_footer endRefreshingWithNoMoreData];
}

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshingWithHomeContent:(TEAM_CONTENT)content_page;
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_header endRefreshing];
}

-(void)endRefreshingWithHomeContent:(TEAM_CONTENT)content_page;
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView.mj_header endRefreshing];
}

-(void)scrollContentViewToIndex:(TEAM_CONTENT)toContent
{
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * toContent, 0);
//    _currentHomeContentPage = toContent;
    [self scrollViewDidEndDecelerating:_contentScrollView];
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            return self.newestQuestionArr.count;
            break;
            
        case TEAM_CONTENT_TARGETASK:
            return self.targetQuestionArr.count;
            break;
            
        case TEAM_CONTENT_SOLVED:
            return self.solvedQuestionArr.count;
            break;
            
        case TEAM_CONTENT_MYQUESTION:
            return self.myQuestionArr.count;
            break;
            
        default:
            break;
    }
    
    return  0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 35.0f;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * optionView = [[UIView alloc]initWithFrame:CGRectZero];
//    optionView.backgroundColor = [UIColor redColor];
//    return optionView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[indexPath.row];
            break;
         default:
            break;
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    if ([quesInfoM.BONUSPOINTS integerValue] > 0) {
        if (quesInfoM.BONUSPOINTS.length == 1) {
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"          %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 2){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"            %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 3){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"              %@",QUESTIONEXPLAINStr];
        }
    }
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    NSArray * typeCodeArr = [quesInfoM.QUESTIONTYPECODE componentsSeparatedByString:@","];
    
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    // 标签文字过多时会出现两行标签 动态计算标签高度
    float tagHeight = [ZEUtil heightForString:typeNameContent font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 70];
    
    NSString * targetUsernameStr = [NSString stringWithFormat:@"指定人员回答 ：%@",quesInfoM.TARGETUSERNAME];
    float targetUsernameHeight = [ZEUtil heightForString:targetUsernameStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    
    if(quesInfoM.FILEURLARR.count > 0){
        if(_currentHomeContentPage == TEAM_CONTENT_MYQUESTION && quesInfoM.TARGETUSERNAME.length > 0){
            return questionHeight + kCellImgaeHeight + tagHeight + 75.0f + targetUsernameHeight;
        }
        return questionHeight + kCellImgaeHeight + tagHeight + 70.0f;
    }
    
    if(_currentHomeContentPage == TEAM_CONTENT_MYQUESTION && quesInfoM.TARGETUSERNAME.length > 0){
        return questionHeight + tagHeight + 65.0f + targetUsernameHeight;
    }
    return questionHeight + tagHeight + 60.0f;
    
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
    [self createAnswerViewWithIndexpath:indexPath withView:cell.contentView] ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[indexPath.row];
            break;
        default:
            break;
    }
    
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

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];

    if ([scrollView isKindOfClass:[UITableView class]]) {
        _historyY = scrollView.contentOffset.y;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.contentOffset.y < _historyY) {
//            NSLog(@"down");
            if(optionView.hidden){
                [self showOptionView:scrollView];
            }
            
        } else if (scrollView.contentOffset.y > _historyY) {
//            NSLog(@"up >>  %d",optionView.hidden);
            if(!optionView.hidden){
                [self hiddenOptionView:scrollView];
            }
        }
    }
}

-(void)hiddenOptionView:(UIScrollView *)currentScrollView
{
    [UIView animateWithDuration:0.29 animations:^{
        optionView.alpha = 0.0;
        _labelScrollView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 35.0f);
        _contentScrollView.frame = CGRectMake(0, NAV_HEIGHT + 35.0f, SCREEN_WIDTH, SCREEN_HEIGHT - (NAV_HEIGHT + 35.0f));
        currentScrollView.frame = CGRectMake(currentScrollView.frame.origin.x, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (NAV_HEIGHT + 35.0f));
    } completion:^(BOOL finished) {
        optionView.hidden = YES;
    }];
}

-(void)showOptionView:(UIScrollView *)currentScrollView{
    [UIView animateWithDuration:0.29 animations:^{
        optionView.alpha = 1.0;
        _labelScrollView.frame = CGRectMake(0, kLabelScrollViewMarginTop, SCREEN_WIDTH, 35.0f);
        _contentScrollView.frame = CGRectMake(0, kContentTableMarginTop, SCREEN_WIDTH, kContentTableHeight);
        currentScrollView.frame = CGRectMake(currentScrollView.frame.origin.x, 0, SCREEN_WIDTH, kContentTableHeight);
    } completion:^(BOOL finished) {
        optionView.hidden = NO;
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentScrollView]) {
        
        NSInteger currentIndex = 0;
        
        currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        float marginLeft = 0;
        
        
        for (int i = 0 ; i < _allTypeArr.count; i ++) {
            
            UIButton * button = [_labelScrollView viewWithTag:100 + i];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            float btnWidth = SCREEN_WIDTH / _allTypeArr.count;
            
            if (currentIndex == i) {
                [UIView animateWithDuration:0.35 animations:^{
                    _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
                }];
                _currentHomeContentPage = i;
                UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentHomeContentPage];
                [contentView reloadData];
                
//                [self hiddenOptionView:contentView];

                [button setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
                
            }
            marginLeft += btnWidth;
        }
    }
    
}

#pragma mark - 回答问题

-(UIView *)createAnswerViewWithIndexpath:(NSIndexPath *)indexpath withView:(UIView *)questionsView
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexpath.row];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[indexpath.row];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[indexpath.row];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[indexpath.row];
            break;
        default:
            break;
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    if ([quesInfoM.BONUSPOINTS integerValue] > 0) {
        if (quesInfoM.BONUSPOINTS.length == 1) {
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"          %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 2){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"            %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 3){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"              %@",QUESTIONEXPLAINStr];
        }
        
        UIImageView * bonusImage = [[UIImageView alloc]init];
        [bonusImage setImage:[UIImage imageNamed:@"high_score_icon.png"]];
        [questionsView addSubview:bonusImage];
        bonusImage.left = 20.0f;
        bonusImage.top = 8.0f;
        bonusImage.width = 20.0f;
        bonusImage.height = 20.0f;
        
        UILabel * bonusPointLab = [[UILabel alloc]init];
        bonusPointLab.text = quesInfoM.BONUSPOINTS;
        [bonusPointLab setTextColor:MAIN_GREEN_COLOR];
        [questionsView addSubview:bonusPointLab];
        bonusPointLab.left = 43.0f;
        bonusPointLab.top = bonusImage.top;
        bonusPointLab.width = 27.0f;
        bonusPointLab.font = [UIFont boldSystemFontOfSize:kTiltlFontSize];
        bonusPointLab.height = 20.0f;
    }
    
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont boldSystemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONEXPLAIN];
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in quesInfoM.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    
    if (quesInfoM.FILEURLARR.count > 0) {
        PYPhotosView *linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr layoutType:PYPhotosViewLayoutTypeLine];
        // 设置Frame
        linePhotosView.py_y = userY;
        linePhotosView.py_x = PYMargin;
        linePhotosView.py_width = SCREEN_WIDTH - 40;
        
        // 3. 添加到指定视图中
        [questionsView addSubview:linePhotosView];
        
        userY += kCellImgaeHeight + 10.0f;
    }
    
    NSArray * typeCodeArr = [quesInfoM.QUESTIONTYPECODE componentsSeparatedByString:@","];
    
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    
    //     圈组分类最右边
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, userY, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,SCREEN_WIDTH - 70,15.0f)];
    circleLab.text = typeNameContent;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    circleLab.numberOfLines = 0;
    [circleLab sizeToFit];
    
    if (circleLab.height == 0) {
        circleLab.height = 15.0f;
    }
    
    userY += circleLab.height + 5.0f;
    
    if (_currentHomeContentPage == TEAM_CONTENT_MYQUESTION) {
        if (quesInfoM.TARGETUSERNAME.length > 0) {
            
            NSString * targetUsernameStr = [NSString stringWithFormat:@"指定人员回答 ：%@",quesInfoM.TARGETUSERNAME];

            float targetUsernameHeight = [ZEUtil heightForString:targetUsernameStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            
            UILabel * TARGETUSERNAMELab = [[UILabel alloc]initWithFrame:CGRectMake(20,userY,SCREEN_WIDTH - 40,targetUsernameHeight)];
            TARGETUSERNAMELab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
            TARGETUSERNAMELab.text = targetUsernameStr;
            TARGETUSERNAMELab.textColor = MAIN_SUBTITLE_COLOR;
            [questionsView addSubview:TARGETUSERNAMELab];
            TARGETUSERNAMELab.numberOfLines = 0;
            
            userY += targetUsernameHeight + 5.0f;
        }
    }
    
    
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
    if(quesInfoM.ISANONYMITY){
        [userImg setImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        QUESTIONUSERNAME.text = @"匿名提问";
    }
    
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
    answerBtn.frame = CGRectMake(SCREEN_WIDTH - 60 , userY - 20, 50, 40);
    [answerBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [answerBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [answerBtn setTitle:@" 回答" forState:UIControlStateNormal];
    [answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [answerBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [answerBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    answerBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [questionsView addSubview:answerBtn];
    answerBtn.tag = indexpath.row;
    answerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [answerBtn addTarget:self action:@selector(answerQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([quesInfoM.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        answerBtn.hidden = YES;
        praiseNumLab.left =  answerBtn.left + 10;

    }
    
    if ([quesInfoM.ISSOLVE boolValue]) {
        UIImageView * iconAccept = [[UIImageView alloc]init];
        [questionsView addSubview:iconAccept];
        iconAccept.frame = CGRectMake(SCREEN_WIDTH - 35, 0, 35, 35);
        [iconAccept setImage:[UIImage imageNamed:@"ic_best_answer"]];
    }

    
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 5.0f)];
    grayView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:grayView];
    
    questionsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 30.0f);
    
    return questionsView;
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

-(void)loadNewNewestData:(MJRefreshHeader *)header
{
    if([self.delegate respondsToSelector:@selector(loadNewData:)]){
        [self.delegate loadNewData:header.superview.tag  - 100];
    }
}

-(void)loadMoreData:(MJRefreshFooter *)footer
{
    if([self.delegate respondsToSelector:@selector(loadMoreData:)]){
        [self.delegate loadMoreData:footer.superview.tag - 100];
    }
}

-(void)answerQuestion:(UIButton *)btn
{
    NSDictionary * datasDic = nil;
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[btn.tag];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[btn.tag];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[btn.tag];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[btn.tag];
            break;
        default:
            break;
    }
    
    ZEQuestionInfoModel * questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    if ([self.delegate respondsToSelector:@selector(goAnswerQuestionVC:)]) {
        [self.delegate goAnswerQuestionVC:questionInfoModel];
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
