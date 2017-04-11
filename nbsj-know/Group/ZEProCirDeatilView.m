//
//  ZEProCirDeatilView.m
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kDynamicsHeight  80.0f
#define kMemberHeight  30.0f

#define kExpertViewMarginLeft  0.0f
#define kExpertViewMarginTop   0
#define kExpertViewWidth       SCREEN_WIDTH
#define kExpertViewHeight      ((SCREEN_WIDTH - 20) / 3 - 10) * 1.4 + 60.0f


#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   (kExpertViewHeight + kExpertViewMarginTop)
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      ((SCREEN_WIDTH - 20) / 3 - 10) * 1.4

#define kCircleMessageMarginTop (kTypicalViewMarginTop + kTypicalViewHeight)
#define kCircleMessageHeight 250.0f

#import "ZEProCirDeatilView.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"

@interface ZEProCirDeatilView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * contentView;
    
    NSMutableArray * _caseQuestionArr;
}
@property (nonatomic,strong) NSDictionary * scoreDic;
@property (nonatomic,strong) NSArray * memberArr;
@property (nonatomic,strong) NSMutableArray * caseQuestionArr;
@property (nonatomic,strong) NSMutableArray * expertListArr;
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
    
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT , SCREEN_WIDTH, (SCREEN_HEIGHT - NAV_HEIGHT)) style:UITableViewStyleGrouped];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
}

#pragma mark - 专家列表
-(UIView *)createExpertView
{
    UIView * typicalCaseView = [[UIView alloc]initWithFrame:CGRectMake(kExpertViewMarginLeft, kExpertViewMarginTop, kExpertViewWidth, kExpertViewHeight)];
    typicalCaseView.backgroundColor = [UIColor whiteColor];
    typicalCaseView.tag = 100;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 35)];
    rowTitleLab.text = @"专家解答";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [typicalCaseView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 35);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [typicalCaseView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(moreExpertBtnClck) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 35, SCREEN_WIDTH, 1);
    [typicalCaseView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UIScrollView * typicalScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 40.0f, SCREEN_WIDTH - 20.0f, kExpertViewHeight - 25.0f)];
    typicalScrollView.showsHorizontalScrollIndicator = NO;
    [typicalCaseView addSubview:typicalScrollView];
    typicalScrollView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0 ; i < self.expertListArr.count; i ++ ) {
        ZEExpertModel * classicalCaseM = [ZEExpertModel getDetailWithDic:self.expertListArr[i]];
        
        UIButton * typicalImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typicalImageBtn.frame = CGRectMake( (SCREEN_WIDTH - 20) / 3 * i , 0, (SCREEN_WIDTH - 20) / 3 - 10,((SCREEN_WIDTH - 20) / 3 - 10) * 1.4);
        typicalImageBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
        [typicalScrollView addSubview:typicalImageBtn];
        [typicalImageBtn addTarget:self action:@selector(goExpertDetail:) forControlEvents:UIControlEventTouchUpInside];
        typicalImageBtn.tag = i;
        NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(classicalCaseM.FILEURL)] ;
        [typicalImageBtn sd_setImageWithURL:fileURL forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        if (i > 2) {
            typicalScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 20) / 3 * (i + 1) - 10, kTypicalViewHeight - 75);
        }
        
        UILabel * typicalLab = [[UILabel alloc]initWithFrame:CGRectMake(typicalImageBtn.frame.origin.x, typicalImageBtn.frame.origin.y + typicalImageBtn.frame.size.height, typicalImageBtn.frame.size.width, 15.0f)];
        typicalLab.text = classicalCaseM.USERNAME;
        typicalLab.numberOfLines = 0;
        typicalLab.textAlignment = NSTextAlignmentCenter;
        typicalLab.font = [UIFont systemFontOfSize:12];
        [typicalScrollView addSubview:typicalLab];
        
    }
    
    CALayer * grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, kExpertViewHeight - 0.5f, SCREEN_WIDTH, .5f);
    [typicalCaseView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    return  typicalCaseView;
}

#pragma mark - 经典案例

