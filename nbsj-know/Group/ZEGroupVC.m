//
//  ZEGroupVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#import "ZEGroupVC.h"

#import "ZEProfessionalCirVC.h"
#import "ZETeamCircleVC.h"
@interface ZEGroupVC ()
{
    ZETeamCircleVC * teamCirVC;
    ZEProfessionalCirVC * profCirVC;
    
    UIButton * _professionalBtn;
    UIButton * _teamBtn;
}
@end

@implementation ZEGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
        self.title = @"圈子";
        [self disableLeftBtn];
        
    }else if (_enter_group_type == ENTER_GROUP_TYPE_SETTING){
        self.title = @"我的圈子";
    }
//    [self initView];
    
//    teamCirVC =[[ZETeamCircleVC alloc]init];
    profCirVC = [[ZEProfessionalCirVC alloc]init];
    profCirVC.enter_group_type = _enter_group_type;
//    [self addChildViewController:teamCirVC];
    [self addChildViewController:profCirVC];
    
    [self.view addSubview:profCirVC.view];
    [self.view sendSubviewToBack:profCirVC.view];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_QUESTION object:nil];

    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
        self.tabBarController.tabBar.hidden = NO;
    }else if (_enter_group_type == ENTER_GROUP_TYPE_SETTING){
        self.tabBarController.tabBar.hidden = YES;
    }
}

-(void)initView{
    
//    UIView * segmentBGView = [[UIView alloc]initWithFrame:CGRectMake(40, NAV_HEIGHT, SCREEN_WIDTH - 80.0f, 40.0f)];
//    segmentBGView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:segmentBGView];
//    segmentBGView.clipsToBounds = YES;
//    segmentBGView.layer.cornerRadius = 10;
//    segmentBGView.layer.borderWidth = 1;
//    segmentBGView.layer.borderColor = [MAIN_NAV_COLOR CGColor];
//    
//    CALayer * lineLayer = [CALayer layer];
//    [segmentBGView.layer addSublayer:lineLayer];
//    lineLayer.backgroundColor  = MAIN_LINE_COLOR.CGColor ;
    
    _professionalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _professionalBtn.frame = CGRectMake(0, NAV_HEIGHT, (SCREEN_WIDTH  - 80 ) / 2, 45.0f);
    [_professionalBtn setTitle:@"专业圈" forState:UIControlStateNormal];
    [_professionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _professionalBtn.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    [self.view addSubview:_professionalBtn];
//    [_professionalBtn addTarget:self action:@selector(transVC:) forControlEvents:UIControlEventTouchUpInside];
    

//    _teamBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _teamBtn.frame = CGRectMake((SCREEN_WIDTH  - 80 ) / 2, 0, (SCREEN_WIDTH  - 80 ) / 2, 40.0f);
//    _teamBtn.backgroundColor = [UIColor yellowColor];
//    [_teamBtn setTitle:@"班组圈" forState:UIControlStateNormal];
//    [_teamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _teamBtn.backgroundColor = [UIColor whiteColor];
//    [segmentBGView addSubview:_teamBtn];
//    [_teamBtn addTarget:self action:@selector(transVC:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)transVC:(UIButton *)btn
{
    if ([btn isEqual:_professionalBtn]) {
        [self transitionFromViewController:teamCirVC
                          toViewController:profCirVC
                                  duration:0
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    _professionalBtn.backgroundColor = MAIN_NAV_COLOR;
                                    [_professionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _teamBtn.backgroundColor = [UIColor whiteColor];
                                    [_teamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                   } completion:^(BOOL finished) {
                                       [self.view sendSubviewToBack:profCirVC.view];
                                   }];
    }else{
        [self transitionFromViewController:profCirVC
                          toViewController:teamCirVC
                                  duration:0
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    _teamBtn.backgroundColor = MAIN_NAV_COLOR;
                                    [_teamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _professionalBtn.backgroundColor = [UIColor whiteColor];
                                    [_professionalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                } completion:^(BOOL finished) {
                                    [self.view sendSubviewToBack:teamCirVC.view];
                                }];
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
