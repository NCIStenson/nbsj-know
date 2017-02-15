//
//  ZESchoolWebVC.m
//  nbsj-know
//
//  Created by Stenson on 17/2/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESchoolWebVC.h"

@interface ZESchoolWebVC ()

@end

@implementation ZESchoolWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

    self.leftBtn.hidden = YES;
    self.title = @"学堂";
    [self initWebView];
    
}

-(void)initWebView
{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 49.0f)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dzd.nbuen.com/mobile/media_app.php"]]];
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