-(UIView *)createTypicalCaseView
{
    UIView * typicalCaseView = [[UIView alloc]initWithFrame:CGRectMake(kTypicalViewMarginLeft, kTypicalViewMarginTop, kTypicalViewWidth, kTypicalViewHeight)];
    typicalCaseView.backgroundColor = [UIColor whiteColor];
    typicalCaseView.tag = 100;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 35)];
    rowTitleLab.text = @"典型案例";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [typicalCaseView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 35);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [typicalCaseView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(moreCaseBtnClck) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 35, SCREEN_WIDTH, 1);
    [typicalCaseView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UIScrollView * typicalScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 40.0f, SCREEN_WIDTH - 20.0f, kTypicalViewHeight - 25.0f)];
    typicalScrollView.showsHorizontalScrollIndicator = NO;
    [typicalCaseView addSubview:typicalScrollView];
    
    for (int i = 0 ; i < self.caseQuestionArr.count; i ++ ) {
        ZEKLB_CLASSICCASE_INFOModel * classicalCaseM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.caseQuestionArr[i]];
        
        UIButton * typicalImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typicalImageBtn.frame = CGRectMake( (SCREEN_WIDTH - 20) / 3 * i , 0, (SCREEN_WIDTH - 20) / 3 - 10, kTypicalViewHeight - 75);
        typicalImageBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
        [typicalScrollView addSubview:typicalImageBtn];
        [typicalImageBtn addTarget:self action:@selector(goTypicalCaseDetail:) forControlEvents:UIControlEventTouchUpInside];
        typicalImageBtn.tag = i;
        if ([ZEUtil isStrNotEmpty:classicalCaseM.FILEURL]) {
            NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(classicalCaseM.FILEURL)] ;
            [typicalImageBtn sd_setImageWithURL:fileURL forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        }
        if (i > 2) {
            typicalScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 20) / 3 * (i + 1) - 10, kTypicalViewHeight - 75);
        }
        
        UILabel * typicalLab = [[UILabel alloc]initWithFrame:CGRectMake(typicalImageBtn.frame.origin.x, typicalImageBtn.frame.origin.y + typicalImageBtn.frame.size.height, typicalImageBtn.frame.size.width, 15.0f)];
        typicalLab.text = classicalCaseM.CASENAME;
        typicalLab.numberOfLines = 0;
        typicalLab.textAlignment = NSTextAlignmentCenter;
        typicalLab.font = [UIFont systemFontOfSize:12];
        [typicalScrollView addSubview:typicalLab];
        
        UIButton * browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        browseBtn.frame = CGRectMake(typicalImageBtn.frame.origin.x, typicalImageBtn.frame.origin.y + typicalImageBtn.frame.size.height + 15.0f, typicalImageBtn.frame.size.width, 15.0f);
        browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [browseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (![ZEUtil isStrNotEmpty:classicalCaseM.CLICKCOUNT]) {
            [browseBtn setTitle:@" 0" forState:UIControlStateNormal];
        }else{
            [browseBtn setTitle:[NSString stringWithFormat:@" %@",classicalCaseM.CLICKCOUNT] forState:UIControlStateNormal];
        }
        [browseBtn setImage:[UIImage imageNamed:@"discuss_pv.png" color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        [typicalScrollView addSubview:browseBtn];
    }
    
    CALayer * grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, kTypicalViewHeight - 0.5f, SCREEN_WIDTH, .5f);
    [typicalCaseView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    return  typicalCaseView;
}

#pragma mark - 渐变色
//-(void)makeColor:(UIView *)view
//{
//    CAGradientLayer *layer = [CAGradientLayer new];
//    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
//    layer.startPoint = CGPointMake(0, 0);
//    layer.endPoint = CGPointMake(0, 1);
//    layer.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 65.0f);
//    [self.layer addSublayer:layer];
//}


#pragma mark - Publick Method

-(void)reloadSection:(NSInteger)section
            scoreDic:(NSDictionary *)dic
          memberData:(id)data
{
    if([ZEUtil isNotNull:dic]){
        self.scoreDic = dic;
    }
    if ([ZEUtil isNotNull:data]) {
        self.memberArr = data;
    }
    
    [contentView reloadData];
}

-(void)reloadCaseView:(NSArray *)arr
{
    self.caseQuestionArr = [NSMutableArray arrayWithArray:arr];
    
//    UIView * typicalCaseView = [self viewWithTag:100];
//    for (id view in typicalCaseView.subviews) {
//        [view removeFromSuperview];
//    }
    if(self.caseQuestionArr.count > 0){
        [contentView reloadData];
    }
}

-(void)reloadExpertView:(NSArray *)arr
{
    self.expertListArr = [NSMutableArray arrayWithArray:arr];
    
//    UIView * typicalCaseView = [self viewWithTag:100];
//    for (id view in typicalCaseView.subviews) {
//        [view removeFromSuperview];
//    }
    if(self.expertListArr.count > 0){
        [contentView reloadData];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return kCircleMessageMarginTop + kCircleMessageHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];

    [headerView addSubview:[self createExpertView]];
    [headerView addSubview:[self createTypicalCaseView]];

    UIView * circleMessageView =  [UIView new];
    circleMessageView.frame = CGRectMake(0, kCircleMessageMarginTop, SCREEN_WIDTH, kCircleMessageHeight);
    [self initCircleMessage:circleMessageView];
    [headerView addSubview:circleMessageView];

    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    return self.memberArr.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMemberHeight ;
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
//    if (indexpath.row == 0) {
//        [self initCircleMessage:superView];
//    }else if (indexpath.row == 1){
        [self initMember:superView indexPath:indexpath];
//    }/
}

-(void)initCircleMessage:(UIView *)superView
{
//    CAGradientLayer *layer = [CAGradientLayer new];
//    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
//    layer.startPoint = CGPointMake(0, 0);
//    layer.endPoint = CGPointMake(1, 0);
//    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40.0f);
//    [superView.layer addSublayer:layer];
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    rowTitleLab.text = @"排行榜";
    rowTitleLab.textAlignment = NSTextAlignmentLeft;
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];

    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 40);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [superView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(goMoreRankingMessage) forControlEvents:UIControlEventTouchUpInside];

    for (int i = 0 ; i < 4; i ++) {
        
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * i, 40, SCREEN_WIDTH / 4, 80)];
        titleLab.text = @"本月排行";
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:16];
        [superView addSubview:titleLab];

        if (i == 1) {
            UIImageView * rankingImageView;
            rankingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * i, 50, SCREEN_WIDTH / 4, 60.0f)];
            [superView addSubview:rankingImageView];
            rankingImageView.contentMode = UIViewContentModeScaleAspectFit;

            if ([[self.scoreDic objectForKey:@"PROCIRCLERANKING"] integerValue] > 3) {
                titleLab.text = [self.scoreDic objectForKey:@"PROCIRCLERANKING"];
            }else if([[self.scoreDic objectForKey:@"PROCIRCLERANKING"] integerValue] == 1){
                titleLab.hidden = YES;
                rankingImageView.image = [UIImage imageNamed:@"icon_circle_first"];
            }else if([[self.scoreDic objectForKey:@"PROCIRCLERANKING"] integerValue] == 2){
                rankingImageView.image = [UIImage imageNamed:@"icon_circle_second"];
                titleLab.hidden = YES;
            }else if([[self.scoreDic objectForKey:@"PROCIRCLERANKING"] integerValue] == 3){
                rankingImageView.image = [UIImage imageNamed:@"icon_circle_third"];
                titleLab.hidden = YES;
            }
        }
        
        if(i == 2){
            titleLab.text = @"圈子活跃度";
            [titleLab adjustsFontSizeToFitWidth];
        }
        if(i == 3){
            if ([[self.scoreDic objectForKey:@"ACTIVELEVEL"] length] > 0) {
                titleLab.text = [self.scoreDic objectForKey:@"ACTIVELEVEL"];
            }else{
                titleLab.text = @"0";
            }
        }
        
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake( SCREEN_WIDTH / 4 * i - 1 , 40 , 1, 80);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    }
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 39, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    CALayer * lineLayer1 = [CALayer layer];
    lineLayer1.frame = CGRectMake(0, 119, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:lineLayer1];
    lineLayer1.backgroundColor = [MAIN_LINE_COLOR CGColor];

    UIButton * rankingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [superView addSubview:rankingBtn];
    UIImage * rankingImage = [UIImage imageNamed:@"icon_circle_ranking.jpg"];
    float rankHeight =  rankingImage.size.height * SCREEN_WIDTH / rankingImage.size.width ;
    rankingBtn.frame = CGRectMake(0, 120, SCREEN_WIDTH, rankHeight);
    [rankingBtn setImage:rankingImage forState:UIControlStateNormal];
    [rankingBtn addTarget:self action:@selector(goMoreRankingMessage) forControlEvents:UIControlEventTouchUpInside];
    
