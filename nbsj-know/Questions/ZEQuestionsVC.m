//
//  ZEQuestionsVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#import "ZEQuestionsVC.h"

#import "ZEQuestionsView.h"

#import "ZEShowQuestionVC.h"
#import "ZEAskQuesViewController.h"
#import "ZEQuestionsDetailVC.h"

@interface ZEQuestionsVC ()<ZEQuestionsViewDelegate>

@end

@implementation ZEQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"问答";
    [self.leftBtn setTitle:@"分类" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateHighlighted];
    [self.rightBtn setTitle:@"提问" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)initView
{
    ZEQuestionsView * questionView = [[ZEQuestionsView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 49.0f)];
    questionView.delegate =self;
    [self.view addSubview:questionView];
}

-(void)rightBtnClick
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    [self.navigationController pushViewController:askQues animated:YES];
}

#pragma mark - ZEQuestionsViewDelegate

-(void)goMoreRecommend
{
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goQuestionDetailVCWithIndexPath:(NSIndexPath *)indexPath
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
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
