//
//  ZETeamCircleVC.m
//  nbsj-know
//
//  Created by Stenson on 16/9/26.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamCircleVC.h"

@interface ZETeamCircleVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZETeamCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
-(void)initView{
    UITableView * contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 40.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 89.0f) style:UITableViewStyleGrouped];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.view addSubview:contentView];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
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
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    [self initCellView:cell.contentView indexPath:indexPath];
    
    return cell;
}
#pragma mark - CellView
-(void)initCellView:(UIView *)superView indexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        CALayer * lineLaye = [CALayer layer];
        [superView.layer addSublayer:lineLaye];
        lineLaye.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineLaye.backgroundColor = [MAIN_LINE_COLOR CGColor];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 165;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * superView = [[UIView alloc]init];
    superView.backgroundColor =[UIColor whiteColor];
    [self initHeaderView:superView];
    return superView;
}

-(void)initHeaderView:(UIView *)superView
{
    NSInteger count =4;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (count / 3 + 1) * 60 + 5, 120, 40)];
    rowTitleLab.text = @"班组圈动态";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];

    
    for (int i = 0 ; i < count / 3 + 1 ; i ++) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 5 + 60 * i, SCREEN_WIDTH, 1);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        
        if (i == count/3 ) {
            CALayer * lastLineLayer = [CALayer layer];
            lastLineLayer.frame = CGRectMake(0, 5 + 60 * (i + 1), SCREEN_WIDTH, 1);
            [superView.layer addSublayer:lastLineLayer];
            lastLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        }

        for (int j = 1; j < 4; j ++ ) {

            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(SCREEN_WIDTH / 3 * j, 5 + 60 * i, 1, 60);
            [superView.layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

            if (i * 3 + j > count) {
                return;
            }
        
            UIButton * professionalBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            professionalBtn.frame = CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 5 + 60 * i, SCREEN_WIDTH / 3, 60.0f);
            professionalBtn.tag = i * 3 + j;
            [professionalBtn addTarget:self action:@selector(goDeatailVC:) forControlEvents:UIControlEventTouchUpInside];
            professionalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [professionalBtn setTitle:@"变电运输一班" forState:UIControlStateNormal];
            [professionalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [superView addSubview:professionalBtn];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
