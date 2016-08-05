//
//  ZESinginVC.m
//  nbsj-know
//
//  Created by Stenson on 16/7/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESinginVC.h"
#import "JFCalendarPickerView.h"

@interface ZESinginVC ()

@end

@implementation ZESinginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    [self setRightBtnTitle:@"签到"];
    [self initCalendarPickView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initCalendarPickView{
    
    JFCalendarPickerView *calendarPicker = [[JFCalendarPickerView alloc]initWithFrame:CGRectZero];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 64, SCREEN_WIDTH, 360);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@">>  %@",[NSString stringWithFormat:@"\n日：%ld\n月：%ld\n年：%ld",(long)day, (long)month, (long)year]);
    };
    [self.view addSubview:calendarPicker];
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
