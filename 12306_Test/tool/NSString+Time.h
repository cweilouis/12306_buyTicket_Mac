//
//  NSString+Time.h
//  ihome
//
//  Created by cwei on 8/18/15.
//  Copyright (c) 2015 Boer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE_FORMAT @"yyyy年MM月dd日"
#define IntToStr(c)             [NSString stringWithFormat:@"%d",(int)c]
#define AppendZero(c)           [NSString appendZero:c] //如果int值 >0 &&<10 再前面补0
@interface NSString (Time)
+ (NSString *)currentTimeStamp;

+(NSString *)currentDate;

+(NSString *)coverTimeWithStr:(NSString *)time;

+(NSInteger)compWithTime1:(NSString *)time1 time2:(NSString *)time2;

+(NSString *)stringDecodeWithStr:(NSString *)str;

+(NSString *)coverStrWithStr:(NSString *)str;

+(NSString *)currentDateToBackDateWithDate:(NSDate *)date Day:(NSInteger)day;

+(NSDate *)coverTimeStrToDateWithStr:(NSString *)Str;

@end
