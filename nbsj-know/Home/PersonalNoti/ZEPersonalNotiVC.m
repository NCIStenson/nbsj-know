//
//  ZEPersonalNotiVC.m
//  nbsj-know
//
//  Created by Stenson on 17/5/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kLabelScrollViewTag 999
#define kLabelScrollLineImageViewTag 1999

#import "ZEPersonalNotiVC.h"
#import "ZEPersonalDynamicVC.h"
#import "ZEPersonalChatListVC.h"
@interface ZEPersonalNotiVC ()
{
    NSArray * _allTypeArr;
    UIViewController * _currentVC;
    
    ZEPersonalDynamicVC * dynamicVC;
    ZEPersonalChatListVC * chatVC;
    
    UIScrollView * _labelScrollView;
}
@end

@implementation ZEPersonalNotiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVC];
    [self initView];
    
    self.title = @"消息盒子";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)initView{
    _allTypeArr = @[@"通知",@"系统",@"会话"];
    [self.view addSubview:[self createDetailOptionView:_allTypeArr]];
}

-(void)initVC
{

    dynamicVC = [[ZEPersonalDynamicVC alloc]init];
    [self addChildViewController:dynamicVC];
    
    [self.view addSubview:dynamicVC.view];
    [self.view sendSubviewToBack:dynamicVC.view];
    
    chatVC = [[ZEPersonalChatListVC alloc]init];
    [self addChildViewController:chatVC];
}

#pragma mark - 子分类选项滑动

-(UIView *)createDetailOptionView:(NSArray *)arr
{
    _labelScrollView = [[UIScrollView alloc]init];
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.left = 0.0f;
    _labelScrollView.top = NAV_HEIGHT;
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.height = 35.0f;
    _labelScrollView.tag = kLabelScrollViewTag;
    
    UIImageView * _lineImageView = [[UIImageView alloc]init];
    _lineImageView.frame = CGRectMake(0, 33.0f, SCREEN_WIDTH / arr.count, 2.0f);
    _lineImageView.backgroundColor = MAIN_GREEN_COLOR;
    [_labelScrollView addSubview:_lineImageView];
    _lineImageView.tag = kLabelScrollLineImageViewTag;
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < arr.count; i ++) {
        UIButton * labelContentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        labelContentBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [_labelScrollView addSubview:labelContentBtn];
        [labelContentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i == 0){
            [labelContentBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
        }
        labelContentBtn.top = 0.0f;
        labelContentBtn.height = 33.0f;
        [labelContentBtn setTitle:arr[i] forState:UIControlStateNormal];
        [labelContentBtn addTarget:self action:@selector(selectDifferentType:) forControlEvents:UIControlEventTouchUpInside];
        labelContentBtn.tag = 100 + i;
        labelContentBtn.width = SCREEN_WIDTH / arr.count;
        labelContentBtn.left = marginLeft;
        
        marginLeft += labelContentBtn.width;
    }
    
    return _labelScrollView;
}

#pragma mark - 选择上方分类

-(void)selectDifferentType:(UIButton *)btn
{
    UIScrollView *_typeScrollView;
    UIImageView * _lineImageView;
    
    _typeScrollView = [self.view viewWithTag:kLabelScrollViewTag];
    _lineImageView = [_typeScrollView viewWithTag:kLabelScrollLineImageViewTag];
    
    float marginLeft = 0;
    for (int i = 0 ; i < _allTypeArr.count; i ++) {
        UIButton * button = [btn.superview viewWithTag:100 + i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        float btnWidth = SCREEN_WIDTH / _allTypeArr.count;
        if (btn.tag - 100 == i) {
            [UIView animateWithDuration:0.35 animations:^{
                _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
            }];
        }
        marginLeft += btnWidth;
    }
    [btn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
    
    if (btn.tag == 100) {
        [self transitionFromViewController:chatVC
                          toViewController:dynamicVC
                                  duration:0.29
                                   options:UIViewAnimationOptionCurveLinear
                                animations:nil
                                completion:^(BOOL finished) {
                                    _currentVC = dynamicVC;
                                }];
    }else if (btn.tag == 101){

    }else if (btn.tag == 102){
        
        [self transitionFromViewController:dynamicVC
                          toViewController:chatVC
                                  duration:0.29
                                   options:UIViewAnimationOptionCurveLinear
                                animations:nil
                                completion:^(BOOL finished) {
                                    _currentVC = chatVC;
                                }];

    }
    
    [self.view bringSubviewToFront:self.navBar];
    [self.view bringSubviewToFront:_labelScrollView];
    NSLog(@">>>>  %@",self.view.subviews);
    
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
