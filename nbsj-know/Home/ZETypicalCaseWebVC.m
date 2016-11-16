//
//  ZETypicalCaseWebVC.m
//  nbsj-know
//
//  Created by Stenson on 16/11/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseWebVC.h"

@interface ZETypicalCaseWebVC ()<UIWebViewDelegate>

@end

@implementation ZETypicalCaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = nil;
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    [self.view addSubview:web];
    web.delegate = self;
    [web setScalesPageToFit:YES];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_filePath]];
    [web loadRequest:urlRequest];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self progressBegin:@""];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self showTips:@"加载完成"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showTips:@"文件格式不支持"];
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
