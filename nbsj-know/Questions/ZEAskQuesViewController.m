//
//  ZEAskQuesViewController.m
//  nbsj-know
//
//  Created by Stenson on 16/8/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAskQuesViewController.h"
#import "ZEAskQuesView.h"

#import "ZELookViewController.h"
#import "ZEQuestionTypeCache.h"
#define textViewStr @"试着将问题尽可能清晰的描述出来，这样回答者们才能更完整、更高质量的为您解答。不能超过50个字符。"

@interface ZEAskQuesViewController ()<ZEAskQuesViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZELookViewControllerDelegate>
{
    ZEAskQuesView * askView;
    NSDictionary * showQuesTypeDic;
}

@property (nonatomic,retain) NSMutableArray * imagesArr;

@end

@implementation ZEAskQuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"描述你的问题";
    [self.rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.imagesArr = [NSMutableArray array];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView
{
    askView = [[ZEAskQuesView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    askView.delegate = self;
    [self.view addSubview:askView];
    [self.view sendSubviewToBack:askView];
}

#pragma mark - ZEAskQuesViewDelegate

-(void)takePhotosOrChoosePictures
{
    
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
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
    if (self.imagesArr.count == 3) {
        [self showTips:@"最多上传三张照片"];
        return;
    }

    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isTaking) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [askView reloadChoosedImageView:chooseImage];
    [self.imagesArr addObject:chooseImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goLookImageView:(NSArray *)imageArr
{
    ZELookViewController * lookVC = [[ ZELookViewController alloc]init];
    lookVC.delegate = self;
    lookVC.imageArr = self.imagesArr;
    [self.navigationController pushViewController:lookVC animated:YES];
}

-(void)goBackViewWithImages:(NSArray *)imageArr
{
    self.imagesArr = [NSMutableArray arrayWithArray:imageArr];
    [askView reloadChoosedImageView:imageArr];
}

-(void)showQuestionType:(ZEAskQuesView *)askQuesView
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [askQuesView showQuestionTypeViewWithData:typeArr];
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"ISENABLED=1",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.operation.business.AppBizOperation",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:nil];
                                 [askQuesView showQuestionTypeViewWithData:[ZEUtil getServerData:data withTabelName:KLB_QUESTION_TYPE]];
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:nil];
                             }];
}


-(void)rightBtnClick
{
    NSLog(@">>   %@",askView.inputView.text);
    if ([askView.inputView.text isEqualToString:textViewStr]) {
        [self showAlertView:@"请输入问题说明" isBack:NO];
        return;
    }else if (askView.inputView.text.length < 5){
        [self showAlertView:@"请详细输入问题说明" isBack:NO];
        return;
    }else if (![ZEUtil isStrNotEmpty:askView.quesTypeSEQKEY]){
        [self showAlertView:@"请选择问题分类" isBack:NO];
        return;
    }
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"ISLOSE=1",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.biz.klb.Score",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUESTIONTYPECODE":askView.quesTypeSEQKEY,
                                @"QUESTIONEXPLAIN":askView.inputView.text,
                                @"QUESTIONIMAGE":@"",
                                @"USERHEADIMAGE":[ZESettingLocalData getUSERHHEADURL],
                                @"QUESTIONUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONUSERNAME":[ZESettingLocalData getNICKNAME],
                                @"QUESTIONLEVEL":@"1",
                                @"IMPORTLEVEL":@"1",
                                @"ISLOSE":@"0",
                                @"ISEXPERTANSWER":@"0",
                                @"ISSOLVE":@"0"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:self.imagesArr
                           showAlertView:YES
                                 success:^(id data) {
                                     [self progressEnd:nil];
                                     [self showAlertView:@"问题发表成功" isBack:YES];
                                 } fail:^(NSError *error) {
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
