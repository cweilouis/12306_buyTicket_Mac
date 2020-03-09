//
//  ticketsHttpRequestManager.h
//  12306_Test
//
//  Created by 曹巍 on 2020/1/21.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock)(NSDictionary *data);

typedef void (^FailureBlock)(NSError *error);

@interface ticketsHttpRequestManager : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;

@property (nonatomic, copy) FailureBlock failureBlock;

+(ticketsHttpRequestManager *)shaerd;

-(void)requesStationUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

-(void)requesleftTicket_queryUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
