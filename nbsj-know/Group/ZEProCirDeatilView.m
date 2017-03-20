//
//  ZEProCirDeatilView.m
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kDynamicsHeight  80.0f
#define kMemberHeight  30.0f

#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   NAV_HEIGHT
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      155.0f


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
    [self addSubview:[self createTypicalCaseView]];
    
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + kTypicalViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
}

#pragma mark - 经典案例

-(UIView *)createTypicalCaseView
{
    UIView * typicalCaseView = [[UIView alloc]initWithFrame:CGRectMake(kTypicalViewMarginLeft, kTypicalViewMarginTop, kTypicalViewWidth, kTypicalViewHeight)];
    typicalCaseView.backgroundColor = [UIColor whiteColor];
    typicalCaseView.tag = 100;
    
//    UIView * newestComment = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 5.0f, 20.0f)];
//    newestComment.backgroundColor = MAIN_NAV_COLOR_A(0.5);
//    [typicalCaseView addSubview:newestComment];
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40.0f);
    [typicalCaseView.layer addSublayer:layer];
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    rowTitleLab.text = @"技能充电桩";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [typicalCaseView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 40);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [typicalCaseView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(moreCaseBtnClck) forControlEvents:UIControlEventTouchUpInside];
    
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
        if (i == 3) {
            typicalScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 20) / 3 * 4 - 10, kTypicalViewHeight - 75);
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
-(void)makeColor:(UIView *)view
{
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    layer.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 65.0f);
    [self.layer addSublayer:layer];
}


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
    
    UIView * typicalCaseView = [self viewWithTag:100];
    for (id view in typicalCaseView.subviews) {
        [view removeFromSuperview];
    }
    if(self.caseQuestionArr.count > 0){
        [self addSubview:[self createTypicalCaseView]];
    }else{
        contentView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 121;
    }else if (indexPath.section == 1){
        return self.memberArr.count * kMemberHeight + 40 ;
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
        [self initMember:superView indexPath:indexpath];
    }
}

-(void)initCircleMessage:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40.0f);
    [superView.layer addSublayer:layer];
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    rowTitleLab.text = @"圈子成绩";
    rowTitleLab.textAlignment = NSTextAlignmentLeft;
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];

    for (int i = 0 ; i < 3; i ++) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 40 + 40 * i, SCREEN_WIDTH, 1);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    }

    for(int i = 0 ; i < 5 ; i++){
        UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + SCREEN_WIDTH / 5 * i, 40, SCREEN_WIDTH / 5 , 40)];
        rowTitleLab.text = @"圈子成绩";
        rowTitleLab.textAlignment = NSTextAlignmentCenter;
