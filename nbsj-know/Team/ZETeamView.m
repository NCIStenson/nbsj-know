//
//  ZETeamView.m
//  nbsj-know
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kContentTableHeight (SCREEN_HEIGHT - NAV_HEIGHT - TAB_BAR_HEIGHT)

#import "ZETeamView.h"

#import "MKJCollectionViewFlowLayout.h"
#import "MKJCollectionViewCell.h"
#import "MKJCircleLayout.h"

static NSString *indentify = @"MKJCollectionViewCell";

@implementation ZETeamViewHeaderView

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
    MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
    flow.minimumLineSpacing = 30;
    flow.minimumInteritemSpacing = 30;
    flow.needAlpha = YES;
    flow.delegate = self;
    CGFloat oneX =SCREEN_WIDTH / 4;
    flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH , SCREEN_WIDTH / 3) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:indentify bundle:nil] forCellWithReuseIdentifier:indentify];
    [self addSubview:_collectionView];
    
    UILabel * headerLab = [[UILabel alloc]init];
    headerLab.left = 20;
    headerLab.top = SCREEN_WIDTH / 3 + 10;
    headerLab.size = CGSizeMake(SCREEN_WIDTH, 20);
    [self addSubview:headerLab];
    headerLab.text = @"团队动态";
    headerLab.textColor = kTextColor;
    headerLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MKJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    cell.heroImageVIew.image = [UIImage imageNamed:@"logo.png"];
    return cell;
}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    if ([self.collectionView.collectionViewLayout isKindOfClass:[MKJCollectionViewFlowLayout class]]) {
        CGPoint pInUnderView = [self convertPoint:collectionView.center toView:collectionView];
        
        // 获取中间的indexpath
        NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
        
        if ([self.teamView.delegate respondsToSelector:@selector(goFindTeamVC)]) {
            [self.teamView.delegate goFindTeamVC];
        }

        
        if (indexPath.row == indexpathNew.row)
        {
            NSLog(@"点击了同一个");
            return;
        }else{
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
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
    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
//    contentTableView.mj_header = header;
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

    cell.contentView.backgroundColor = MAIN_ARM_COLOR;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREEN_WIDTH / 3 + 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZETeamViewHeaderView * headerView =[[ZETeamViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 3 + 20)];
    headerView.backgroundColor = [UIColor redColor];
    headerView.teamView = self;
    return headerView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
