//
//  ZETeamChatRoomVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamChatRoomVC.h"
//#import <JMUIChattingKit/JMUIMessageTableViewCell.h>
@interface ZETeamChatRoomVC ()

@end

@implementation ZETeamChatRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MAIN_NAV_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChatImage:) name:kJMESSAGE_TAP_IMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPersonalMessage:) name:kJMESSAGE_TAP_HEADVIEW object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)showChatImage:(NSNotification *)noti
{
    
    NSLog(@"展示聊天图片。。。");
    
    UIImage * image = noti.object;
    PYPhotoBrowseView * browseView = [[PYPhotoBrowseView alloc]initWithFrame:self.view.frame];
    browseView.images = @[image];
    [browseView show];
    
//     TODO: get image model
//      JMUIChatModel *model = tableViewCell.model;
//      [_messageDatasource getImageIndex:model];   //获得点击图片所在图片的位置
//      _messageDatasource.imgMsgModelArr;  // 当前会话所有显示的图片 model（JMUIChatModel）
//    NSLog(@"tap image content");
}

-(void)showPersonalMessage:(NSNotification *)noti
{
    NSLog(@" 点击用户头像     >>>>>>>>  %@",noti.object);
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
