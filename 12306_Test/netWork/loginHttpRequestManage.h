//
//  httpRequestManage.h
//  12306_Test
//
//  Created by 曹巍 on 2020/1/13.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SuccessBlock)(NSDictionary *data);

typedef void (^FailureBlock)(NSError *error);

@interface loginHttpRequestManage : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;

@property (nonatomic, copy) FailureBlock failureBlock;

+(loginHttpRequestManage *)shaerd;

-(void)initRequestWithSuccess:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

-(void)requesOtn_resources_loginWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

-(void)requesGetImageCodeWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

-(void)requesCheckVerificationCodeWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

-(void)requesLoginWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
