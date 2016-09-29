//
//  ZEProfessionalCirVC.m
//  nbsj-know
//
//  Created by Stenson on 16/9/26.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEProfessionalCirVC.h"

#import "ZEProCirDetailVC.h"

@interface ZEProfessionalCirVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * profContentView;
}
@end

@implementation ZEProfessionalCirVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
}

-(void)initView{
    UITableView * contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 40.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 89.0f) style:UITableViewStylePlain];
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
    return SCREEN_HEIGHT - NAV_HEIGHT - 89.0f;
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
    NSInteger count = 10;
    for (int i = 0 ; i < count / 3 + 1 ; i ++) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 5 + 60 * i, SCREEN_WIDTH, 1);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        
        if (i == count/3 ) {
            CALayer * lastLineLayer = [CALayer layer];
            lastLineLayer.frame = CGRectMake(0, 5 + 60 * (i + 1), SCREEN_WIDTH, 1);
            [superView.layer addSublayer:lastLineLayer];
            lastLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        }
        
        for (int j = 1; j < 4; j ++ ) {
    
            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(SCREEN_WIDTH / 3 * j, 5 + 60 * i, 1, 60);
            [superView.layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
            
            if (i * 3 + j > count) {
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
            
            UIButton * professionalBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            professionalBtn.frame = CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 15 + 60 * i, SCREEN_WIDTH / 3, 50.0f);
            if (i * 3 + j > 4){
                professionalBtn.frame = CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 5 + 60 * i, SCREEN_WIDTH / 3, 60.0f);
            }
            professionalBtn.tag = i * 3 + j;
            [professionalBtn addTarget:self action:@selector(goDeatailVC:) forControlEvents:UIControlEventTouchUpInside];
            professionalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [professionalBtn setTitle:@"变电运输" forState:UIControlStateNormal];
            [professionalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [superView addSubview:professionalBtn];
            
        }
    }
}



-(void)goDeatailVC:(UIButton *)btn{
    ZEProCirDetailVC * detailVC = [[ZEProCirDetailVC alloc]init];
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
