//
//  ZEAnswerQuestionsView.m
//  nbsj-know
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerQuestionsView.h"

@implementation ZEAnswerQuestionsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MAIN_LINE_COLOR;
        [self initView];
    }
    return self;
}

-(void)initView
{
    NSString * questionStr = @"这个问题将有你来回答。";
    float questionTitleHeight = [ZEUtil heightForString:questionStr font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 20];
    
    UILabel * questionLab = [[UILabel alloc]initWithFrame:CGRectMake(20, NAV_HEIGHT + 10.0f, SCREEN_WIDTH - 20, questionTitleHeight)];
    questionLab.numberOfLines = 0;
    questionLab.text = questionStr;
    questionLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    questionLab.textColor = [UIColor lightGrayColor];
    [self addSubview:questionLab];
    
    
    UITextView * answerText = [[UITextView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT + questionTitleHeight + 20.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - questionTitleHeight - 20.0f)];
    answerText.backgroundColor = [UIColor whiteColor];
    [self addSubview:answerText];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
