//
//  ZECreateTeamVC.m
//  nbsj-know
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZECreateTeamVC.h"
#import "ZECreateTeamView.h"

#import "ZEQueryNumberVC.h"
#import "ZEChooseNumberVC.h"

#import "ZETeamCircleModel.h"
@interface ZECreateTeamVC ()<ZECreateTeamViewDelegate>
{
    ZECreateTeamView * createTeamView;
    UIImage * _choosedImage;
    NSArray * _numbersArr;
}
@end

@implementation ZECreateTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"创建团队";
    [self.rightBtn setTitle:@"确认创建" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(createTeamData) forControlEvents:UIControlEventTouchUpInside];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNumbersView:) name:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:nil];;

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:nil];
}


-(void)reloadNumbersView:(NSNotification *)noti
{
    _numbersArr = noti.object;
    [createTeamView.numbersView reloadNumbersView:noti.object];
}

-(void)initView{
    createTeamView = [[ZECreateTeamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    createTeamView.delegate = self;
    [self.view addSubview:createTeamView];
    [self.view sendSubviewToBack:createTeamView];
}

#pragma mark - 创建班组圈发送请求

-(void)createTeamData
{
    [self.view endEditing:YES];
    NSString * TEAMCIRCLENAME = createTeamView.messageView.teamNameField.text;
    NSString * TEAMMANIFESTO = createTeamView.messageView.manifestoTextView.text;
    NSString * TEAMCIRCLEREMARK = createTeamView.messageView.profileTextView.text;
    NSString * TEAMCIRCLECODE = createTeamView.messageView.TEAMCIRCLECODE;
    NSString * TEAMCIRCLECODENAME =createTeamView.messageView.TEAMCIRCLECODENAME;
    
    if (TEAMCIRCLENAME.length == 0|| TEAMCIRCLEREMARK.length == 0 ||  TEAMMANIFESTO.length == 0 || TEAMCIRCLECODENAME.length == 0) {
        [self showTips:@"请完善班组圈信息"];
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_INFO,
                                     @"DETAILTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"TEAMCIRCLECODE",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"TEAMCIRCLENAME":TEAMCIRCLENAME,
                                @"TEAMCIRCLEREMARK":TEAMCIRCLEREMARK,
                                @"TEAMMANIFESTO":TEAMMANIFESTO,
                                @"TEAMCIRCLECODE":TEAMCIRCLECODE,
                                @"TEAMCIRCLECODENAME":TEAMCIRCLECODENAME,
                                };
    NSMutableArray * tableArr = [NSMutableArray arrayWithArray:@[KLB_TEAMCIRCLE_INFO]];
    NSMutableArray * fieldsArr = [NSMutableArray arrayWithArray:@[fieldsDic]];
    
    for (int i = 0; i < createTeamView.numbersView.alreadyInviteNumbersArr.count; i ++) {
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:createTeamView.numbersView.alreadyInviteNumbersArr[i]];
        NSDictionary * numbersFieldsDic = @{@"USERCODE":userinfo.USERCODE,
                                            @"USERTYPE":@"1"};
        
        [tableArr addObject:KLB_TEAMCIRCLE_REL_USER];
        [fieldsArr addObject:numbersFieldsDic];
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:tableArr
                                                                           withFields:fieldsArr
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    if([ZEUtil isNotNull:_choosedImage]){
        [ZEUserServer uploadImageWithJsonDic:packageDic
                                withImageArr:@[_choosedImage]
                               showAlertView:NO
                                     success:^(id data) {
                                         [self showTips:@"创建成功"];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     } fail:^(NSError *errorCode) {
                                         
                                     }];
    }else{
        [ZEUserServer getDataWithJsonDic:packageDic
                               showAlertView:YES
                                     success:^(id data) {
                                         [self showTips:@"创建成功"];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     } fail:^(NSError *error) {
                                         
                                     }];

    }
}
#pragma mark - 上传头像

-(void)takePhotosOrChoosePictures
{
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:YES];
    }];
    UIAlertAction * chooseAction = [UIAlertAction actionWithTitle:@"选择一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:NO];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCont addAction:takeAction];
    [alertCont addAction:chooseAction];
    [alertCont addAction:cancelAction];
    
    [self presentViewController:alertCont animated:YES completion:^{
        
    }];
}


/**
 *  @author Stenson, 16-08-01 16:08:07
 *
 *  选取照片
 *
 *  @param isTaking 是否拍照
 */
-(void)showImagePickController:(BOOL)isTaking;
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isTaking) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _choosedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [createTeamView.messageView reloadTeamHeadImageView:_choosedImage];
//    NSDictionary * parametersDic = @{@"limit":@"20",
//                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
//                                     @"MENUAPP":@"EMARK_APP",
//                                     @"ORDERSQL":@"",
//                                     @"WHERESQL":@"",
//                                     @"start":@"0",
//                                     @"METHOD":@"updateSave",
//                                     @"MASTERFIELD":@"SEQKEY",
//                                     @"DETAILFIELD":@"",
//                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
//                                     @"DETAILTABLE":@"",};
//    
//    NSDictionary * fieldsDic =@{@"SEQKEY":[ZESettingLocalData getUSERCODE],
//                                @"USERCODE":[ZESettingLocalData getUSERCODE],
//                                @"FILEURL":@""};
//    
//    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
//                                                                           withFields:@[fieldsDic]
//                                                                       withPARAMETERS:parametersDic
//                                                                       withActionFlag:nil];
//    [ZEUserServer uploadImageWithJsonDic:packageDic
//                            withImageArr:@[_choosedImage]
//                           showAlertView:YES
//                                 success:^(id data) {
//                                     NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
//                                     if (arr.count > 0) {
//
//                                     }
//                                 } fail:^(NSError *error) {
//                                 }];
}


#pragma mark - ZECreateTeamViewDelegate

-(void)goQueryNumberView
{
    ZEQueryNumberVC * queryNumberVC = [[ZEQueryNumberVC alloc]init];
    
    [self.navigationController pushViewController:queryNumberVC animated:YES];
    
}

-(void)goRemoveNumberView
{
    ZEChooseNumberVC* chooseNumberVC = [[ZEChooseNumberVC alloc]init];
    chooseNumberVC.numbersArr = [NSMutableArray arrayWithArray:_numbersArr];
    [self.navigationController pushViewController:chooseNumberVC animated:YES];
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
