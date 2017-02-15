//
//  ZEAskQuesView.h
//  nbsj-know
//
//  Created by Stenson on 16/8/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEAskQuesView;

@protocol ZEAskQuesViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-17 15:08:49
 *
 *  拍照还是选择图片
 */
-(void)takePhotosOrChoosePictures;
/**
 *  @author Stenson, 16-08-17 15:08:08
 *
 *  图片预览
 *
 *  @param imageArr <#imageArr description#>
 */
-(void)goLookImageView:(NSArray *)imageArr;

/**
 *  @author Stenson, 16-08-17 15:08:27
 *
 *  选择问题分类
 */
//-(void)showQuestionType:(ZEAskQuesView *)askQuesView;

-(void)deleteSelectedImageWIthIndex:(NSInteger)index;

@end

@interface ZEAskQuesView : UIView

@property (nonatomic,weak) id <ZEAskQuesViewDelegate> delegate;

@property (nonatomic,copy) NSString * SUMPOINTS; // 当前账户的总积分
@property (nonatomic,assign) BOOL isAnonymousAsk; //  是否匿名提问
@property (nonatomic,copy) NSString * goldScore;  // 悬赏值

@property (nonatomic,strong) UITextView * inputView;
/************** 问题主键 *************/
@property (nonatomic,copy) NSString * quesTypeSEQKEY;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadChoosedImageView:(id)choosedImage;

/**
 刷新当前拥有积分分数
 */
-(void)reloadRewardGold:(NSString *)sumpoints;

@end
