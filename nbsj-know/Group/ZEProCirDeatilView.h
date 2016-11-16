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

-(void)goDynamic;

@end

@interface ZEProCirDeatilView : UIView

@property (nonatomic,weak) id <ZEProCirDeatilViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadSection:(NSInteger)section
            scoreDic:(NSDictionary *)dic
          memberData:(id)data;
@end
