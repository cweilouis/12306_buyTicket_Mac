//
//  selTrainInfoModel.m
//  12306_Test
//
//  Created by cwei on 2020/3/6.
//  Copyright © 2020 louis. All rights reserved.
//

#import "selTrainInfoModel.h"

@implementation selTrainInfoModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
    
        self.globalRepeatSubmitToken=[dic[@"globalRepeatSubmitToken"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
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
        
        self.date=[NSString stringWithFormat:@"%@ (%@)",tmpDate,[self weekDayStr:tmpDate isEn:NO]];
        
        self.station_train_code=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"station_train_code"];
        
        self.from_station_name=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"from_station_name"];
        
        self.start_time=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"start_time"];
        
        self.to_station_name=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"to_station_name"];
        
        self.arrive_time=dic[@"ticketInfoForPassengerForm"][@"queryLeftTicketRequestDTO"][@"arrive_time"];
        
        self.ticket_type_codes=[NSMutableArray arrayWithArray:dic[@"ticketInfoForPassengerForm"][@"cardTypes"]];        
      
        self.seat_type_codes=dic[@"ticketInfoForPassengerForm"][@"limitBuySeatTicketDTO"][@"seat_type_codes"];
        
        self.leftTicketStr=dic[@"ticketInfoForPassengerForm"][@"leftTicketStr"];
        
        self.purpose_codes=dic[@"ticketInfoForPassengerForm"][@"purpose_codes"];

        self.train_location=dic[@"ticketInfoForPassengerForm"][@"train_location"];
      
        self.train_no=dic[@"ticketInfoForPassengerForm"][@"orderRequestDTO"][@"train_no"];

        NSArray *train_dateArr=[[self timeStampConvertToTime: dic[@"ticketInfoForPassengerForm"][@"orderRequestDTO"][@"train_date"][@"time"]] componentsSeparatedByString:@"-"];
        
        NSArray *tmpWeekAndMonthArr=[self getWeekAndMonthWithTimeStr:[self timeStampConvertToTime: dic[@"ticketInfoForPassengerForm"][@"orderRequestDTO"][@"train_date"][@"time"]] month:train_dateArr.count>2?train_dateArr[1]:@""];
        
        self.train_date=[NSString stringWithFormat:@"%@ %@ %@ %@ 00:00:00 GMT+0800 (中国标准时间)",tmpWeekAndMonthArr.firstObject,tmpWeekAndMonthArr.lastObject,train_dateArr.lastObject,train_dateArr.firstObject];
        self.fromStationTelecode=dic[@"ticketInfoForPassengerForm"][@"orderRequestDTO"][@"from_station_telecode"];
        self.toStationTelecode=dic[@"ticketInfoForPassengerForm"][@"orderRequestDTO"][@"to_station_telecode"];
        self.key_check_isChange=dic[@"ticketInfoForPassengerForm"][@"key_check_isChange"];
        
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

- (NSString*)weekDayStr:(NSString*)format isEn:(BOOL)isEn{
    
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
            weekDayStr = isEn?@"Sun":@"星期日";
            break;
        case 2:
            weekDayStr = isEn?@"Mon":@"星期一";
            break;
        case 3:
            weekDayStr = isEn?@"Tue":@"星期二";
            break;
        case 4:
            weekDayStr = isEn?@"Wed":@"星期三";
            break;
        case 5:
            weekDayStr = isEn?@"Thu":@"星期四";
            break;
        case 6:
            weekDayStr = isEn?@" Fri":@"星期五";
            break;
        case 7:
            weekDayStr = isEn?@"Sat":@"星期六";
            break;
        default:
            weekDayStr =@"";
            break;
    }
    return weekDayStr;
}

-(NSString *)getEnMonthWithStr:(NSString *)timeStr{
    
    NSString *enMonth=@"";
    
    switch (timeStr.intValue) {
        case 1:
            enMonth=@"Jan";
            
            break;
        case 2:
            enMonth=@"Feb";

            break;
         case 3:
            enMonth=@"Mar";

            break;
         case 4:
            enMonth=@"Apr";

            break;
          case 5:
            enMonth=@"May";

            break;
          case 6:
            enMonth=@"Jun";

            break;
          case 7:
            enMonth=@"Jul";

            break;
          case 8:
            enMonth=@"Aug";

            break;
          case 9:
            enMonth=@"Sept";

            break;
          case 10:
            enMonth=@"Oct";

            break;
          case 11:
            enMonth=@"Nov";

            break;
          case 12:
            enMonth=@"Dec";

            break;
        default:
            break;
    }
    
    return enMonth;
}


-(NSArray *)getWeekAndMonthWithTimeStr:(NSString *)timeStr month:(NSString *)month{
    
    NSArray *arr=[NSArray arrayWithObjects:[self weekDayStr:timeStr isEn:YES],[self getEnMonthWithStr:month],nil];
    
    return arr;
}


@end