//        rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
        rowTitleLab.font = [UIFont systemFontOfSize:14];
        [superView addSubview:rowTitleLab];
        
        UILabel * rowSubTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + SCREEN_WIDTH / 5 * i, 80, SCREEN_WIDTH / 5 , 40)];
        rowSubTitleLab.text = @"圈子成绩";
        rowSubTitleLab.textAlignment = NSTextAlignmentCenter;
        //        rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
        rowSubTitleLab.font = [UIFont systemFontOfSize:12];
        [superView addSubview:rowSubTitleLab];

        
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(SCREEN_WIDTH / 5 * i, 40 , 1, 80);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

        
        switch (i) {
            case 0:
            {
                rowTitleLab.text = @"月度排名";
                if ([[self.scoreDic objectForKey:@"PROCIRCLERANKING"] integerValue] > 0) {
                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"PROCIRCLERANKING"];
                }else{
                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"0"];
                }
            }
                break;
                
            case 1:
            {
                rowTitleLab.text = @"提问数";
                if ([[self.scoreDic objectForKey:@"QUESTIONSUM"] integerValue] > 0) {
                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"QUESTIONSUM"];
                }else{
                    rowSubTitleLab.text = @"0";
                }
            }
                break;
            case 2:
            {
                rowTitleLab.text = @"回答数";
                if ([[self.scoreDic objectForKey:@"ANSWERSUM"] integerValue] > 0) {
                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"ANSWERSUM"];
                }else{
                    rowSubTitleLab.text = @"0";
                }
            }
                break;
            case 3:
            {
                rowTitleLab.text = @"采纳数";
                if ([[self.scoreDic objectForKey:@"ANSWERTAKESUM"] integerValue] > 0) {
                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"ANSWERTAKESUM"];
                }else{
                    rowSubTitleLab.text = @"0";
                }
            }
                break;
            case 4:
            {
                rowTitleLab.text = @"活跃度";
                if ([[self.scoreDic objectForKey:@"ACTIVELEVEL"] length] > 0) {
                    rowSubTitleLab.text = [self.scoreDic objectForKey:@"ACTIVELEVEL"];
                }else{
                    rowSubTitleLab.text = @"0";
                }
            }
                break;

            default:
                break;
        }

    }
    
   /*
//    UIButton * secondRowTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    secondRowTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 40);
//    [secondRowTitleBtn setTitle:@"圈子动态" forState:UIControlStateNormal];
//    secondRowTitleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    secondRowTitleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [secondRowTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [secondRowTitleBtn addTarget:self action:@selector(goDynamic) forControlEvents:UIControlEventTouchUpInside];
//    [superView addSubview:secondRowTitleBtn];
//    secondRowTitleBtn.backgroundColor = MAIN_NAV_COLOR_A(0.5);

    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 40, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    CALayer * sLineLayer = [CALayer layer];
    sLineLayer.frame = CGRectMake(0, 120, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:sLineLayer];
    sLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    UILabel * rankingTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 80, 80)];
    rankingTitleLab.text = [NSString stringWithFormat:@"圈子排名\n%@",[self.scoreDic objectForKey:@"PROCIRCLEPOSITION"]];
    rankingTitleLab.numberOfLines = 0;
    rankingTitleLab.textAlignment = NSTextAlignmentCenter;
    rankingTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rankingTitleLab];
    
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
                detailContentLab.text = [self.scoreDic objectForKey:@"ANSWERSUM"];
                break;
            case 1:
                detailLab.text = @"采纳数";
                detailContentLab.text = [self.scoreDic objectForKey:@"ANSWERTAKE"];
                break;
            case 2:
                detailLab.text = @"团队积分";
                detailContentLab.text = [self.scoreDic objectForKey:@"PROCIRCLEPOINTS"];
                break;

                
            default:
                break;
        }
    }
    
    UILabel * currentRankingLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 3, 40, (SCREEN_WIDTH - 80) / 5, 80)];
    currentRankingLab.text = @"本\n月\n成\n绩";
    currentRankingLab.numberOfLines = 0;
//    currentRankingLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    currentRankingLab.textAlignment = NSTextAlignmentCenter;
    currentRankingLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:currentRankingLab];
    
    CALayer * rankingLineLayer = [CALayer layer];
    rankingLineLayer.frame = CGRectMake(currentRankingLab.frame.origin.x + currentRankingLab.frame.size.width - 1, 40, 1, 80);
    [superView.layer addSublayer:rankingLineLayer];
    rankingLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * sumAnswerLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 4, 40, (SCREEN_WIDTH - 80) / 5, 40)];
    sumAnswerLab.text = [NSString stringWithFormat:@"回答数\n%@",[self.scoreDic objectForKey:@"MONTHANSWERSUM"]];
    sumAnswerLab.numberOfLines = 0;
    sumAnswerLab.textAlignment = NSTextAlignmentCenter;
    sumAnswerLab.font = [UIFont systemFontOfSize:13];
    [superView addSubview:sumAnswerLab];
    
    CALayer * sumLineLayer = [CALayer layer];
    sumLineLayer.frame = CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 4, 80, (SCREEN_WIDTH - 80) / 5, 1);
    [superView.layer addSublayer:sumLineLayer];
    sumLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * sumAdoptLab = [[UILabel alloc]initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 80) / 5 * 4, 80, (SCREEN_WIDTH - 80) / 5, 40)];
    sumAdoptLab.text = [NSString stringWithFormat:@"采纳数\n%@",[self.scoreDic objectForKey:@"MONTHANSWERTAKE"]];
    sumAdoptLab.numberOfLines = 0;
    sumAdoptLab.textAlignment = NSTextAlignmentCenter;
    sumAdoptLab.font = [UIFont systemFontOfSize:13];
    [superView addSubview:sumAdoptLab];

    */
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
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40.0f);
    [superView.layer addSublayer:layer];
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    rowTitleLab.text = @"团队成员";
    rowTitleLab.textAlignment = NSTextAlignmentLeft;
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];
    
    UIView * lineLayer = [UIView new];
    lineLayer.frame = CGRectMake(0, 40, SCREEN_WIDTH, 1);
    [superView addSubview:lineLayer];
    lineLayer.backgroundColor = MAIN_LINE_COLOR ;
    
    UIView * fLineLayer = [UIView new];
    fLineLayer.frame = CGRectMake(40, 40, 1, kMemberHeight * (self.memberArr.count + 1));
    [superView addSubview:fLineLayer];
    fLineLayer.backgroundColor = MAIN_LINE_COLOR;
    
    for (int i = 0; i < self.memberArr.count + 1;  i ++) {
        
        UIView * sumLineLayer = [UIView new];
        sumLineLayer.frame = CGRectMake(0, 40 + kMemberHeight * (i + 1), SCREEN_WIDTH, 1);
        [superView addSubview:sumLineLayer];
        sumLineLayer.backgroundColor = MAIN_LINE_COLOR;
        
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
        
        for (int j = 0; j < 5; j ++ ) {
            UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(40 + (SCREEN_WIDTH - 40) / 5 * j, 40 + kMemberHeight * i , (SCREEN_WIDTH - 40) / 5, kMemberHeight)];
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.font = [UIFont systemFontOfSize:14];
            [superView addSubview:contentLab];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(contentLab.frame.origin.x + contentLab.frame.size.width - 1, contentLab.frame.origin.y, 1, kMemberHeight)];
            lineView.backgroundColor = MAIN_LINE_COLOR;
            [superView addSubview:lineView];

            
            if(i == 0){
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
                NSDictionary * dic = self.memberArr[i - 1];
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

-(void)goTypicalCaseDetail:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(goTypicalDetail:)]){
        [self.delegate goTypicalDetail:self.caseQuestionArr[btn.tag]];
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
