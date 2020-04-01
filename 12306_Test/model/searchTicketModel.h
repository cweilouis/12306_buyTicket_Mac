//
//  searchTicketModel.h
//  12306_Test
//
//  Created by cwei on 2020/3/2.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface searchTicketModel : NSObject

@property (nonatomic,copy)NSString *secretHBStr;

@property (nonatomic,copy)NSString *secretStr; //secretStr索引为0

@property (nonatomic,copy)NSString *buttonTextInfo; //"预订文字"

@property (nonatomic,copy)NSString *train_no; //车票号

@property (nonatomic,copy)NSString *station_train_code; //车次

@property (nonatomic,copy)NSString *start_station_telecode; //起始站代号

@property (nonatomic,copy)NSString *end_station_telecode; //终点站代号

@property (nonatomic,copy)NSString *from_station_telecode; //出发站代号

@property (nonatomic,copy)NSString *to_station_telecode; //到达站代号

@property (nonatomic,copy)NSString *start_time; //出发时间

@property (nonatomic,copy)NSString *arrive_time; //到达时间

@property (nonatomic,copy)NSString *lishi; //历时

@property (nonatomic,assign)BOOL canBuy; //是否能购买：Y 可以

@property (nonatomic,copy)NSString *yp_info;

@property (nonatomic,copy)NSString *start_train_date; //出发日期

@property (nonatomic,copy)NSString *train_seat_feature;

@property (nonatomic,copy)NSString *location_code;

@property (nonatomic,copy)NSString *from_station_no;

@property (nonatomic,copy)NSString *to_station_no;

@property (nonatomic,copy)NSString *is_support_card;

@property (nonatomic,copy)NSString *controlled_train_flag;

@property (nonatomic,copy)NSString *gg_num;

@property (nonatomic,copy)NSString *gr_num;//高软

@property (nonatomic,copy)NSString *qt_num;

@property (nonatomic,copy)NSString *rw_num; //软卧

@property (nonatomic,copy)NSString *rz_num; //软座

@property (nonatomic,copy)NSString *tz_num;

@property (nonatomic,copy)NSString *wz_num; //无座

@property (nonatomic,copy)NSString *yb_num; // 二等座包座(硬包)

@property (nonatomic,copy)NSString *yw_num; //硬卧

@property (nonatomic,copy)NSString *yz_num; //硬座

@property (nonatomic,copy)NSString *ze_num; //二等座

@property (nonatomic,copy)NSString *zy_num; //一等座

@property (nonatomic,copy)NSString *swz_num; //商务座

@property (nonatomic,copy)NSString *srrb_num;

@property (nonatomic,copy)NSString *yp_ex;

@property (nonatomic,copy)NSString *seat_types;

@property (nonatomic,copy)NSString *exchange_train_flag;

@property (nonatomic,copy)NSString *from_station_name;

@property (nonatomic,copy)NSString *to_station_name;

@property (nonatomic,assign)BOOL isOntheday;//是否单日到达

-(instancetype)initWithDataArr:(NSArray *)dataArr stationNameArr:(NSMutableArray*)stationNameArr;

@end



NS_ASSUME_NONNULL_END
