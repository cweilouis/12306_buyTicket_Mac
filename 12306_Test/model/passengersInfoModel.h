//
//  passengersInfoModel.h
//  12306_Test
//
//  Created by 曹巍 on 2020/3/16.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface passengersInfoModel : NSObject
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *allEncStr;
@property(nonatomic,copy)NSString *born_date;
@property(nonatomic,copy)NSString *country_code;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *email_active_time;
@property(nonatomic,copy)NSString *first_letter;
@property(nonatomic,copy)NSString *gat_born_date;
@property(nonatomic,copy)NSString *gat_valid_date_end;
@property(nonatomic,copy)NSString *gat_valid_date_start;
@property(nonatomic,copy)NSString *gat_version;
@property(nonatomic,copy)NSString *if_receive;
@property(nonatomic,copy)NSString *index_id;
@property(nonatomic,copy)NSString *isAdult;
@property(nonatomic,copy)NSString *isOldThan60;
@property(nonatomic,copy)NSString *isYongThan10;
@property(nonatomic,copy)NSString *isYongThan14;
@property(nonatomic,copy)NSString *is_active;
@property(nonatomic,copy)NSString *is_buy_ticket;
@property(nonatomic,copy)NSString *last_time;
@property(nonatomic,copy)NSString *last_update_time;
@property(nonatomic,copy)NSString *mobile_check_time;
@property(nonatomic,copy)NSString *mobile_no;
@property(nonatomic,copy)NSString *passenger_flag;
@property(nonatomic,copy)NSString *passenger_id_no;
@property(nonatomic,copy)NSString *passenger_id_type_code;
@property(nonatomic,copy)NSString *passenger_id_type_name;
@property(nonatomic,copy)NSString *passenger_name;
@property(nonatomic,copy)NSString *passenger_type;
@property(nonatomic,copy)NSString *passenger_type_name;
@property(nonatomic,copy)NSString *passenger_uuid;
@property(nonatomic,copy)NSString *phone_no;
@property(nonatomic,copy)NSString *postalcode;
@property(nonatomic,copy)NSString *recordCount;
@property(nonatomic,copy)NSString *sex_code;
@property(nonatomic,copy)NSString *sex_name;
@property(nonatomic,copy)NSString *total_times;
@property(nonatomic,assign)BOOL isSel;
@end

NS_ASSUME_NONNULL_END
