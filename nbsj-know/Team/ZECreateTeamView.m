//
//  ZECreateTeamView.m
//  nbsj-know
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZECreateTeamView.h"

#define textViewStr @"请输入团队宣言（不超过20字）"
#define textViewProfileStr @"请输入团队简介，建议不超过100字！"

#define kItemSizeWidth (SCREEN_WIDTH - 20) / (IPHONE6_MORE ? 6 : 5)
#define kItemSizeHeight (IPHONE6_MORE ? 95 : 80.0f)

@implementation ZECreateTeamMessageView

-(id)initWithFrame:(CGRect)frame withTeamCircleInfo:(ZETeamCircleModel *)teamCircleM;
{
    self = [super initWithFrame:frame];
    if (self) {
        teamCircleInfo = teamCircleM;
        self.backgroundColor = [UIColor whiteColor];
        [self initTeamMsgView];
        [self initTeamProfileView];
    }
    return self;
}

-(void)initTeamMsgView
{
    _teamHeadImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _teamHeadImgBtn.frame = CGRectMake(10 , 10 , 90, 90);
    [self addSubview:_teamHeadImgBtn];
    [_teamHeadImgBtn setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [_teamHeadImgBtn addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < 3;  i ++) {
        UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 15 + 30 * i, 70, 30)];
        caseNameLab.text = @"团队名称:";
        [caseNameLab setTextColor:kTextColor];
        caseNameLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:caseNameLab];
        
        float marginLeft = 185;
        float marginTop = 15 + 30 * i;
        float maiginWidth = SCREEN_WIDTH - marginLeft - 20;
        
        if (i == 0) {
            _teamNameField = [[UITextField alloc]initWithFrame:CGRectMake(marginLeft, marginTop, maiginWidth, 30)];
            _teamNameField.clipsToBounds = YES;
            _teamNameField.layer.cornerRadius = 5.0f;
            _teamNameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
            _teamNameField.leftViewMode = UITextFieldViewModeAlways;
            _teamNameField.placeholder = @"请输入团队名称";
            _teamNameField.textColor = kTextColor;
            [self addSubview:_teamNameField];
            [_teamNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];

        }else if (i == 1){
            caseNameLab.text = @"团队分类:";
            _teamTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _teamTypeBtn.frame = CGRectMake(marginLeft + 5.0f , marginTop , maiginWidth, 30);
            [_teamTypeBtn  setTitle:@"请选择团队所属专业" forState:UIControlStateNormal];
            [_teamTypeBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
            [_teamTypeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self addSubview:_teamTypeBtn];
            _teamTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _teamTypeBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        }else if (i == 2){
            caseNameLab.text = @"团队宣言:";
            _manifestoTextView = [[UITextView alloc]initWithFrame:CGRectMake(marginLeft, marginTop, maiginWidth , 40)];
            _manifestoTextView.text = textViewStr;
            _manifestoTextView.font = [UIFont systemFontOfSize:kTiltlFontSize];
            _manifestoTextView.textColor = [UIColor lightGrayColor];
            _manifestoTextView.delegate = self;
            [self addSubview:_manifestoTextView];
        }
    }
}

