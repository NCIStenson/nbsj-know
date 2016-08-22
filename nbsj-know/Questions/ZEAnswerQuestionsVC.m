//
//  ZEAnswerQuestionsVC.m
//  nbsj-know
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerQuestionsVC.h"
#import "ZEAnswerQuestionsView.h"

@interface ZEAnswerQuestionsVC ()
{
    ZEAnswerQuestionsView * _answerQuesView;
}
@end

@implementation ZEAnswerQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"回答";
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
}

-(void)initView
{
    _answerQuesView = [[ZEAnswerQuestionsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_answerQuesView];
    [self.view sendSubviewToBack:_answerQuesView];
}

-(void)rightBtnClick
{
    if (_answerQuesView.answerText.text.length == 0){
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    NSString * ANSWERLEVEL = nil;
    if ([ZESettingLocalData getISEXPERT]) {
        ANSWERLEVEL = @"2";
    }else{
        ANSWERLEVEL = @"1";
    }
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUERTIONID":_questionSEQKEY,
                                @"ANSWEREXPLAIN":_answerQuesView.answerText.text,
                                @"ANSWERIMAGE":@"",
                                @"ANSWERUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"ANSWERUSERNAME":[ZESettingLocalData getNICKNAME],
                                @"ANSWERLEVEL":ANSWERLEVEL,
                                @"ISPASS":@"0",
                                @"ISENABLED":@"0",
                                @"GOODNUMS":@"0"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 NSLog(@">>  %@",data);
                                 [self showAlertView:@"回答成功" isBack:YES];
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
    

}

-(void)showAlertView:(NSString *)alertMsg isBack:(BOOL)isBack
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isBack) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
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
