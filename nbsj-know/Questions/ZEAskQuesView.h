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

-(void)takePhotosOrChoosePictures;

-(void)goLookImageView:(NSArray *)imageArr;

@end

@interface ZEAskQuesView : UIView

@property (nonatomic,weak) id <ZEAskQuesViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadChoosedImageView:(id)choosedImage;

@end