-(void)initTeamProfileView
{
    UIView * teamProfileView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 105)];
    [self addSubview:teamProfileView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [teamProfileView addSubview:lineView];
    
    UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    caseNameLab.text = @"团队简介:";
    [caseNameLab setTextColor:kTextColor];
    caseNameLab.font = [UIFont systemFontOfSize:16];
    [teamProfileView addSubview:caseNameLab];

    _profileTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30 , SCREEN_WIDTH - 20 , 70)];
    _profileTextView.text = textViewProfileStr;
    _profileTextView.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _profileTextView.textColor = [UIColor lightGrayColor];
    _profileTextView.delegate = self;
    [teamProfileView addSubview:_profileTextView];
    
    if ([ZEUtil isNotNull:teamCircleInfo] ) {
        
        // 不是团长 不允许编辑
        if (![teamCircleInfo.SYSCREATORID isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            [_teamHeadImgBtn removeTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
            _teamNameField.enabled = NO;
            _manifestoTextView.editable = NO;
            _profileTextView.editable = NO;
            [_teamTypeBtn removeTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_teamHeadImgBtn sd_setImageWithURL:ZENITH_IMAGEURL(teamCircleInfo.FILEURL) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        
        _teamNameField.text = teamCircleInfo.TEAMCIRCLENAME;
        
        [_teamTypeBtn setTitle:teamCircleInfo.TEAMCIRCLECODENAME forState:UIControlStateNormal];
        [_teamTypeBtn setTitleColor:kTextColor forState:UIControlStateNormal];

        _manifestoTextView.text = teamCircleInfo.TEAMMANIFESTO;
        _manifestoTextView.textColor = kTextColor;

        _profileTextView.text  = teamCircleInfo.TEAMCIRCLEREMARK;
        _profileTextView.textColor = kTextColor;
        
        _TEAMCIRCLECODE = teamCircleInfo.TEAMCIRCLECODE;
        _TEAMCIRCLECODENAME = teamCircleInfo.TEAMCIRCLECODENAME;

    }

}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewStr] || [textView.text isEqualToString:textViewProfileStr]) {
        textView.text = @"";
        textView.textColor = kTextColor;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewStr]&& [textView isEqual:_manifestoTextView]) {
        textView.text = textViewStr;
        textView.textColor = [UIColor lightGrayColor];
    }else if ([textView.text isEqualToString:textViewProfileStr] && [textView.text isEqualToString:textViewProfileStr]){
        textView.text = textViewStr;
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 20 && [textView isEqual:_manifestoTextView]) {
        textView.text = [textView.text substringToIndex:20];
    }else if (textView.text.length > 100 && [textView isEqual:_profileTextView]){
        textView.text = [textView.text substringToIndex:100];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self downTheKeyBoard];
}

-(void)downTheKeyBoard
{
    [self endEditing:YES];
}
#pragma mark - Public Method

- (void)reloadTeamHeadImageView:(UIImage *)headImage
{
    [_teamHeadImgBtn setImage:headImage forState:UIControlStateNormal];
}

#pragma mark - 展示提问问题分类列表

-(void)showCamera
{
    [self endEditing:YES];
    if ([_createTeamView.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [_createTeamView.delegate takePhotosOrChoosePictures];
    }
}

-(void)showQuestionTypeView
{
    [self endEditing:YES];
    teamTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    teamTypeView.delegate = self;
    [_createTeamView addSubview:teamTypeView];
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [teamTypeView reloadData];
    }
}

