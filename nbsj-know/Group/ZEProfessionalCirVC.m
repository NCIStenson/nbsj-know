//
//  ZEProfessionalCirVC.m
//  nbsj-know
//
//  Created by Stenson on 16/9/26.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define PROCIRCLECODE(dic) [dic objectForKey:@"PROCIRCLECODE"]
#define PROCIRCLENAME(dic) [dic objectForKey:@"PROCIRCLENAME"]
#define SEQKEY(dic) [dic objectForKey:@"SEQKEY"]

#import "ZEProfessionalCirVC.h"
#import "ZEQuestionTypeCache.h"
#import "ZEProCirDetailVC.h"

@interface ZEProfessionalCirVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * profContentView;
    UITableView * contentView;
}

@property (nonnull,nonatomic,strong) NSMutableArray * datasArr;

@end

@implementation ZEProfessionalCirVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datasArr = [NSMutableArray array];
    [self initView];
    [self sendRequest];
}

#pragma mark - Request

-(void)sendRequest
{
    NSString * WHERESQL = @"";
    NSString * ORDERSQL = @"";
    NSString * tableName = KLB_PROCIRCLE_INFO;
    if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
        WHERESQL = [NSString stringWithFormat:@"USERCODE='%@'",[ZESettingLocalData getUSERCODE]];
        tableName = KLB_PROCIRCLE_REL_USER;
        ORDERSQL = @"SYSCREATEDATE desc";
    }else{
        tableName = V_KLB_PROCIRCLE_POSITION;
        ORDERSQL = @"procirclepoints desc";
        NSArray * dataArr = [[ZEQuestionTypeCache instance]getProCircleCaches];
        if (dataArr.count > 0) {
            self.datasArr = [NSMutableArray arrayWithArray:dataArr];
            return;
        }
    }
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":tableName,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":ORDERSQL,
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[tableName]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];

                                 NSArray * arr = [NSMutableArray arrayWithArray:[ZEUtil getServerData:data withTabelName:tableName]];
                                 if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
                                     [self reloadMyCircleView:arr];
                                 }else if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT){
                                     self.datasArr = [NSMutableArray arrayWithArray:arr];
                                     [[ZEQuestionTypeCache instance] setProCircleCaches:arr];
                                     [contentView reloadData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }];
}

-(void)reloadMyCircleView:(NSArray *)arr
{
    NSArray * cacheArr = [[ZEQuestionTypeCache instance] getProCircleCaches];
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary * dic = arr[i];
        for (int j = 0; j < cacheArr.count; j ++) {
            NSDictionary * cacheDic = cacheArr[j];
            if ([[dic objectForKey:@"PROCIRCLECODE"] isEqualToString:[cacheDic objectForKey:@"PROCIRCLECODE"]]) {
                [self.datasArr addObject:cacheDic];
                break;
            }
        }
    }
    [contentView reloadData];
}

-(void)initView{
    float cellHeight = SCREEN_HEIGHT - NAV_HEIGHT - 89.0f;
    if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
        cellHeight = SCREEN_HEIGHT - NAV_HEIGHT - 49.0f;
    }
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 40.0f, SCREEN_WIDTH, cellHeight) style:UITableViewStylePlain];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.view addSubview:contentView];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = SCREEN_HEIGHT - NAV_HEIGHT - 89.0f;
    if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
        cellHeight = SCREEN_HEIGHT - NAV_HEIGHT - 49.0f;
    }
    if (self.datasArr.count / 3 * 60 > cellHeight) {
        return self.datasArr.count / 3 * 60;
    }
    
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [self initCellView:cell.contentView indexPath:indexPath];
    return cell;
}


-(void)initCellView:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    NSInteger count = 0;
    if(self.datasArr.count%3 == 0){
        count = self.datasArr.count / 3;
    }else{
        count = self.datasArr.count / 3 + 1;
    }
    
    for (int i = 0 ; i < count; i ++) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 5 + 60 * i, SCREEN_WIDTH, 1);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        
        if (i == count - 1) {
            CALayer * lastLineLayer = [CALayer layer];
            lastLineLayer.frame = CGRectMake(0, 5 + 60 * (i + 1), SCREEN_WIDTH, 1);
            [superView.layer addSublayer:lastLineLayer];
            lastLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        }
        
        for (int j = 1; j < 4; j ++ ) {
            if (i * 3 + j > self.datasArr.count) {
                return;
            }else if (i * 3 + j < 4){
                UILabel * listLabel;
                listLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 5 + 60 * i, 35, 30)];
                [superView addSubview:listLabel];
                listLabel.font = [UIFont boldSystemFontOfSize:18];
                listLabel.textAlignment = NSTextAlignmentCenter;
                
                switch (i * 3 + j) {
                    case 1:
                        listLabel.text = @"1st";
                        listLabel.textColor = [UIColor redColor];
                        break;
                    case 2:
                        listLabel.text = @"2nd";
                        listLabel.textColor = [UIColor blueColor];
                        break;
                    case 3:
                        listLabel.text = @"3rd";
                        listLabel.textColor = [UIColor greenColor];
                        break;
                        
                    default:
                        break;
                }

            }
            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(SCREEN_WIDTH / 3 * j, 5 + 60 * i, 1, 60);
            [superView.layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

            UIButton * professionalBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            professionalBtn.frame = CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 15 + 60 * i, SCREEN_WIDTH / 3, 50.0f);
            if (i * 3 + j > 4){
                professionalBtn.frame = CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 5 + 60 * i, SCREEN_WIDTH / 3, 60.0f);
            }
            professionalBtn.tag = i * 3 + j;
            [professionalBtn addTarget:self action:@selector(goDeatailVC:) forControlEvents:UIControlEventTouchUpInside];
            professionalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [professionalBtn setTitle:PROCIRCLENAME(self.datasArr[i*3+j-1]) forState:UIControlStateNormal];
            [professionalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [superView addSubview:professionalBtn];
            
        }
    }
}



-(void)goDeatailVC:(UIButton *)btn{
    
    ZEProCirDetailVC * detailVC = [[ZEProCirDetailVC alloc]init];
    detailVC.enter_group_type = self.enter_group_type;
    detailVC.PROCIRCLECODE = [self.datasArr[btn.tag - 1] objectForKey:@"PROCIRCLECODE"];
    detailVC.PROCIRCLENAME = [self.datasArr[btn.tag - 1] objectForKey:@"PROCIRCLENAME"];
    [self.navigationController pushViewController:detailVC animated:YES];
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
