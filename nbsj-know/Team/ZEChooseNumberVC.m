//
//  ZEChooseNumberVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChooseNumberVC.h"

@interface ZEChooseNumberVC ()
{
    ZEChooseNumberView * chooseNumberView;
}
@end

@implementation ZEChooseNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"删除成员";
    [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(deleteNumbers) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
}

-(void)initView
{
    chooseNumberView = [[ZEChooseNumberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:chooseNumberView];
    [self.view sendSubviewToBack:chooseNumberView];
    [chooseNumberView reloadViewWithAlreadyInviteNumbers:_numbersArr];
}

-(void)deleteNumbers
{
    NSMutableArray * addMembersArr = [NSMutableArray array];
    NSMutableArray * subMembersArr = [NSMutableArray array];
    
    NSLog(@">>>  %@",chooseNumberView.maskArr);

    for (int i = 0; i < _numbersArr.count; i ++) {
        BOOL mask  = [chooseNumberView.maskArr[i] boolValue];
        if (!mask) {
            [addMembersArr addObject:_numbersArr[i]];
        }else{
            [subMembersArr addObject:_numbersArr[i]];
        }
    }

//    NSLog(@">>>  %@",addMembersArr);
//    NSLog(@">>>  %@",subMembersArr);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_DELETE_TEAMCIRCLENUMBERS object:addMembersArr];
    [self.navigationController popViewControllerAnimated:YES];
    
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
