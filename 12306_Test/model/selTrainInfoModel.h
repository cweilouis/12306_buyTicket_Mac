//
//  selTrainInfoModel.h
//  12306_Test
//
//  Created by cwei on 2020/3/6.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface selTrainInfoModel : NSObject

@property (nonatomic,copy)NSString *globalRepeatSubmitToken;

@property (nonatomic,strong)NSMutableArray *certificateTypeArr;//证件类型

@property (nonatomic,copy)NSString *leftDetails;//余票详情

@property (nonatomic,strong)NSMutableArray *CanBuyTick_left;//可选择的余票类型

@property (nonatomic,copy)NSString *date;//出发日期

@property (nonatomic,copy)NSString *station_train_code;//车次

@property (nonatomic,copy)NSString *from_station_name;//出发站

@property (nonatomic,copy)NSString *start_time;//出发时间

@property (nonatomic,copy)NSString *to_station_name;//到达站

@property (nonatomic,copy)NSString *arrive_time;//到达时间

@property (nonatomic,strong)NSMutableArray *ticket_type_codes;//乘客类型

@property (nonatomic,strong)NSArray *seat_type_codes;//提供的席别类型

@property (nonatomic,copy)NSString *leftTicketStr;

@property (nonatomic,copy)NSString *purpose_codes;

@property (nonatomic,copy)NSString *train_location;

@property (nonatomic,copy)NSString *train_no;

@property (nonatomic,copy)NSString *train_date;

@property (nonatomic,copy)NSString *fromStationTelecode;

@property (nonatomic,copy)NSString *toStationTelecode;

@property (nonatomic,copy)NSString *key_check_isChange;

@property (nonatomic,copy)NSString *seatDetailType;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
