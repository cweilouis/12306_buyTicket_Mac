//
//  confirmOrderVC.h
//  12306_Test
//
//  Created by icasa_ios on 2020/3/27.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface confirmOrderVC : NSViewController

@property(nonatomic,assign)BOOL canSelSeat;

@property(nonatomic,assign)NSInteger numberOfline;//排队人数

@property(nonatomic,assign)NSInteger numberOfPassengers;//乘客数量

@property(nonatomic,assign)BOOL isHaveticket;//是否有余票

@property(nonatomic,strong)NSMutableDictionary *CheckOrderInfoData;

@property(nonatomic,strong)NSMutableDictionary *getQueueCountData;

@property(nonatomic,copy)NSString *key_check_isChange;

@end

NS_ASSUME_NONNULL_END
