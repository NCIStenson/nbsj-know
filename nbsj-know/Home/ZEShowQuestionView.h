//
//  ZEShowQuestionView.h
//  nbsj-know
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEShowQuestionView;

@protocol ZEShowQuestionViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZEShowQuestionView : UIView

@property (nonatomic,weak) id <ZEShowQuestionViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

@end
