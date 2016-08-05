//
//  JFCalendarPickerView.m
//  JFCalendarPicker
//
//  Created by 保修一站通 on 15/9/29.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFCalendarPickerView.h"
#import "JFCollectionViewCell.h"
NSString *const JFCalendarCellIdentifier = @"cell";


@interface JFCalendarPickerView ()
@property (strong, nonatomic) UICollectionView *JFCollectionView;

//- (IBAction)priviousButton:(id)sender;
//- (IBAction)nextButton:(id)sender;

//@property (weak, nonatomic)  UILabel *monthLabel;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) UIView *mask;

@property (nonatomic , strong) NSMutableArray * isSigninArr;

@end

@implementation JFCalendarPickerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self addSwipe];
    }
    return self;
}


- (void)setDate:(NSDate *)date
{
    _date = date;
    [_JFCollectionView reloadData];
}

-(void)initView
{
    _isSigninArr = [NSMutableArray array];
    for (int i = 0; i < 32; i ++) {
        NSDictionary * dic = @{@"date":@"2016-07-27",
                               @"isSingin":[NSString stringWithFormat:@"%d",arc4random()%2]};
        [_isSigninArr addObject:dic];
    }
    
    CGFloat itemWidth = SCREEN_WIDTH / 7;
    CGFloat itemHeight = SCREEN_WIDTH / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    _JFCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [_JFCollectionView registerClass:[JFCollectionViewCell class] forCellWithReuseIdentifier:JFCalendarCellIdentifier];
    _JFCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    _JFCollectionView.backgroundColor = [UIColor whiteColor];
    _JFCollectionView.delegate = self;
    _JFCollectionView.dataSource  =self;
    [self addSubview:_JFCollectionView];
    
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];

}


#pragma mark - date
//这个月的天数
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//第几月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

//年份
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

//这个月的第一天是周几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}



//这个月有几天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

//上个月的的时间
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下一个月的时间
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JFCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        cell.dateLabel.textColor = [UIColor brownColor];
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.dateLabel setText:@""];
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateLabel setText:@""];
        }else{
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setTextColor:[ZEUtil colorWithHexString:@"#6f6f6f"]];
            
            cell.isSignin = [_isSigninArr[day-1] objectForKey:@"isSingin"] ;
            //this month
            if ([_today isEqualToDate:_date]) {
                if ([[_isSigninArr[day-1] objectForKey:@"isSingin"] boolValue])  {
                    [cell.dateLabel setBackgroundColor:MAIN_NAV_COLOR];
                    cell.dateLabel.alpha = 0.5;
                }else{
                    [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
                }

                if (day == [self day:_date]) {
                    cell.dateLabel.textColor = [UIColor redColor];
                    cell.dateLabel.layer.borderWidth = 1;
                } else if (day > [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor blackColor]];
                    [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
                }
                
            } else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dateLabel setTextColor:[UIColor blackColor]];
            }
        }
    }
    return cell;
}

- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
//        [self customInterface];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    
    if(day <= 0){
        return;
    }
    if (day > [self day:_date]){
        NSLog(@"时间还没到");
    }else if ([[_isSigninArr[day-1] objectForKey:@"isSingin"] boolValue] )  {
        NSLog(@"已签到过的");
    }else{
        if (self.calendarBlock) {
            self.calendarBlock(day, [comp month], [comp year]);
        }
    }

    
    
}

- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextButton:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(priviousButton:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}



- (void)priviousButton:(id)sender {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];

}
//
- (void)nextButton:(id)sender {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];

}
@end
