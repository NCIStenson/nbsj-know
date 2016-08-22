//
//  ZEHomeVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#import "ZEHomeVC.h"
#import "ZEHomeView.h"
#import "ZESinginVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEQuestionsDetailVC.h"
@interface ZEHomeVC ()<ZEHomeViewDelegate>

@end

@implementation ZEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)initView
{
    ZEHomeView * _homeView = [[ZEHomeView alloc] initWithFrame:self.view.frame];
    _homeView.delegate = self;
    [self.view addSubview:_homeView];
}

#pragma mark - ZEHomeViewDelegate

-(void)goSinginView
{
    ZESinginVC * singVC = [[ZESinginVC alloc]init];
    [self.navigationController pushViewController:singVC animated:YES];
}

-(void)goMoreQuestionsView
{
    [self.tabBarController setSelectedIndex:1];
}
-(void)goMoreCaseAnswerView
{
    
}
-(void)goMoreExpertAnswerView
{
    
}
-(void)goQuestionDetailVCWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了第 %ld 区，第 %ld 行",(long)indexPath.section,(long)indexPath.row);
    
    ZEQuestionsDetailVC * quesDetailVC = [[ZEQuestionsDetailVC alloc]init];
    
    [self.navigationController pushViewController:quesDetailVC animated:YES];
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
