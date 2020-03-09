//
//  NSString+Time.m
//  ihome
//
//  Created by HGWong on 8/18/15.
//  Copyright (c) 2015 Boer. All rights reserved.
//

#import "NSString+Time.h"
@implementation NSString (Time)


+(NSString *)currentTimeStamp{

     NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

       [formatter setDateStyle:NSDateFormatterMediumStyle];

       [formatter setTimeStyle:NSDateFormatterShortStyle];

       [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];

       NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

       [formatter setTimeZone:timeZone];

       NSDate *datenow = [NSDate date];

       NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];

       return timeSp;

}

+(NSString *)currentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];
    
    NSString *time = [formatter stringFromDate:datenow];

    return time;
}

+(NSString *)coverTimeWithStr:(NSDate *)time{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:time];
        
    return strDate;
    
}

+(NSInteger)compWithTime1:(NSString *)time1 time2:(NSString *)time2{
    //0 time1==time2 ,1 time1<time2 , 2 time1>time2
    
    NSArray *time1Arr=[time1 componentsSeparatedByString:@":"];
    
    NSArray *time2Arr=[time2 componentsSeparatedByString:@":"];

    if ([time1Arr.firstObject intValue] == [time2Arr.firstObject intValue]) {
        
        if ([time1Arr.lastObject intValue] == [time2Arr.lastObject intValue]) {
            
            return 0;
       
        }else if ([time1Arr.lastObject intValue] > [time2Arr.lastObject intValue]){
            
            return 2;
        
        }else if ([time1Arr.lastObject intValue] < [time2Arr.lastObject intValue]){
        
            return 1;
        }
        
    }else if ([time1Arr.firstObject intValue] > [time2Arr.firstObject intValue]){
        
        return 2;
    }

    return 1;
}

+(NSString *)stringDecodeWithStr:(NSString *)str{
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)str, CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    return decodedString;
    
}

+(NSString *)coverStrWithStr:(NSString *)str{
    
    NSString *newStr=@"";
    
    if (str.length>7) {
    
        NSString *yearStr =[str substringToIndex:4];
        
        NSString *monthStr =[str substringWithRange:NSMakeRange(4, 2)];

        NSString *dayStr =[str substringFromIndex:6];

        newStr=[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
    }
    
    return newStr;
    
}

@end
