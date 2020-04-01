//
//  myOrderModel.h
//  12306_Test
//
//  Created by cwei on 2020/3/31.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface myOrderModel : NSObject
@property (nonatomic ,copy)NSString *alternate_flag;
@property (nonatomic ,copy)NSString *amount_char;
@property (nonatomic ,copy)NSString *batch_no;
@property (nonatomic ,copy)NSString *cancel_flag;
@property (nonatomic ,copy)NSString *coach_name;
@property (nonatomic ,copy)NSString *coach_no;
@property (nonatomic ,copy)NSString *column_nine_msg;
@property (nonatomic ,copy)NSString *come_go_traveller_ticket_page;
@property (nonatomic ,copy)NSString *confirm_flag;
@property (nonatomic ,copy)NSString *deliver_fee_char;
@property (nonatomic ,copy)NSString *dynamicProp;
@property (nonatomic ,copy)NSString *ext_ticket_no;
@property (nonatomic ,copy)NSString *fee_char;
@property (nonatomic ,copy)NSString *has608Message;
@property (nonatomic ,copy)NSString *if_cash;
@property (nonatomic ,copy)NSString *insure_query_no;
@property (nonatomic ,copy)NSString *integral_pay_flag;
@property (nonatomic ,copy)NSString *invoice_state;
@property (nonatomic ,copy)NSString *is_deliver;
@property (nonatomic ,copy)NSString *is_need_alert_flag;
@property (nonatomic ,copy)NSString *lc_flag;
@property (nonatomic ,copy)NSString *limit_time;
@property (nonatomic ,copy)NSString *lose_time;
@property (nonatomic ,copy)NSString *offline_return_date;
@property (nonatomic ,strong)NSMutableDictionary *passengerDTO;
@property (nonatomic ,copy)NSString *pay_limit_time;
@property (nonatomic ,copy)NSString *pay_mode_code;
@property (nonatomic ,copy)NSString *print_eticket_flag;
@property (nonatomic ,copy)NSString *reserve_time;
@property (nonatomic ,copy)NSString *resign_flag;
@property (nonatomic ,copy)NSString *return_deliver_flag;
@property (nonatomic ,copy)NSString *return_flag;
@property (nonatomic ,copy)NSString *sale_mode_type;
@property (nonatomic ,copy)NSString *seat_flag;
@property (nonatomic ,copy)NSString *seat_name;
@property (nonatomic ,copy)NSString *seat_no;
@property (nonatomic ,copy)NSString *seat_type_code;
@property (nonatomic ,copy)NSString *seat_type_name;
@property (nonatomic ,copy)NSString *sequence_no;
@property (nonatomic ,copy)NSString *start_train_date_page;
@property (nonatomic ,strong)NSMutableDictionary *stationTrainDTO;
@property (nonatomic ,copy)NSString *str_ticket_price_page;
@property (nonatomic ,copy)NSString *ticket_no;
@property (nonatomic ,copy)NSString *ticket_price;
@property (nonatomic ,copy)NSString *ticket_status_code;
@property (nonatomic ,copy)NSString *ticket_status_name;
@property (nonatomic ,copy)NSString *ticket_type_code;
@property (nonatomic ,copy)NSString *ticket_type_name;
@property (nonatomic ,copy)NSString *trade_mode;
@property (nonatomic ,copy)NSString *train_date;
@property (nonatomic ,copy)NSString *trms_price_number;
@property (nonatomic ,copy)NSString *trms_price_rate;
@property (nonatomic ,copy)NSString *trms_service_code;

@end

NS_ASSUME_NONNULL_END