#pragma mark - 选择问题分类

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode;
{
    [_teamTypeBtn  setTitle:[NSString stringWithFormat:@"%@",typeName] forState:UIControlStateNormal];
    [_teamTypeBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    self.TEAMCIRCLECODE = typeCode;
    self.TEAMCIRCLECODENAME = typeName;
    for (UIView * view in teamTypeView.subviews) {
        [view removeFromSuperview];
    }
    [teamTypeView removeFromSuperview];
}

@end


@implementation ZECreateTeamNumbersView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alreadyInviteNumbersArr = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:lineView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, self.frame.size.height - 15) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册Cell，必须要有
    [self addSubview:_collectionView];
    
}
#pragma mark  - Public Method
-(void)reloadNumbersView:(NSArray *)numbersArr
           withEnterType:(ENTER_TEAM)type
{
    if (type == ENTER_TEAM_CREATE) {
        self.alreadyInviteNumbersArr = [NSMutableArray arrayWithArray:@[[ZESettingLocalData getUSERINFO]]];
    }else if (type == ENTER_TEAM_DETAIL){
        self.alreadyInviteNumbersArr = [NSMutableArray array];

    }
    _enterTeamType = type;
    [self.alreadyInviteNumbersArr addObjectsFromArray:numbersArr];
    
    [_collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_enterTeamType == ENTER_TEAM_CREATE) {
        return self.alreadyInviteNumbersArr.count + 2 ;
    }
    if (self.alreadyInviteNumbersArr.count > 0) {
        for (NSDictionary * dic in self.alreadyInviteNumbersArr){
            ZEUSER_BASE_INFOM * USERINFO = [ZEUSER_BASE_INFOM getDetailWithDic:dic];

            if ([USERINFO.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] && [USERINFO.USERTYPE integerValue] == 2) {
                return self.alreadyInviteNumbersArr.count + 2;
            }

        }
    }
    return self.alreadyInviteNumbersArr.count ;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (id view  in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if(indexPath.row < self.alreadyInviteNumbersArr.count){
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[indexPath.row]];
        
        UIImageView * headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemSizeWidth, kItemSizeWidth)];
        [headImage sd_setImageWithURL:ZENITH_IMAGEURL(userinfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        [cell.contentView addSubview:headImage];
        //    headImage.backgroundColor = [UIColor redColor];
        
        UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, kItemSizeWidth, kItemSizeWidth, kItemSizeHeight - kItemSizeWidth)];
        nameLab.text = userinfo.USERNAME;
        [nameLab setTextColor:[UIColor blackColor]];
        nameLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [cell.contentView addSubview:nameLab];
        //    nameLab.backgroundColor = [UIColor cyanColor];
        nameLab.textAlignment = NSTextAlignmentCenter;
    }
    
    if (indexPath.row == 0 && self.alreadyInviteNumbersArr.count > 0) {
        UILabel * leaderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        leaderLab.center = CGPointMake(kItemSizeWidth - 5, kItemSizeWidth -  (IPHONE6_MORE ? 5 : 10));
        leaderLab.text = @"团长";
        leaderLab.textAlignment = NSTextAlignmentCenter;
        [leaderLab setTextColor:[UIColor whiteColor]];
        leaderLab.backgroundColor = RGBA(22, 155, 213, 1);
        leaderLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [cell.contentView addSubview:leaderLab];
        leaderLab.clipsToBounds = YES;
        leaderLab.layer.cornerRadius = 5;
    }else if (indexPath.row == self.alreadyInviteNumbersArr.count){
        UIImageView * addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addimg"]];
        addImage.frame = CGRectMake(0,(kItemSizeHeight - kItemSizeWidth) / 2, kItemSizeWidth, kItemSizeWidth);
        [cell.contentView addSubview:addImage];
    }else if (indexPath.row == self.alreadyInviteNumbersArr.count + 1){
        UIImageView * addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reduceimage"]];
        addImage.frame = CGRectMake(0,(kItemSizeHeight - kItemSizeWidth) / 2, kItemSizeWidth, kItemSizeWidth);
        [cell.contentView addSubview:addImage];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kItemSizeWidth,kItemSizeHeight);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.alreadyInviteNumbersArr.count + 1){
        if([_createTeamView.delegate respondsToSelector:@selector(goRemoveNumberView)]){
            [_createTeamView.delegate goRemoveNumberView];
        }

    }else if(indexPath.row == self.alreadyInviteNumbersArr.count){
        if([_createTeamView.delegate respondsToSelector:@selector(goQueryNumberView)]){
            [_createTeamView.delegate goQueryNumberView];
        }
    }else{
        
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end

@implementation ZECreateTeamView

-(id)initWithFrame:(CGRect)frame withTeamCircleInfo:(ZETeamCircleModel *)teamCircleM
{
    self = [super initWithFrame:frame];
    if (self) {
        teamCircleInfo = teamCircleM;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:scrollView];
    
    _messageView = [[ZECreateTeamMessageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) withTeamCircleInfo:teamCircleInfo];
    _messageView.createTeamView = self;
    [scrollView addSubview:_messageView];
    
    _numbersView = [[ZECreateTeamNumbersView alloc]initWithFrame:CGRectMake(0, 225, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT - 225)];
    _numbersView.createTeamView = self;
    [scrollView addSubview:_numbersView];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
