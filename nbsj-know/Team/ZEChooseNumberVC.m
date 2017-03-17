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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_TEAMCODE.length > 0) {
        [self sendNumbersRequest];
    }
}
-(void)sendNumbersRequest
{
    if (_TEAMCODE.length > 0) {
        self.title = @"选择团队成员";
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.rightBtn removeTarget:self action:@selector(deleteNumbers) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(finishChooseTeamMembers) forControlEvents:UIControlEventTouchUpInside];

    }

    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"USERTYPE DESC",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.UserInfo",
                                     @"DETAILTABLE":@"",};
    
//    NSDictionary * fieldsDic =@{@"TEAMCIRCLECODE":_teamCircleInfo.SEQKEY,
//                                @"USERCODE":@"",
//                                @"USERNAME":@"",
//                                @"FILEURL":@"",
//                                @"USERTYPE":@""};
//    if ( _TEAMCODE.length > 0) {
      NSDictionary *  fieldsDic =@{@"TEAMCIRCLECODE":_TEAMCODE,
                     @"USERCODE":@"",
                     @"USERNAME":@"",
                     @"FILEURL":@"",
                     @"USERTYPE":@""};
        
//    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_REL_USER];
                                 if (arr.count > 0) {
                                     _numbersArr = [NSMutableArray arrayWithArray: arr];
                                     [chooseNumberView reloadViewWithAlreadyInviteNumbers:_numbersArr];

                                     //                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:arr];
                                 }else{
                                     //                                         [self showTips:@"暂无相关成员~"];
                                 }
                             } fail:^(NSError *error) {
                             }];
    
}


-(void)initView
{
    chooseNumberView = [[ZEChooseNumberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:chooseNumberView];
    [self.view sendSubviewToBack:chooseNumberView];
    [chooseNumberView reloadViewWithAlreadyInviteNumbers:_numbersArr];
    chooseNumberView.TEAMCODE = _TEAMCODE;
}

-(void)deleteNumbers
{
    NSMutableArray * addMembersArr = [NSMutableArray array];
    NSMutableArray * subMembersArr = [NSMutableArray array];
    
    for (int i = 0; i < _numbersArr.count; i ++) {
        BOOL mask  = [chooseNumberView.maskArr[i] boolValue];
        if (!mask) {
            [addMembersArr addObject:_numbersArr[i]];
        }else{
            [subMembersArr addObject:_numbersArr[i]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_DELETE_TEAMCIRCLENUMBERS object:addMembersArr];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)leftBtnClick {
    if (_TEAMCODE.length > 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)finishChooseTeamMembers
{
    NSMutableArray * addMembersArr = [NSMutableArray array];
    NSMutableArray * subMembersArr = [NSMutableArray array];
    
    for (int i = 0; i < _numbersArr.count; i ++) {
        BOOL mask  = [chooseNumberView.maskArr[i] boolValue];
        if (!mask) {
            [addMembersArr addObject:_numbersArr[i]];
        }else{
            [subMembersArr addObject:_numbersArr[i]];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_CHOOSE_TEAMCIRCLENUMBERS object:subMembersArr];
    [self dismissViewControllerAnimated:YES completion:nil];

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
