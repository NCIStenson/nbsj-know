//
//  ZECreateTeamView.h
//  nbsj-know
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEAskQuestionTypeView.h"

@class ZECreateTeamView;
@interface ZECreateTeamMessageView : UIView<UITextViewDelegate,ZEAskQuestionTypeViewDelegate>
{
    UITextView * _manifestoTextView;
    UITextField * _teamNameField;
    ZEAskQuestionTypeView * teamTypeView;
    UITextView * _profileTextView; // 团队简介输入框
    UIButton * _teamHeadImgBtn;
}

@property (nonatomic,weak) ZECreateTeamView * createTeamView;

@property (nonatomic,strong) UITextField * teamNameField;    // 团队名称
@property (nonatomic,strong) UIButton * teamTypeBtn;
@property (nonatomic,strong) UITextView * manifestoTextView; // 团队宣言
@property (nonatomic,strong) UITextView * profileTextView;   //  团队简介
@property (nonatomic,copy) NSString * TEAMCIRCLECODENAME;    //  班组圈分类名称
@property (nonatomic,copy) NSString * TEAMCIRCLECODE;        //  班组圈分类编码

- (void)reloadTeamHeadImageView:(UIImage *)headImage;

@end;

@interface ZECreateTeamNumbersView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _collectionView;
}
@property (nonatomic,strong) NSMutableArray * alreadyInviteNumbersArr;
@property (nonatomic,weak) ZECreateTeamView * createTeamView;

-(void)reloadNumbersView:(NSArray *)numbersArr;

@end

@protocol ZECreateTeamViewDelegate  <NSObject>


/**
 添加人员界面
 */
-(void)goQueryNumberView;

/**
 删除人员界面
 */
-(void)goRemoveNumberView;


/**
 拍照或者相册选择
 */
-(void)takePhotosOrChoosePictures;

@end

@interface ZECreateTeamView : UIView

@property (nonatomic,strong) ZECreateTeamMessageView * messageView;
@property (nonatomic,strong) ZECreateTeamNumbersView * numbersView;
@property (nonatomic,weak) id <ZECreateTeamViewDelegate> delegate;

@end
