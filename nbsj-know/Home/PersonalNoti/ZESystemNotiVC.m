//
//  ZESystemNotiVC.m
//  nbsj-know
//
//  Created by Stenson on 17/5/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kRowHeight (SCREEN_WIDTH / 3 * 3 / 4 + 20)

#import "ZESystemNotiVC.h"
#import "ZESchoolWebVC.h"

@interface ZESystemNotiVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * systemNotiDataArr;
    UITableView * contentTableView;
}
@end

@implementation ZESystemNotiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
//    YYImage *image = [YYImage imageNamed:@"building.gif"];
//    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//    imageView.frame = CGRectMake(0, NAV_HEIGHT + 60.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT - 35.0f );
//    [self.view addSubview:imageView];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"ZESystemNotiVC.h");
    [self getSystemNotiList];
}

-(void)getSystemNotiList
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":KLB_SYSTEM_NOTICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
//                                     @"start":[NSString stringWithFormat:@"%ld",_currentPageCount * MAX_PAGE_COUNT],
                                     @"start":[NSString stringWithFormat:@"0"],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SYSTEM_NOTICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageSystem"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_SYSTEM_NOTICE];
                                 
                                 systemNotiDataArr = [NSMutableArray arrayWithArray:dataArr];
                                 [contentTableView reloadData];
//                                 if(dataArr.count == 0  && _currentPageCount == 0){
//                                     //  没有数据时 取消表的编辑状态
//                                     [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_PERSONAL_WITHOUTDYNAMIC object:nil];
//                                 }
//                                 if (dataArr.count > 0) {
//                                     if (_currentPageCount == 0) {
//                                         [_personalNotiView reloadFirstView:dataArr];
//                                     }else{
//                                         [_personalNotiView reloadContentViewWithArr:dataArr];
//                                     }
//                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
//                                         _currentPageCount += 1;
//                                     }
//                                 }else{
//                                     if (_currentPageCount > 0) {
//                                         [_personalNotiView loadNoMoreData];
//                                         return ;
//                                     }
//                                     [_personalNotiView reloadFirstView:dataArr];
//                                     [_personalNotiView headerEndRefreshing];
//                                     [_personalNotiView loadNoMoreData];
//                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)initView{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 60.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 60.0f) style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self.view addSubview:contentTableView];
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    [self createContentCellView:systemNotiDataArr[indexPath.row] withCellView:cell.contentView];
    
    return cell;
}

-(void)createContentCellView:(NSDictionary *)dataDic withCellView:(UIView *)cell
{
    NSLog(@"  = =   %@",dataDic);
    
    NSString * FILEURL = [[[dataDic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString * TITLE = [dataDic objectForKey:@"TITLE"];
    NSString * REMARK = [dataDic objectForKey:@"REMARK"];
    NSString * SYSUPDATEDATE = [dataDic objectForKey:@"SYSUPDATEDATE"];
    
    UIImageView * typicalImageView = [[UIImageView alloc]init];
    [cell addSubview:typicalImageView];
    typicalImageView.width = SCREEN_WIDTH / 3;
    typicalImageView.height = SCREEN_WIDTH / 3 * 3 / 4;
    typicalImageView.left = 10;
    typicalImageView.top = 10;
    typicalImageView.clipsToBounds = YES;
    typicalImageView.layer.cornerRadius =  5;
    //        typicalImageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([ZEUtil isStrNotEmpty:FILEURL]) {
        NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(FILEURL)] ;
        [typicalImageView sd_setImageWithURL:fileURL placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }
    
    UILabel * typicalDetailName = [[UILabel alloc]init];
    typicalDetailName.frame = CGRectMake(typicalImageView.right + 10.0f , typicalImageView.top + 10.0f , cell.width -  typicalImageView.right + 20 , 20);
    [cell addSubview:typicalDetailName];
    typicalDetailName.textColor = kTextColor;
    typicalDetailName.text = TITLE;

    UILabel * typicalSubDetailName = [[UILabel alloc]init];
    typicalSubDetailName.frame = CGRectMake(typicalDetailName.left , ( typicalDetailName.bottom + 5.0f ), typicalDetailName.width, 40);
    
    [cell addSubview:typicalSubDetailName];
    typicalSubDetailName.font = [UIFont systemFontOfSize:14];
    typicalSubDetailName.text = REMARK;
    typicalSubDetailName.numberOfLines = 2;
    typicalSubDetailName.textColor = MAIN_SUBBTN_COLOR;
//    typicalSubDetailName.backgroundColor = MAIN_ARM_COLOR;
    
    
    UILabel * dateLab = [[UILabel alloc]initWithFrame:CGRectMake(typicalSubDetailName.left, typicalSubDetailName.bottom, typicalSubDetailName.width, 20)];
    dateLab.textColor = MAIN_SUBBTN_COLOR;
    dateLab.textAlignment = NSTextAlignmentRight;
//    dateLab.backgroundColor = [UIColor redColor];
    dateLab.font = [UIFont systemFontOfSize:12];

    [cell addSubview:dateLab];
    
    dateLab.text = [NSString stringWithFormat:@"发布日期：%@",[SYSUPDATEDATE stringByReplacingOccurrencesOfString:@".0" withString:@""]];
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, kRowHeight - 0.5, SCREEN_WIDTH, 0.5);
    [cell addSubview:lineView];
    lineView.backgroundColor = MAIN_LINE_COLOR;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return systemNotiDataArr.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = systemNotiDataArr[indexPath.row];
    NSString * URLPATH = [dic objectForKey:@"URLPATH"];
    
    NSString * CONTENTHTM = [dic objectForKey:@"CONTENTHTM"];


    if(URLPATH.length == 0 && CONTENTHTM.length == 0){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = @"该系统通知无详情展示";
        [hud3 hide:YES afterDelay:1.0f];
        return;
    }
    
    ZESchoolWebVC * webVC = [[ZESchoolWebVC alloc]init];
    webVC.webURL = URLPATH;
    webVC.htmlStr = CONTENTHTM;
    webVC.enterType = ENTER_WEBVC_SYSTEMNOTI;
    [self.navigationController pushViewController:webVC animated:YES];
    
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
