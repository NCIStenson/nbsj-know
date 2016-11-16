//
//  ZEAnswerQuestionsView.m
//  nbsj-know
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kInputViewMarginLeft    10.0f
#define kInputViewMarginTop     NAV_HEIGHT
#define kInputViewWidth         SCREEN_WIDTH - 20.0f
#define kInputViewHeight        120.0f

#define textViewStr @"这个问题将由您来解答。"

#import "ZEAnswerQuestionsView.h"
#import "JCAlertView.h"

@interface ZEAnswerQuestionsView()<UITextViewDelegate>
{
    UITextView * _inputView;
    NSMutableArray * _choosedImageArr;
    JCAlertView * _alertView;
    UIView * _backImageView;//   上传图片背景view
    UIButton * questionTypeBtn;
}

@property (nonatomic,strong) NSMutableArray * choosedImageArr;

@end


@implementation ZEAnswerQuestionsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.choosedImageArr = [NSMutableArray array];
        [self initView];
        [self initImageView];
    }
    return self;
}
-(void)initView
{    
    self.inputView = [[UITextView alloc]initWithFrame:CGRectZero];
    _inputView.text = textViewStr;
    _inputView.font = [UIFont systemFontOfSize:14];
    _inputView.textColor = [UIColor lightGrayColor];
    _inputView.delegate = self;
    [self addSubview:_inputView];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kInputViewMarginLeft);
        make.top.mas_equalTo(kInputViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kInputViewWidth, kInputViewHeight));
    }];
    
    UIView * dashView= [[UIView alloc]initWithFrame:CGRectMake( 0, kInputViewHeight + NAV_HEIGHT, SCREEN_WIDTH, 1)];
    [self addSubview:dashView];
    
    [self drawDashLine:dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    UIButton * downKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downKeyboardBtn.frame = CGRectMake(10, kInputViewHeight + NAV_HEIGHT + 5.0f, 30, 30);
    [downKeyboardBtn setImage:[UIImage imageNamed:@"TLdown"] forState:UIControlStateNormal];
    [self addSubview:downKeyboardBtn];
    [downKeyboardBtn addTarget:self action:@selector(downTheKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    downKeyboardBtn.clipsToBounds = YES;
    downKeyboardBtn.layer.cornerRadius = 15.0f;
    downKeyboardBtn.layer.borderWidth = 1.5;
    downKeyboardBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    
    UIButton * cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(SCREEN_WIDTH - 40.0f, kInputViewHeight + NAV_HEIGHT + 5.0f, 30, 30);
    [cameraBtn setImage:[UIImage imageNamed:@"camera_gray" color:MAIN_GREEN_COLOR] forState:UIControlStateNormal];
    [self addSubview:cameraBtn];
    cameraBtn.clipsToBounds = YES;
    cameraBtn.layer.cornerRadius = 15.0f;
    cameraBtn.layer.borderWidth = 1.5;
    cameraBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    [cameraBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)initImageView
{
    UIView * dashView= [[UIView alloc]initWithFrame:CGRectMake( 0, SCREEN_HEIGHT - 217, SCREEN_WIDTH, 1)];
    [self addSubview:dashView];
    [self drawDashLine:dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    _backImageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
    [self addSubview:_backImageView];
    
    for (int i = 0; i < self.choosedImageArr.count + 1; i ++) {
        UIButton * upImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upImageBtn.frame = CGRectMake( 10 * (i + 1) + (SCREEN_WIDTH - 40)/3* i , 18 , ( SCREEN_WIDTH - 40)/3, 180);
        upImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backImageView addSubview:upImageBtn];
        
        if (i == self.choosedImageArr.count && self.choosedImageArr.count < 4) {
            [upImageBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
            [upImageBtn setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        }else{
            [upImageBtn addTarget:self action:@selector(goLookView) forControlEvents:UIControlEventTouchUpInside];
            [upImageBtn setImage:self.choosedImageArr[i] forState:UIControlStateNormal];
        }
    }
    
}


-(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

#pragma mark - Public Method

-(void)reloadChoosedImageView:(UIImage *)choosedImage
{
    if ([choosedImage isKindOfClass:[UIImage class]]) {
        [_choosedImageArr addObject:choosedImage];
    }else if([choosedImage isKindOfClass:[NSArray class]]){
        self.choosedImageArr = [NSMutableArray arrayWithArray:(NSArray *)choosedImage];
    }
    for (UIView * view in _backImageView.subviews) {
        [view removeFromSuperview];
    }
    
    [self initImageView];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewStr]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = textViewStr;
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self downTheKeyBoard];
}


-(void)downTheKeyBoard
{
    [_inputView resignFirstResponder];
}

#pragma mark - ZEAskQuesViewDelegate

-(void)showCondition
{
    if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [self.delegate takePhotosOrChoosePictures];
    }
}

-(void)goLookView
{
    if ([self.delegate respondsToSelector:@selector(goLookImageView:)]) {
        [self.delegate goLookImageView:_choosedImageArr];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
