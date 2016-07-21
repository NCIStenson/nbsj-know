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

@end
