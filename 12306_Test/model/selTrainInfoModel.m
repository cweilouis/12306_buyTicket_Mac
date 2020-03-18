//
//  selTrainInfoModel.m
//  12306_Test
//
//  Created by 曹巍 on 2020/3/6.
//  Copyright © 2020 louis. All rights reserved.
//

#import "selTrainInfoModel.h"

@implementation selTrainInfoModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
    
        self.globalRepeatSubmitToken=dic[@"globalRepeatSubmitToken"];
        
        self.certificateTypeArr=[NSMutableArray arrayWithArray:dic[@"ticketInfoForPassengerForm"][@"cardTypes"]];
        
        self.leftDetails=@"";
        
        for (int i=0; i< [dic[@"ticketInfoForPassengerForm"][@"leftDetails"]count]; i++) {
            
            NSString *str=dic[@"ticketInfoForPassengerForm"][@"leftDetails"][i];
            
            self.leftDetails=[self.leftDetails stringByAppendingString:str];
            
            if (i!= [dic[@"ticketInfoForPassengerForm"][@"leftDetails"]count]-1) {
                
                self.leftDetails=[self.leftDetails stringByAppendingString:@"   "];

            }

        }
        
        self.CanBuyTick_left=[NSMutableArray array];
        
        for (NSString * str in dic[@"ticketInfoForPassengerForm"][@"leftDetails"]) {
            
            if (![str containsString:@"无票"]) {
                
               NSString *tmpStr=[str componentsSeparatedByString:@")"].firstObject;
                       
                [self.CanBuyTick_left addObject:[NSString stringWithFormat:@"%@)",tmpStr]];

            }
        }

        [self.CanBuyTick_left sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                       
            NSInteger value1 = [[[obj1 componentsSeparatedByString:@"("].lastObject componentsSeparatedByString:@")"].firstObject integerValue];
                 
            NSInteger value2 = [[[obj2 componentsSeparatedByString:@"("].lastObject componentsSeparatedByString:@")"].firstObject integerValue];
               
            if (value1 < value2) {
            
                return NSOrderedAscending;
                
            }else{
            
                return NSOrderedDescending;
            
            }
            
        }];
        
        NSString *tmpDate=[self timeStampConvertToTime:dic[@"ticketInfoForPassengerForm"][@"orderRequestDTO"][@"train_date"][@"time"]];
        
        self.date=[NSString stringWithFormat:@"%@ (%@)",tmpDate,[self weekDayStr:tmpDate]];
        self.station_train_code=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"station_train_code"];
        self.from_station_name=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"from_station_name"];
        
        self.start_time=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"start_time"];
        self.to_station_name=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"to_station_name"];
        self.arrive_time=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"arrive_time"];
        
        self.ticket_type_codes=[NSMutableArray arrayWithArray:dic[@"ticketInfoForPassengerForm"][@"cardTypes"]];
        
    }
   
    return self;
    
}

- (NSString *)timeStampConvertToTime:(NSString *)timeStamp{
    
    NSTimeInterval time=[timeStamp doubleValue]/1000;
    
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return [currentDateStr componentsSeparatedByString:@" "].firstObject;
}

- (NSString*)weekDayStr:(NSString*)format{
    
    NSString *weekDayStr = nil;
   
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    if(format.length>=10) {
    
        NSString *nowString = [format substringToIndex:10];
        
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        
        if(array.count==0) {
        
            array = [nowString componentsSeparatedByString:@"/"];
        }
        
        if(array.count>=3) {
          
            NSInteger year = [[array objectAtIndex:0] integerValue];
            
            NSInteger month = [[array objectAtIndex:1] integerValue];
            
            NSInteger day = [[array objectAtIndex:2] integerValue];
            
            [comps setYear:year];
            
            [comps setMonth:month];
            
            [comps setDay:day];
        }
    }
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //获取传入date
    NSDate *_date = [gregorian dateFromComponents:comps];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
   
    NSInteger week = [weekdayComponents weekday];
    
    switch(week) {
        case 1:
            weekDayStr =@"星期日";
            break;
        case 2:
            weekDayStr =@"星期一";
            break;
        case 3:
            weekDayStr =@"星期二";
            break;
        case 4:
            weekDayStr =@"星期三";
            break;
        case 5:
            weekDayStr =@"星期四";
            break;
        case 6:
            weekDayStr =@"星期五";
            break;
        case 7:
            weekDayStr =@"星期六";
            break;
        default:
            weekDayStr =@"";
            break;
    }
    return weekDayStr;
}
@end
