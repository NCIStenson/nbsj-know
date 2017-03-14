//
//  ZETeamView.m
//  nbsj-know
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kContentTableHeight (SCREEN_HEIGHT - NAV_HEIGHT - TAB_BAR_HEIGHT)

#import "ZETeamView.h"

#import "ZETeamCircleModel.h"

@implementation ZETeamViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Public Method

-(void)reloadCollectionView:(NSArray *)arr
{
    _joinTeam = [NSMutableArray arrayWithArray:arr];
    [_collectionView reloadData];
}

-(void)initView
{
    MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
    flow.minimumLineSpacing = 30;
    flow.minimumInteritemSpacing = 30;
    flow.needAlpha = YES;
    flow.delegate = self;
    CGFloat oneX =SCREEN_WIDTH / 4;
    flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , (SCREEN_WIDTH / 3 + (IPHONE5 ? 30 : IPHONE6 ? 40 : 50))) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    UILabel * headerLab = [[UILabel alloc]init];
    headerLab.left = 20;
    headerLab.top = SCREEN_WIDTH / 3 + (IPHONE5 ? 20 : IPHONE6 ? 25 : 40);
    headerLab.size = CGSizeMake(SCREEN_WIDTH, 20);
    [self addSubview:headerLab];
    headerLab.text = @"团队动态";
    headerLab.textColor = kTextColor;
    headerLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:@""];
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _joinTeam.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.row > 0 && indexPath.row < _joinTeam.count + 1) {
        
        ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:_joinTeam[indexPath.row - 1]];
        
        UIImageView * heroImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH / 3 - 30, SCREEN_WIDTH / 3 - 30)];
        [cell.contentView addSubview:heroImageVIew];
        [heroImageVIew sd_setImageWithURL:ZENITH_IMAGEURL(teaminfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        
        heroImageVIew.layer.cornerRadius = 5.0f;
        heroImageVIew.layer.masksToBounds = YES;
        
        UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, SCREEN_WIDTH / 3 - 30, SCREEN_WIDTH / 3 - 30, 30)];
        nameLab.text = teaminfo.TEAMCIRCLENAME;
        nameLab.numberOfLines = 0;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [cell.contentView addSubview:nameLab];
        nameLab.textColor = kTextColor;

    }else{
        UIImageView * heroImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH / 3 - 30, SCREEN_WIDTH / 3 - 30)];
        [cell.contentView addSubview:heroImageVIew];
        heroImageVIew.image = [UIImage imageNamed:@"logo.png"];
        
        heroImageVIew.layer.cornerRadius = 5.0f;
        heroImageVIew.layer.masksToBounds = YES;
    }
    

    return cell;
}

#pragma warning -   
// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[MKJCollectionViewFlowLayout class]]) {
        CGPoint pInUnderView = [self convertPoint:collectionView.center toView:collectionView];
        
        // 获取中间的indexpath
        NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
        
        if (indexPath.row == indexpathNew.row)
        {
            if ([self.teamView.delegate respondsToSelector:@selector(goFindTeamVC)]) {
                [self.teamView.delegate goFindTeamVC];
            }

            return;
        }else{
//            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

#pragma mark - 滑动结束后 获取当前cell的indexpath
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pInView = [self convertPoint:_collectionView.center toView:_collectionView];

    NSIndexPath * indexpath = [_collectionView indexPathForItemAtPoint:pInView];
    
    if(_joinTeam.count > 0 && indexpath.row > 0 && indexpath.row < _joinTeam.count + 1){
        ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:_joinTeam[indexpath.row - 1]];
        NSLog(@">>>>  %@",teaminfo.TEAMCIRCLENAME);
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:teaminfo];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:nil];
    }
    
}



@end


@implementation ZETeamView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH,  kContentTableHeight);
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public Method

-(void)reloadHeaderView:(NSArray *)arr
{
    [_headerView reloadCollectionView:arr];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = MAIN_ARM_COLOR;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREEN_WIDTH / 3 + (IPHONE5 ? 40 : IPHONE6 ? 50 : 60);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView =[[ZETeamViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 3 + 20)];
    _headerView.teamView = self;
    return _headerView;
}


#pragma mark -UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(goTeamQuestionVC)]) {
        [self.delegate goTeamQuestionVC];
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