//    for(int i = 0 ; i < 5 ; i++){
//        UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + SCREEN_WIDTH / 5 * i, 40, SCREEN_WIDTH / 5 , 40)];
//        rowTitleLab.text = @"圈子成绩";
//        rowTitleLab.textAlignment = NSTextAlignmentCenter;
////        rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
//        rowTitleLab.font = [UIFont systemFontOfSize:14];
//        [superView addSubview:rowTitleLab];
//        
//        UILabel * rowSubTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + SCREEN_WIDTH / 5 * i, 80, SCREEN_WIDTH / 5 , 40)];
//        rowSubTitleLab.text = @"圈子成绩";
//        rowSubTitleLab.textAlignment = NSTextAlignmentCenter;
//        //        rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
//        rowSubTitleLab.font = [UIFont systemFontOfSize:12];
//        [superView addSubview:rowSubTitleLab];
//
//        
//        CALayer * lineLayer = [CALayer layer];
//        lineLayer.frame = CGRectMake(SCREEN_WIDTH / 5 * i, 40 , 1, 80);
//        [superView.layer addSublayer:lineLayer];
//        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
//
//        
//        switch (i) {
//            case 0:
//            {
//                rowTitleLab.text = @"月度排名";
//                if ([[self.scoreDic objectForKey:@"PROCIRCLERANKING"] integerValue] > 0) {
//                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"PROCIRCLERANKING"];
//                }else{
//                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"0"];
//                }
//            }
//                break;
//                
//            case 1:
//            {
//                rowTitleLab.text = @"提问数";
//                if ([[self.scoreDic objectForKey:@"QUESTIONSUM"] integerValue] > 0) {
//                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"QUESTIONSUM"];
//                }else{
//                    rowSubTitleLab.text = @"0";
//                }
//            }
//                break;
//            case 2:
//            {
//                rowTitleLab.text = @"回答数";
//                if ([[self.scoreDic objectForKey:@"ANSWERSUM"] integerValue] > 0) {
//                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"ANSWERSUM"];
//                }else{
//                    rowSubTitleLab.text = @"0";
//                }
//            }
//                break;
//            case 3:
//            {
//                rowTitleLab.text = @"采纳数";
//                if ([[self.scoreDic objectForKey:@"ANSWERTAKESUM"] integerValue] > 0) {
//                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"ANSWERTAKESUM"];
//                }else{
//                    rowSubTitleLab.text = @"0";
//                }
//            }
//                break;
//            case 4:
//            {
//                rowTitleLab.text = @"活跃度";
//                if ([[self.scoreDic objectForKey:@"ACTIVELEVEL"] length] > 0) {
//                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"ACTIVELEVEL"];
//                }else{
//                    rowSubTitleLab.text = @"0";
//                }
//            }
//                break;
//
//            default:
//                break;
//        }
//    }
//        
//    UILabel * rowTitleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 121, 80, 40)];
//    rowTitleLab1.text = @"团队成员";
//    rowTitleLab1.textAlignment = NSTextAlignmentLeft;
//    rowTitleLab1.font = [UIFont systemFontOfSize:16];
//    [superView addSubview:rowTitleLab1];

}

