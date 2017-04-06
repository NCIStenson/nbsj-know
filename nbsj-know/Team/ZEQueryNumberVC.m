//
//  ZEQueryNumberVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQueryNumberVC.h"

@interface ZEQueryNumberVC ()
{
    ZEQueryNumberView * queryNumberView;
}
@end

@implementation ZEQueryNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftBtn.superview.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}
-(void)initView
{
    queryNumberView = [[ZEQueryNumberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    queryNumberView.delegate = self;
    [self.view addSubview:queryNumberView];
    queryNumberView.alreadyInviteNumbersArr = [NSMutableArray arrayWithArray:self.alreadyInviteNumbersArr];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goSearch:(NSString *)searchStr
{
    if (searchStr.length < 8) {
        [self showTips:@"请输入八位工号"];
        return;
    }else if (searchStr.length > 8){
        [self showTips:@"输入的工号位数过多"];
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",searchStr],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO] ;
                                 if ([arr count] > 0) {
                                     [queryNumberView showSearchNumberResult:arr];
                                 }else{
                                     [self showTips:@"查无此人，请检查输入工号" afterDelay:1.5];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
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
