//
//  ZEUtil.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEUtil.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation ZEUtil

+ (BOOL)isNotNull:(id)object
{
    if ([object isEqual:[NSNull null]]) {
        return NO;
    } else if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    } else if (object == nil) {
        return NO;
    }
    return YES;
}

+ (BOOL)isStrNotEmpty:(NSString *)str
{
    if ([ZEUtil isNotNull:str]) {
        if ([str isEqualToString:@""]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}
+ (double)heightForString:(NSString *)str font:(UIFont *)font andWidth:(float)width
{
    double height = 0.0f;
    if (IS_IOS7) {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        height = ceil(rect.size.height);
    }
//    else {
//        CGSize sizeToFit = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//        height = sizeToFit.height;
//    }
    
    return height;
}

+ (double)widthForString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    double width = 0.0f;
    if (IS_IOS7) {
        CGRect rect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        width = rect.size.width;
    }
//    else {
//        CGSize sizeToFit = [str sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
//        width = sizeToFit.width;
//    }
    return width;
}
+ (NSDictionary *)getSystemInfo
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *systemName = [[UIDevice currentDevice] systemName];
    
    NSString *device = [[UIDevice currentDevice] model];
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
    
    NSString *appBuildVersion = [bundleInfo objectForKey:@"CFBundleVersion"];
    
    NSArray *languageArray = [NSLocale preferredLanguages];
    
    NSString *language = [languageArray objectAtIndex:0];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *country = [locale localeIdentifier];
    
    // 手机型号
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    [infoDic setObject:country forKey:@"country"];
    [infoDic setObject:language forKey:@"language"];
    [infoDic setObject:systemName forKey:@"systemName"];
    [infoDic setObject:systemVersion forKey:@"systemVersion"];
    [infoDic setObject:device forKey:@"device"];
    [infoDic setObject:deviceModel forKey:@"deviceModel"];
    [infoDic setObject:appVersion forKey:@"appVersion"];
    [infoDic setObject:appBuildVersion forKey:@"appBuildVersion"];
    
    return infoDic;
}
+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * image = [[UIImage alloc] init];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd_HHmmssSSS"];
    return [df stringFromDate:date];
}

+ (NSString *) compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
//    NSDate * serverDate = [[NSDate alloc]initWithTimeIntervalSince1970:str];
//    NSLog(@">>  %@",serverDate);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval ;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

#pragma mark - 服务器固定格式提取工具类 进行简化提取
+(NSDictionary *)getServerDic:(NSDictionary *)dic withTabelName:(NSString *)tableName
{
    NSDictionary * tableDic = [[dic objectForKey:@"DATAS"] objectForKey:tableName];
    
    return tableDic;
}

+ (NSArray *)getServerData:(NSDictionary *)dic withTabelName:(NSString *)tableName
{
    NSDictionary * tableDic = [[dic objectForKey:@"DATAS"] objectForKey:tableName];
    NSArray * serverDatasArr = [tableDic objectForKey:@"datas"];
    
    return serverDatasArr;
}

+(BOOL)isSuccess:(NSString *)dicStr
{
    if ([dicStr isEqualToString:@"操作成功！"]) {
        return YES;
    }else if ([dicStr isEqualToString:@"null"]){
        return YES;
    }else{
        return NO;
    }
}
+(NSString *)getCurrentDate:(NSString *)dateFormatter
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormatter];
    NSString * dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

@end
