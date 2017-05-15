//
//  ZEPersonalNotiView.m
//  nbsj-know
//
//  Created by Stenson on 17/5/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPersonalNotiView.h"
#import "ZEExpertChatVC.h"

@interface ZEPersonalNotiView()
{    
    UITableView * notiContentView;
    
}

@property (nonatomic,strong) NSMutableArray * personalNotiArr;

@end

@implementation ZEPersonalNotiView

-(id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    notiContentView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 35.0f) style:UITableViewStylePlain];
    notiContentView.dataSource = self;
    notiContentView.delegate =self;
    [self addSubview:notiContentView];
    notiContentView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public Method
-(void)reloadFirstView:(NSArray *)arr
{
    self.personalNotiArr = [NSMutableArray arrayWithArray:arr];
    
    [notiContentView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personalNotiArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    ZETeamNotiCenModel * notiCenM = [ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]];

    if ([notiCenM.MESTYPE integerValue] == 1) {
        [self initTeamCellViewWithIndexpath:indexPath withCell:cell];
    }else if ([notiCenM.MESTYPE integerValue] == 2){
        [self initQuestionCellViewWithIndexpath:indexPath withCell:cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZETeamNotiCenModel * notiCenM = [ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]];

    if ([notiCenM.MESTYPE integerValue] == 1) {
        float explainHeight = [ZEUtil heightForString:notiCenM.QUESTIONEXPLAIN font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 120];

        return explainHeight + 80;
    }else if ([notiCenM.MESTYPE integerValue] == 2){
        float questionHeight = [ZEUtil heightForString:notiCenM.QUESTIONEXPLAIN font:[UIFont systemFontOfSize:18] andWidth:SCREEN_WIDTH - 20];

        return questionHeight + 65;
    }
    return 0;
}

-(void)initTeamCellViewWithIndexpath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary * dynamicDic =self.personalNotiArr[indexPath.row];
    NSLog(@">>>>>  %@",dynamicDic);
    ZETeamNotiCenModel * notiM = [ZETeamNotiCenModel getDetailWithDic:dynamicDic];
    NSString * fileUrl = [[[dynamicDic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    UIImageView * headeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    [headeImage setImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
    [headeImage sd_setImageWithURL:ZENITH_IMAGEURL(fileUrl) placeholderImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
    [cell.contentView addSubview:headeImage];
    [headeImage setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 120, 40)];
    nameLab.text = @"团队消息";
    nameLab.numberOfLines = 0;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:nameLab];
    nameLab.textColor = kTextColor;
    
    UILabel * dynamiLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, SCREEN_WIDTH - 120, 40)];
    dynamiLab.numberOfLines = 0;
    dynamiLab.textAlignment = NSTextAlignmentLeft;
    dynamiLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:dynamiLab];
    dynamiLab.textColor = kTextColor;
    dynamiLab.text = notiM.QUESTIONEXPLAIN;
    float explainHeight = [ZEUtil heightForString:dynamiLab.text font:dynamiLab.font andWidth:dynamiLab.width];
    dynamiLab.height = explainHeight;
    
    UILabel * receiptLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90,10,70,20.0f)];
    receiptLab.userInteractionEnabled = NO;
    receiptLab.textAlignment = NSTextAlignmentRight;
    receiptLab.numberOfLines = 0;
    receiptLab.textColor = MAIN_SUBTITLE_COLOR;
    receiptLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:receiptLab];
    receiptLab.userInteractionEnabled = YES;
    if ([notiM.DYNAMICTYPE integerValue] == 1) {
        receiptLab.text = @"需回执";
        receiptLab.textColor = [UIColor redColor];
    }else{
        receiptLab.hidden = YES;
    }

    UILabel * _disUsername = [UILabel new];
    _disUsername.top = dynamiLab.bottom + 5.0f;
    _disUsername.left = headeImage.right + 10.0f;
    [cell.contentView addSubview:_disUsername];
    _disUsername.size = CGSizeMake(120, 20);
    _disUsername.textAlignment = NSTextAlignmentLeft;
    _disUsername.textColor = [UIColor lightGrayColor];
    _disUsername.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _disUsername.text = [NSString stringWithFormat:@"发布人：%@",notiM.USERNAME];
    
    UILabel * _dateLab = [UILabel new];
    _dateLab.top = _disUsername.top;
    _dateLab.left = 10;
    [cell.contentView addSubview:_dateLab];
    _dateLab.size = CGSizeMake(SCREEN_WIDTH - 20, 20);
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.textColor = [UIColor lightGrayColor];
    _dateLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _dateLab.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@.0",notiM.SYSCREATEDATE]];
    
    if (indexPath.row == 0) {
        UIView * lineView = [UIView new];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = MAIN_LINE_COLOR;
        [cell.contentView addSubview:lineView];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, _dateLab.bottom + 4.5, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cell.contentView addSubview:lineView];
    
}

-(void)initQuestionCellViewWithIndexpath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell{

    NSDictionary * dynamicDic =self.personalNotiArr[indexPath.row];
    ZETeamNotiCenModel * notiM = [ZETeamNotiCenModel getDetailWithDic:dynamicDic];

    UILabel * tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 120, 20)];
    tipsLab.text = notiM.TIPS;
    tipsLab.numberOfLines = 0;
    tipsLab.textAlignment = NSTextAlignmentLeft;
    tipsLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:tipsLab];
    tipsLab.textColor = [UIColor lightGrayColor];
    
    UILabel * questionLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 120, 40)];
    questionLab.numberOfLines = 0;
    questionLab.textAlignment = NSTextAlignmentLeft;
    questionLab.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:questionLab];
    questionLab.textColor = kTextColor;
    questionLab.top = tipsLab.bottom + 5;
    questionLab.text = notiM.QUESTIONEXPLAIN;
    float questionHeight = [ZEUtil heightForString:notiM.QUESTIONEXPLAIN font:questionLab.font andWidth:SCREEN_WIDTH - 20];
    questionLab.height = questionHeight;
    
    UILabel * answerLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 120, 20)];
    answerLab.textAlignment = NSTextAlignmentLeft;
    answerLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:answerLab];
    answerLab.textColor = [UIColor lightGrayColor];
    answerLab.top = questionLab.bottom + 5;
    answerLab.text = notiM.ANSWEREXPLAIN;
    float answerHeight = [ZEUtil heightForString:notiM.ANSWEREXPLAIN font:answerLab.font andWidth:SCREEN_WIDTH - 20];
    answerLab.height = answerHeight;
    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90,10,70,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@.0", [dynamicDic objectForKey:@"SYSCREATEDATE"]]];
    SYSCREATEDATE.userInteractionEnabled = NO;
    SYSCREATEDATE.textAlignment = NSTextAlignmentRight;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;
    
    if (indexPath.row == 0) {
        UIView * lineView = [UIView new];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = MAIN_LINE_COLOR;
        [cell.contentView addSubview:lineView];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, answerLab.bottom + 4.5f, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cell.contentView addSubview:lineView];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZETeamNotiCenModel * notiModel = [ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]];
    if([notiModel.MESTYPE integerValue] == 1 && [self.delegate respondsToSelector:@selector(didSelectTeamMessage:)] ){
        [self.delegate didSelectTeamMessage:notiModel];
    }else if([notiModel.MESTYPE integerValue] == 2 && [self.delegate respondsToSelector:@selector(didSelectQuestionMessage:)] ){
        [self.delegate didSelectQuestionMessage:notiModel];
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
