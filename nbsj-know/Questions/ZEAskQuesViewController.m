//
//  ZEAskQuesViewController.m
//  nbsj-know
//
//  Created by Stenson on 16/8/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAskQuesViewController.h"
#import "ZEAskQuesView.h"
#import "ZEAskQuestionTypeView.h"

#import "ZELookViewController.h"
#import "ZEQuestionTypeCache.h"

#define textViewStr @"试着将问题尽可能清晰的描述出来，这样回答者们才能更完整、更高质量的为您解答。不能超过50个字符。"

@interface ZEAskQuesViewController ()<ZEAskQuesViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZELookViewControllerDelegate,ZEAskQuestionTypeViewDelegate>
{
    ZEAskQuesView * askView;
    ZEAskQuestionTypeView * askTypeView;
    NSDictionary * showQuesTypeDic;
    
    NSString * questionTypeCode;
}

@property (nonatomic,retain) NSMutableArray * imagesArr;

@end

@implementation ZEAskQuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imagesArr = [NSMutableArray array];
    [self initAskTypeView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self cacheQuestionType];
}
-(void)cacheQuestionType
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES ];
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"ISENABLED=1",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:KLB_QUESTION_TYPE]];
                                 [askTypeView reloadData];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                             }];
}

-(void)initAskTypeView
{
    self.title = @"问题分类";
    self.rightBtn.enabled = NO;
    
    askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    askTypeView.delegate = self;
    [self.view addSubview:askTypeView];
    [self.view sendSubviewToBack:askTypeView];
    
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [askTypeView reloadData];
    }

}

-(void)initView
{
    self.title = @"描述你的问题";

    self.rightBtn.enabled = YES;
    [self.rightBtn setTitle:@"发送" forState:UIControlStateNormal];

    askView = [[ZEAskQuesView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    askView.delegate = self;
    [self.view addSubview:askView];
    [self.view sendSubviewToBack:askView];
}
#pragma mark - ZEAskQuestionTypeViewDelegate

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode
{
    questionTypeCode = typeCode;
    [askTypeView removeFromSuperview];
    [self initView];
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
                                     @"CLASSNAME":BASIC_CLASS_NAME,
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
#pragma mark - 确认输入信息

-(void)leftBtnClick
{
    if ([askView.inputView.text isEqualToString:textViewStr] || [askView.inputView.text length] == 0 ) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"现在退出编辑，你输入的内容将不会被保存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCont addAction:okAction];
    [alertCont addAction:cancelAction];
    
    [self presentViewController:alertCont animated:YES completion:nil];
}

-(void)rightBtnClick
{
    if ([askView.inputView.text isEqualToString:textViewStr]) {
        [self showAlertView:@"请输入问题说明" isBack:NO];
        return;
    }else if (askView.inputView.text.length < 5){
        [self showAlertView:@"请详细输入问题说明" isBack:NO];
        return;
    }else{
        UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"是否确定提交问题" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self insertData];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCont addAction:okAction];
        [alertCont addAction:cancelAction];
        
        [self presentViewController:alertCont animated:YES completion:nil];
    }
}

-(void)insertData
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"ISLOSE=1",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUESTIONTYPECODE":questionTypeCode,
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
