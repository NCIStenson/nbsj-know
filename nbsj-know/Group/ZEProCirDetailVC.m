//
//  ZEProCirDetailVC.m
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEProCirDetailVC.h"
#import "ZEProCirDeatilView.h"
@interface ZEProCirDetailVC ()

@end

@implementation ZEProCirDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _PROCIRCLENAME;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
        [self.rightBtn setTitle:@"加入他们" forState:UIControlStateNormal];
    }
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self isShowJoin];
}

-(void)isShowJoin
{
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"PROCIRCLECODE='%@' and USERCODE='%@'",_PROCIRCLECODE,[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_PROCIRCLE_REL_USER];
                                 if(arr.count == 0){
                                     self.rightBtn.hidden = NO;
                                 }else{
                                     self.rightBtn.hidden = YES;
                                 }
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
}

-(void)rightBtnClick
{
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"PROCIRCLECODE":_PROCIRCLECODE,
                                @"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"STATUS":@"1",
                                @"NICKNAME":[ZESettingLocalData getNICKNAME],
                                @"USERNAME":[ZESettingLocalData getUSERNAME],
                                @"USERTYPE":[ZESettingLocalData getUSERTYPE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"加入成功"];
                                 self.rightBtn.hidden = YES;
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
}

-(void)initView{
    ZEProCirDeatilView * detailView = [[ZEProCirDeatilView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:detailView];
    [self.view sendSubviewToBack:detailView];
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
