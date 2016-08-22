//
//  ZEAnswerQuestionsView.h
//  nbsj-know
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEAnswerQuestionsView;

@protocol ZEAnswerQuestionsViewDelegate<NSObject>



@end

@interface ZEAnswerQuestionsView : UIView

@property (nonatomic,weak) id <ZEAnswerQuestionsViewDelegate> delegate;

@property (nonatomic,strong) UITextView * answerText;

-(id)initWithFrame:(CGRect)frame;

@end
