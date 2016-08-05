//
//  ZEAnswerQuestionsVC.m
//  nbsj-know
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerQuestionsVC.h"
#import "ZEAnswerQuestionsView.h"

@interface ZEAnswerQuestionsVC ()

@end

@implementation ZEAnswerQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"回答";
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
}

-(void)initView
{
    ZEAnswerQuestionsView * answerQuesView = [[ZEAnswerQuestionsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:answerQuesView];
    [self.view sendSubviewToBack:answerQuesView];
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
