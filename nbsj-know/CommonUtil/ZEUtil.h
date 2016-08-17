//
//  ZEUtil.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//


@interface ZEUtil : NSObject
// 检查对象是否为空
+ (BOOL)isNotNull:(id)object;

// 检查字符串是否为空
+ (BOOL)isStrNotEmpty:(NSString *)str;

// 计算文字高度
+ (double)heightForString:(NSString *)str font:(UIFont *)font andWidth:(float)width;

+ (double)widthForString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

// 根据颜色生成图片
+ (UIImage *)imageFromColor:(UIColor *)color;

//  时间格式化
+ (NSString *)formatDate:(NSDate *)date;

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  @author Stenson, 16-07-28 16:07:44
 *
 *  比较当前时间是多少分钟前
 *
 *  @param str 传入时间
 *
 *  @return 出入时间是多少分钟前
 */
+ (NSString *) compareCurrentTime:(NSString *)str;


/**
 *  @author Stenson, 16-08-15 15:08:07
 *
 *  服务器固定格式提取工具类 进行简化提取
 *
 *  @param dic       服务器返回字符串
 *  @param tableName 查询表名
 *
 *  @return 数据数组
 */
+ (NSDictionary *)getServerDic:(NSDictionary *)dic withTabelName:(NSString *)tableName;
+ (NSArray *)getServerData:(NSDictionary *)dic withTabelName:(NSString *)tableName;
/**
 *  @author Stenson, 16-08-16 09:08:20
 *
 *  获取操作是否成功
 *
 *  @param dicStr 请求返回参数
 *
 *  @return 是否成功
 */
+(BOOL)isSuccess:(NSString *)dicStr;

@end
