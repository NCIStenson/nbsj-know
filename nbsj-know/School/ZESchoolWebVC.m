//
//  ZESchoolWebVC.m
//  nbsj-know
//
//  Created by Stenson on 17/2/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESchoolWebVC.h"

@interface ZESchoolWebVC ()<UIWebViewDelegate>
{
    UIWebView * webView;
}
@end

@implementation ZESchoolWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

    self.leftBtn.width = 80.0f;
    [self.leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [self.leftBtn.titleLabel setFont:[UIFont systemFontOfSize:kTiltlFontSize]];
    [self.leftBtn addTarget:self action:@selector(goBackWebView) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"学堂";
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navBar addSubview:closeButton];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.left = 80;
    closeButton.top = 20.0f;
    closeButton.size = CGSizeMake(40, 44);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(goBackWebHomeView) forControlEvents:UIControlEventTouchUpInside];
    
    [self initWebView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [webView loadRequest:[NSURL URLWithString:nil]];
//    [webView removeFromSuperview];
//    webView = nil;
//    webView.delegate = nil;
//    [webView stopLoading];
}


-(void)initWebView
{
     webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 49.0f)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dzd.nbuen.com/mobile/media_app.php"]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
} 


-(void)goBackWebView
{
    if([webView canGoBack]){
        [webView goBack];
    }
}

-(void)goBackWebHomeView
{
    [webView stopLoading];
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
