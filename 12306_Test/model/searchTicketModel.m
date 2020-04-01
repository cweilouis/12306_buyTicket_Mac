//
//  searchTicketModel.m
//  12306_Test
//
//  Created by cwei on 2020/3/2.
//  Copyright © 2020 louis. All rights reserved.
//

#import "searchTicketModel.h"

@implementation searchTicketModel

-(instancetype)initWithDataArr:(NSArray *)dataArr stationNameArr:(NSMutableArray*)stationNameArr{
    
    if (self = [super init]) {
        
        if (dataArr.count>35) {
            
            self.secretHBStr = dataArr[36];
                     
            self.secretStr = dataArr[0];
            
            self.buttonTextInfo = dataArr[1];

            self.train_no = dataArr[2];
                     
            self.station_train_code = dataArr[3];
                       
            self.start_station_telecode = dataArr[4];
            
            self.end_station_telecode = dataArr[5];
            
            self.from_station_telecode = dataArr[6];
            
            self.to_station_telecode = dataArr[7];
            
            self.start_time = dataArr[8];
            
            self.arrive_time = dataArr[9];
            
            self.lishi = dataArr[10];
            
            if ([dataArr[11] isEqualToString:@"Y"]) {
                
                self.canBuy = YES;

            }else{
            
                self.canBuy = NO;

            }
            
            self.yp_info = dataArr[12];
            
            self.start_train_date = dataArr[13];
            
            self.train_seat_feature = dataArr[14];
            
            self.location_code = dataArr[15];
            
            self.from_station_no = dataArr[16];
            
            self.to_station_no = dataArr[17];
            
            self.is_support_card = dataArr[18];
            
            self.controlled_train_flag = dataArr[19];
            
            self.gg_num = [dataArr[20] length]>0? dataArr[20] : @"--";
            
            self.gr_num = [dataArr[21]length]>0? dataArr[21] : @"--";
            
            self.qt_num = [dataArr[22]length]>0? dataArr[22] : @"--";
            
            self.rw_num = [dataArr[23]length]>0? dataArr[23] : @"--";
            
            self.rz_num = [dataArr[24]length]>0? dataArr[24] : @"--";
            
            self.tz_num = [dataArr[25]length]>0? dataArr[25] : @"--";
            
            self.wz_num = [dataArr[26]length]>0? dataArr[26] : @"--";
            
            self.yb_num = [dataArr[27]length]>0? dataArr[27] : @"--";
            
            self.yw_num = [dataArr[28]length]>0? dataArr[28] : @"--";
            
            self.yz_num = [dataArr[29]length]>0? dataArr[29] : @"--";
            
            self.ze_num = [dataArr[30]length]>0? dataArr[30] : @"--";
            
            self.zy_num = [dataArr[31]length]>0? dataArr[31] : @"--";
            
            self.swz_num = [dataArr[32]length]>0? dataArr[32] : @"--";
            
            self.srrb_num = [dataArr[33]length]>0? dataArr[33] : @"--";
            
            self.yp_ex = dataArr[34];
            
            self.seat_types = dataArr[35];
            
            self.exchange_train_flag = dataArr[36];
            
            if ([self isOnthadayWithStartTime:self.start_time endTime:self.arrive_time] && [[self timeStrCovTimeNumWithStr:self.lishi].firstObject intValue]<=12) {
                
                self.isOntheday=YES;

            }else{
                
                self.isOntheday=NO;

            }
            
        
            for (NSDictionary *dict in stationNameArr) {
                
                if ([dict.allValues.firstObject isEqualToString:self.from_station_telecode]) {
                    
                    self.from_station_name = dict.allKeys.firstObject;

                }
                
                if ([dict.allValues.firstObject isEqualToString:self.to_station_telecode]) {
                    
                    self.to_station_name = dict.allKeys.firstObject;

                }
                
                if (self.from_station_name.length >0 && self.to_station_name.length >0) {
                    
                    break;
                }
            }
        }        
    }
    
    return self;
}


-(BOOL)isOnthadayWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
        
    if ([[self timeStrCovTimeNumWithStr:startTime].firstObject integerValue] > [[self timeStrCovTimeNumWithStr:endTime].firstObject integerValue]) {
        
        return NO;
   
    }else if ([[self timeStrCovTimeNumWithStr:startTime].firstObject integerValue] == [[self timeStrCovTimeNumWithStr:endTime].firstObject integerValue]){
        
        if ([[self timeStrCovTimeNumWithStr:startTime].lastObject integerValue] > [[self timeStrCovTimeNumWithStr:endTime].lastObject integerValue]) {
               
               return NO;
        
        }
        
    }
    
    return YES;
}

-(NSArray*)timeStrCovTimeNumWithStr:(NSString *)str{
    
    NSArray *timeArr=[str componentsSeparatedByString:@":"];
    
    return timeArr;
    
}


@end