-(void)initMember:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
//    UIView * lineLayer = [UIView new];
//    lineLayer.frame = CGRectMake(0, 30, SCREEN_WIDTH, 1);
//    [superView addSubview:lineLayer];
//    lineLayer.backgroundColor = MAIN_LINE_COLOR ;
    
//    if(indexpath.row == 0){
        UIView * fLineLayer = [UIView new];
        fLineLayer.frame = CGRectMake(40, 0, 1, kMemberHeight * (self.memberArr.count + 1));
        [superView addSubview:fLineLayer];
        fLineLayer.backgroundColor = MAIN_LINE_COLOR;
//    }
    
        UIView * sumLineLayer = [UIView new];
        sumLineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        [superView addSubview:sumLineLayer];
        sumLineLayer.backgroundColor = MAIN_LINE_COLOR;
        
        UILabel * timeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 40, kMemberHeight)];
        timeTitleLab.text = [NSString stringWithFormat:@"%ldth",(long)indexpath.row];
        timeTitleLab.textAlignment = NSTextAlignmentCenter;
        timeTitleLab.font = [UIFont systemFontOfSize:14];
        [superView addSubview:timeTitleLab];
        
        if (indexpath.row == 0) {
            timeTitleLab.text = @"排名";
        }else if (indexpath.row == 1){
            timeTitleLab.text = @"1st";
        }else if (indexpath.row == 2){
            timeTitleLab.text = @"2nd";
        }else if (indexpath.row == 3){
            timeTitleLab.text = @"3rd";
        }
        
        for (int j = 0; j < 5; j ++ ) {
            UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(40 + (SCREEN_WIDTH - 40) / 5 * j, 0, (SCREEN_WIDTH - 40) / 5, kMemberHeight)];
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.font = [UIFont systemFontOfSize:14];
            [superView addSubview:contentLab];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(contentLab.frame.origin.x + contentLab.frame.size.width - 1, contentLab.frame.origin.y, 1, kMemberHeight)];
            lineView.backgroundColor = MAIN_LINE_COLOR;
            [superView addSubview:lineView];

            
            if(indexpath.row == 0){
                switch (j) {
                    case 0:
                        contentLab.text = @"昵称";
                        break;
                    case 1:
                        contentLab.text = @"提问数";
                        break;
                    case 2:
                        contentLab.text = @"回答数";
                        break;
                    case 3:
                        contentLab.text = @"采纳数";
                        break;
                    case 4:
                        contentLab.text = @"贡献值";
                        break;

                    default:
                        break;
                }
            }else{
                NSDictionary * dic = self.memberArr[indexpath.row - 1];
                
                switch (j) {
                    case 0:
                    {
                        if ([[dic objectForKey:@"NICKNAME"] length] > 0) {
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"NICKNAME"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@""];
                        }
                        contentLab.font = [UIFont systemFontOfSize:10];
                        contentLab.numberOfLines = 0;
                        contentLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
                    }
                        break;
                    case 1:
                        if([[dic objectForKey:@"QUESTIONSUM"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QUESTIONSUM"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;
                    case 2:
                        if([[dic objectForKey:@"ANSWERSUM"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ANSWERSUM"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;
                    case 3:
                        if([[dic objectForKey:@"ANSWERTAKESUM"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ANSWERTAKESUM"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;

                    case 4:
                        if([[dic objectForKey:@"SUMPOINTS"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SUMPOINTS"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;

                    default:
                        break;
                }
            }
        }
        
    
}

#pragma mark - DELEGATE

-(void)goDynamic
{
    if ([self.delegate respondsToSelector:@selector(goDynamic)]) {
        [self.delegate goDynamic];
    }
}

-(void)moreCaseBtnClck
{
    if([self.delegate respondsToSelector:@selector(goMoreCaseVC)]){
        [self.delegate goMoreCaseVC];
    }
}

-(void)moreExpertBtnClck
{
    if([self.delegate respondsToSelector:@selector(goMoreExpertVC)]){
        [self.delegate goMoreExpertVC];
    }
}

-(void)goTypicalCaseDetail:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(goTypicalDetail:)]){
        [self.delegate goTypicalDetail:self.caseQuestionArr[btn.tag]];
    }
}

-(void)goExpertDetail:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(goTypicalDetail:)]){
        ZEExpertModel * expertM = [ZEExpertModel getDetailWithDic:self.expertListArr[btn.tag]];
        [self.delegate goExpertDetail:expertM];
    }
}

-(void)goMoreRankingMessage
{
    if ([self.delegate respondsToSelector:@selector(moreRankingMessage)]) {
        [self.delegate moreRankingMessage];
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
