//
//  orderManageHttpRequestManager.h
//  12306_Test
//
//  Created by icasa_ios on 2020/3/31.
//  Copyright © 2020 louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock)(NSDictionary *data);

typedef void (^FailureBlock)(NSError *error);

@interface orderManageHttpRequestManager : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;

@property (nonatomic, copy) FailureBlock failureBlock;

+(orderManageHttpRequestManager *)shaerd;

-(void)requesQueryMyOrderNoCompleteWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


-(void)requesQueryMyOrderWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
