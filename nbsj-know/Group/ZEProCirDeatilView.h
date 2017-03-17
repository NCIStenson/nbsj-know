//
//  ZEProCirDeatilView.h
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEProCirDetailView;
@protocol ZEProCirDeatilViewDelegate <NSObject>


/**
 展示动态
 */
-(void)goDynamic;


/**
 更多经典案例
 */
-(void)goMoreCaseVC;


/**
 *  @author Stenson, 17-03-17 10:07:18
 *
 *  去经典案例详情
 */
-(void)goTypicalDetail:(NSDictionary *)detailDic;

@end

@interface ZEProCirDeatilView : UIView

@property (nonatomic,weak) id <ZEProCirDeatilViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadSection:(NSInteger)section
            scoreDic:(NSDictionary *)dic
          memberData:(id)data;

-(void)reloadCaseView:(NSArray *)arr;

@end
