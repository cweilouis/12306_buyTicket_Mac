//
//  BuyHttpRequestManager.m
//  12306_Test
//
//  Created by 曹巍 on 2020/3/5.
//  Copyright © 2020 louis. All rights reserved.
//

#import "BuyHttpRequestManager.h"
static NSString *const RAIL_EXPIRATIONAndDEVICEIDKey = @"RAIL_EXPIRATIONAndDEVICEID";

static NSString *const cookieDicKey = @"cookieDic";

@interface BuyHttpRequestManager ()

@property(nonatomic,strong)AFHTTPSessionManager *afManager;

@end


@implementation BuyHttpRequestManager

+(BuyHttpRequestManager *)shaerd{
    static BuyHttpRequestManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BuyHttpRequestManager alloc] init];
    });
    return instance;
}

-(AFHTTPSessionManager *)getafManager{
  
    if (_afManager) {

           _afManager = nil;

       }
       
       _afManager=[AFHTTPSessionManager manager];
       
       _afManager.requestSerializer = [AFHTTPRequestSerializer serializer];

       _afManager.operationQueue.maxConcurrentOperationCount = 20;
        
       _afManager.requestSerializer.timeoutInterval = 10;
       
       return _afManager;
}

//发送get请求

- (void) getWithURLString:(NSString *)urlString
              parameters:(id)parameters
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    
    self.afManager=[self getafManager];
    
    self.afManager.responseSerializer = [AFCompoundResponseSerializer serializer];
   
    self.afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/plain",@"application/x-javascript",@"application/octet-stream",@"text/html",@"application/xhtml+xml",@"application/xml",@"text/javascript",nil];

    [self setAfmanagerWithManager:self.afManager urlStr:urlString cookie:[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]];
    
    [self.afManager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response;
        
       if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
           response =(NSHTTPURLResponse *)task.response;
           
//           NSLog(@"response.allHeaderFields ------- %@",response.allHeaderFields);

           if (response.allHeaderFields.count>0) {
               
               [self saveCookieWithCookieDict:response.allHeaderFields urlStr:urlString];
           }
           
       }

        if (successBlock) {
         
            NSDictionary *dic ;
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
               
                dic=responseObject;
                
                successBlock(dic);
            
            }else if ([responseObject isKindOfClass:NSClassFromString(@"OS_dispatch_data")]){
            
               dispatch_data_t data_t =[responseObject performSelector:@selector(_createDispatchData)];
        
                const void *buffer = NULL;
            
                size_t size = 0;
                
                dispatch_data_t new_data_file = dispatch_data_create_map(data_t, &buffer, &size);
                     
                if(new_data_file){
                    
                }
                
                NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
                           
                NSString *result = [[[[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding] componentsSeparatedByString:@"='"].lastObject componentsSeparatedByString:@"'"].firstObject;
                           
            }else if ([responseObject isKindOfClass:NSClassFromString(@"_NSInlineData")]){
             
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

                dic = [self dictionaryWithJsonString:result];
                
                if ([urlString containsString:queryOrderWaitTimeUrl]) {
                    
                    if (dic[@"data"]) {
                        
                        successBlock(dic[@"data"]);

                    }else{
                       
                        successBlock(nil);
                    }
                }
                
            }else if ([responseObject isKindOfClass:[NSData class]]){
            
                dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                successBlock(dic);
            }
        }
  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
//        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
//
//            NSHTTPURLResponse *response =(NSHTTPURLResponse *)task.response;
//
//            if (response.allHeaderFields.count>0) {
//
//                [self saveCookieWithCookieDict:response.allHeaderFields urlStr:urlString];
//
//            }
//        }
        
//        NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey];
//
//        if ([task.currentRequest.URL.absoluteString isEqualToString:getBIGipServerpool_indexUrl]) {
//
//            if ([dict[@"BIGipServerpool_index"] length] >0) {
//
//                if (successBlock) {
//
//                    successBlock(@{@"state":@"1"});
//                }
//            }
//
//        }else{
           
            if (failureBlock) {
               
                failureBlock(error);
                
                NSLog(@"网络异常 - T_T%@", error);
            }
//        }
        
    }];
}

//发送post请求
- (void)postWithURLString:(NSString *)urlString
               parameters:(id)parameters
                  successblock:(SuccessBlock)successBlock
                  failureblock:(FailureBlock)failureBlock{
   
    self.afManager=[self getafManager];

    self.afManager.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    self.afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/plain",@"text/html",@"application/x-www-form-urlencoded",@"text/javascript",nil];
    
    [self setAfmanagerWithManager:self.afManager urlStr:urlString cookie:[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]];
    
    [self.afManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
          
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                 
                NSHTTPURLResponse *response =(NSHTTPURLResponse *)task.response;
                
//                NSLog(@"response.allHeaderFields ------- %@",response.allHeaderFields);

                if (response.allHeaderFields.count>0) {
                    
                    [self saveCookieWithCookieDict:response.allHeaderFields urlStr:urlString];
                }
                
            }
            
            NSDictionary *dic ;
            
            if (responseObject) {
            
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    dic=responseObject;
                    
                }else if ([responseObject isKindOfClass:NSClassFromString(@"_NSInlineData")]) {
                    
                    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

//                    NSLog(@"%@",result);

                    if (result.length>0) {
                        
                        dic =[self dictionaryWithJsonString:result];

                        if ([urlString containsString:checkUserUrl]) {
                            
                            if (dic && dic.count>0) {
                                
                                successBlock(dic);

                            }else{
                                
                                successBlock(nil);
                                
                            }
                        
                        }else if ([urlString containsString:submitOrderRequestUrl]){
                        
                            if (dic && dic.count>0 &&  [dic[@"messages"]count]<1 ) {
                                
                                successBlock(dic);

                            }else{
                               
                                for (NSString *errStr in dic[@"messages"]) {
                                    
                                    NSLog(@"%@",errStr);

                                }
                                
                                successBlock(nil);
                                
                            }
                            
                        }else if ([urlString containsString:getPassengerDTOsUrl]){
                            
                            if ([dic[@"data"][@"exMsg"]length]<1 && ![dic[@"data"][@"normal_passengers"]isKindOfClass:[NSNull class]]) {
                                
                                successBlock(dic);

                            }else{
                             
                                NSLog(@"%@ -- %@",urlString,dic[@"data"][@"exMsg"]);
                                
                                successBlock(nil);

                            }
                                                        
                        }else if ([urlString containsString:checkOrderInfoUrl]){
                            
                            if ([dic[@"data"][@"errMsg"]length]<1 && [dic[@"data"][@"submitStatus"] intValue]==1) {
                                
                                successBlock(dic);

                            }else{
                             
                                NSLog(@"%@ -- %@",urlString,dic[@"data"][@"errMsg"]);
                                
                                successBlock(nil);

                            }
                                                        
                        }else if ([urlString containsString:getQueueCountUrl]){
                            
                            if ([dic[@"messages"]count]<1 && [dic[@"status"] intValue]!=0) {
                                
                                successBlock(dic[@"data"]);

                            }else{
                             
                                NSLog(@"%@ -- %@",urlString,[dic[@"messages"]firstObject]);
                                
                                successBlock(nil);

                            }
                                                        
                        }else if ([urlString containsString:confirmSingleForQueueUrl]){
                            
                            if ([dic[@"messages"]count]<1 && [dic[@"status"] intValue]!=0 && [dic[@"data"][@"submitStatus"]intValue]!=0) {
                                
                                successBlock(dic);

                            }else{
                             
                                NSLog(@"%@ -- %@",urlString,[dic[@"messages"]firstObject]);
                                
                                successBlock(nil);

                            }
                                                        
                        }else if ([urlString containsString:resultOrderForDcQueueUrl]){
                            
                            if ([dic[@"messages"]count]<1 && [dic[@"data"][@"submitStatus"]intValue]!=0) {
                                
                                successBlock(dic);

                            }else{
                             
                                if ([dic[@"messages"]count] >0) {
                                    
                                    NSLog(@"%@ -- %@",urlString,[dic[@"messages"]firstObject]);

                                }else{
                                    
                                    NSLog(@"%@ -- %@",urlString,dic[@"data"][@"errMsg"]);

                                }
                                
                                successBlock(nil);
                            }
                        }
                    }
                    
                }else if ([responseObject isKindOfClass:NSClassFromString(@"OS_dispatch_data")]){
                    
                    dispatch_data_t data_t =[responseObject performSelector:@selector(_createDispatchData)];
                    
                    const void *buffer = NULL;
                    
                    size_t size = 0;
                        
                    dispatch_data_t new_data_file = dispatch_data_create_map(data_t, &buffer, &size);
                    
                    if(new_data_file){
                    
                    }
                  
                    NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
                                   
                    NSString *result = [[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding];

                    if (![urlString containsString:initDcUrl]) {
                        
                        dic = [self dictionaryWithJsonString:result];

                    }
                    
                    if ([urlString containsString:initDcUrl]){
                                                   
                        if ([result containsString:@"globalRepeatSubmitToken"] && [result containsString:@"ticketInfoForPassengerForm"]) {
                            
                            NSString *globalRepeatSubmitToken=[[[result componentsSeparatedByString:@" var globalRepeatSubmitToken ="].lastObject componentsSeparatedByString:@";"].firstObject stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            
                            NSDictionary *ticketInfoForPassengerForm=[self dictionaryWithJsonString:[[[result componentsSeparatedByString:@" var ticketInfoForPassengerForm="].lastObject componentsSeparatedByString:@";"].firstObject stringByReplacingOccurrencesOfString:@"'" withString:@"\""]];
                            
                            if (globalRepeatSubmitToken.length >0 && (ticketInfoForPassengerForm && ticketInfoForPassengerForm.count>0)) {
                                successBlock(@{@"globalRepeatSubmitToken":globalRepeatSubmitToken,@"ticketInfoForPassengerForm":ticketInfoForPassengerForm});
                           
                            }else{
                               
                                successBlock(nil);
                            }
                        }
                    }
                    
                }else  if ([responseObject isKindOfClass:[NSData class]]) {
                    
                    dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    
                    successBlock(dic);

                }
                
            }else{
                
                dic=[NSDictionary dictionaryWithObject:@"null" forKey:@"data"];
                
                successBlock(dic);

            }
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
//        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
//
//            NSHTTPURLResponse *response =(NSHTTPURLResponse *)task.response;
//
//            if (response.allHeaderFields.count>0) {
//
//                [self saveCookieWithCookieDict:response.allHeaderFields urlStr:urlString];
//
//            }
//        }
        
//        NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey];
//
//         if ([task.currentRequest.URL.absoluteString isEqualToString:uamtk_staticUrl]) {
//
//           if ([dict[@"_passport_session"] length] >0 && [dict[@"BIGipServerpool_passport"] length] >0) {
//
//               if (successBlock) {
//
//                   successBlock(@{@"state":@"1"});
//
//               }
//           }
//
//         }else{
//
             if (failureBlock) {
                failureBlock(error);
                 NSLog(@"网络异常 - T_T%@", error);
             }
//         }
            
    }];
}

#pragma  mark -工具方法
-(void)saveCookieWithCookieDict:(NSDictionary *)CookieDict urlStr:(NSString *)urlStr{
   
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]];
    
    if (!dict) {
        
        dict=[NSMutableDictionary dictionary];
    }
    
      if ([CookieDict.allKeys containsObject:@"Set-Cookie"]) {
              
          NSMutableDictionary *tmpDict;
                
          NSMutableArray *keyNameArr = [self getKeyNameArrWithCookieStr:CookieDict[@"Set-Cookie"]];
                    
          if ([CookieDict[@"Set-Cookie"] isKindOfClass:[NSString class]]) {
              
              tmpDict=[self keyArr:keyNameArr Set_CookieArr:@[CookieDict[@"Set-Cookie"]]];

          }else if ([CookieDict[@"Set-Cookie"] isKindOfClass:[NSArray class]]){
                    
          
          }
          
          for (int i=0; i<tmpDict.count; i++) {
                    
              [dict setObject:[tmpDict allValues][i] forKey:[tmpDict allKeys][i]];
              
          }
          
      }
    
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:cookieDicKey];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)setAfmanagerWithManager:(AFHTTPSessionManager *)manager  urlStr:(NSString *)urlStr cookie:(NSDictionary *)cookie{
    
    NSString *cookieStr=@"";
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:cookie];

    if (dict) {
        
        if ([urlStr containsString:checkUserUrl] || [urlStr containsString:submitOrderRequestUrl] || [urlStr containsString:initDcUrl] || [urlStr containsString:getPassengerDTOsUrl] || [urlStr containsString:checkOrderInfoUrl] || [urlStr containsString:getQueueCountUrl] || [urlStr containsString:confirmSingleForQueueUrl] || [urlStr containsString:queryOrderWaitTimeUrl]){
            
            cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@;%@=%@;%@=%@;%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"],@"tk",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"tk"],@"_jc_save_fromDate",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_jc_save_fromDate"],@"_jc_save_fromStation",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_jc_save_fromStation"],@"_jc_save_toDate",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_jc_save_toDate"],@"_jc_save_toStation",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_jc_save_toStation"],@"_jc_save_wfdc_flag",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_jc_save_wfdc_flag"]];

        }
    }
    

    if ([urlStr containsString:checkUserUrl]){
          
          if (cookieStr.length>0) {
                     
              [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

              [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/leftTicket/init?linktypeid=dc" forHTTPHeaderField:@"Referer"];

              [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"If-Modified-Since"];

          }
      
    }else if ([urlStr containsString:submitOrderRequestUrl]){
          
          if (cookieStr.length>0) {
                     
              [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

              [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/leftTicket/init?linktypeid=dc" forHTTPHeaderField:@"Referer"];

          }
     
    }else if ([urlStr containsString:initDcUrl]){
          
          if (cookieStr.length>0) {
                     
              [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

              [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/leftTicket/init?linktypeid=dc" forHTTPHeaderField:@"Referer"];

          }
      
    }else if ([urlStr containsString:getPassengerDTOsUrl]){
          
          if (cookieStr.length>0) {
                     
              [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

              [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/confirmPassenger/initDc" forHTTPHeaderField:@"Referer"];

          }
      
    }else if ([urlStr containsString:checkOrderInfoUrl] || [urlStr containsString:getQueueCountUrl] || [urlStr containsString:confirmSingleForQueueUrl]){
          
          if (cookieStr.length>0) {
                     
              [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

              [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/confirmPassenger/initDc" forHTTPHeaderField:@"Referer"];

          }
     
    }else if ([urlStr containsString:queryOrderWaitTimeUrl]){
            
            if (cookieStr.length>0) {
                       
                [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

                [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

                [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/confirmPassenger/initDc" forHTTPHeaderField:@"Referer"];

            }
        
      }
    
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:71.0) Gecko/20100101 Firefox/71.0" forHTTPHeaderField:@"User-Agent"];
}

-(NSMutableArray *)getKeyNameArrWithCookieStr:(NSString *)str{
    
    NSMutableArray *cookieNameArr=[NSMutableArray array];

    NSArray *arr1=[str componentsSeparatedByString:@","];
    
    for (int i=0; i<arr1.count; i++) {
        
        NSArray *arr2=[arr1[i] componentsSeparatedByString:@";"];
        
        NSString *keyName=[arr2.firstObject componentsSeparatedByString:@"="].firstObject;
        
        keyName=[keyName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [cookieNameArr addObject:keyName];
    
    }
    
    return cookieNameArr;
    
}


-(NSMutableDictionary *)keyArr:(NSMutableArray *)keyArr Set_CookieArr:(NSArray *)Set_CookieArr{
    
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    
    NSString *cookieStr=Set_CookieArr.firstObject;
    
    NSMutableArray *Set_CookieArr1=[NSMutableArray arrayWithArray:Set_CookieArr];

    if ([cookieStr containsString:@","]) {
        
        NSMutableArray *tmpSet_CookieArr=[NSMutableArray array];

        for (int i=0; i<Set_CookieArr1.count; i++) {
            
            NSArray *subArr1=[Set_CookieArr1[i] componentsSeparatedByString:@","];
            
            for (int j=0; j<subArr1.count; j++) {
                
               [tmpSet_CookieArr addObject:subArr1[j]];

            }
        }
        
        Set_CookieArr1=tmpSet_CookieArr;
    }
    
    for (int i=0; i<keyArr.count; i++) {
    
        for (int j=0; j<Set_CookieArr1.count; j++) {
           
            if ([Set_CookieArr1[j] containsString:keyArr[i]]) {
             
                NSString *cookieValue=[[[[Set_CookieArr1[j] componentsSeparatedByString:@";"]firstObject]componentsSeparatedByString:@"="]lastObject];
                
                [dict setObject:cookieValue forKey:keyArr[i]];
            }
        }
    }
    
    return dict;
    
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma  mark -请求
-(void)RequestWithUrl:(NSString *)url parameters:(id)parameters Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    __weak typeof(self)weakself=self;
    
    [self postWithURLString:url parameters:@{@"_json_att":@""} successblock:^(NSDictionary * _Nonnull data) {
        
        if (data && data.count>0) {
            
            [weakself requessubmitOrderRequestUrlWithUrl:submitOrderRequestUrl parameters:parameters success:^(NSDictionary * _Nonnull data) {
                
                if (data && data.count>0) {
                    
                    [weakself requesinitDcUrlWithUrl:initDcUrl parameters:@{@"_json_att":@""} success:^(NSDictionary * _Nonnull data) {
                        
                        if (data && data.count>0) {
                            
                            successBlock(data);
                            
                        }else{
                            
                            if (failureBlock) {
                                           
                                NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"infor":@"initDc 失败!"}];
                                
                                failureBlock(error);
                            }
                        }
                        
                    } failure:failureBlock];
                    
                }else{
                   
                    if (failureBlock) {
                                   
                        NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"infor":@"submitOrderRequest 失败!"}];
                        
                        failureBlock(error);
                        
                    }
                }
                
            } failure:failureBlock];
            
        }else{
            
            if (failureBlock) {
                
                NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"infor":@"checkUser 失败!"}];
                                                    
                failureBlock(error);
            }

        }
        
    } failureblock:failureBlock];

}

-(void)requessubmitOrderRequestUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];

}

-(void)requesinitDcUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];

}

-(void)RequestGetPassengerDTOsWithUrl:(NSString *)url  parameters:(id)parameters Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];

}

-(void)RequestCheckOrderInfoWithUrl:(NSString *)url  parameters:(id)parameters parameters1:(id)parameters1 Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:^(NSDictionary * _Nonnull data) {

        if (data && data.count>0) {
            
            if (data[@"data"][@"submitStatus"] && data[@"data"][@"canChooseSeats"]) {
                
               __block NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                
                [dict setObject: data[@"data"][@"canChooseSeats"] forKey:@"canChooseSeats"];
                
                [self RequestGetQueueCountWithUrl:getQueueCountUrl parameters:parameters1  Success:^(NSDictionary * _Nonnull data) {
                    
                    if (data && data.count>0) {
                     
                        [dict setObject: data[@"count"] forKey:@"count"];

                        [dict setObject: data[@"ticket"] forKey:@"ticket"];

                        successBlock(dict);
                    }
                    
                } failure:failureBlock];
            }
            
        }

    } failureblock:failureBlock];

}

-(void)RequestGetQueueCountWithUrl:(NSString *)url  parameters:(id)parameters  Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];

}

-(void)RequestConfirmSingleForQueueWithUrl:(NSString *)url  parameters:(id)parameters Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];

    //{"表单数据":{"passengerTicketStr":"O,0,1,曹巍,1,3206***********21X,199****8632,N,9d2aabf0ad05fa3aadd2e99841a7b9309d30fefe017fc3f2a78dc5b4f757935ecb5fab5c4e29e1a8a7e2f604516be9c27f482f0d1cfa716007286882a787c716ab1cfc308cb6de65111b75003c148683_O,0,1,陈卫菊,1,3206***********689,13961894264,N,2a7e39702d29bd0e2db78f11562a2d8761cb70624ed458e8057f0691dd91d1ca84d5b358bf0c7caf5d211cde1e76197bb14082b199c63bba9008ed83ade31e17","oldPassengerStr":"曹巍,1,3206***********21X,1_陈卫菊,1,3206***********689,1_","randCode":"","purpose_codes":"00","key_check_isChange":"A3060AC4809CB48511E84542B6F9F74A6E1185FED354375E26F3CA5D","leftTicketStr":"P%2BGaipxeMnbUvQq0iTYtSUFoC4PC3Xg7DEduZHyVJ5KfVPPBTWCcsLcrgnQ%3D","train_location":"H1","choose_seats":"1B2B","seatDetailType":"000","whatsSelect":"1","roomType":"00","dwAll":"N","_json_att":"","REPEAT_SUBMIT_TOKEN":"443e9600dcaefe96a8c9e606aebf8b8f"}}
}

-(void)RequestQueryOrderWaitTimeWithUrl:(NSString *)url  parameters:(id)parameters Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{

    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

    //{"查询字符串":{"random":"1585362641200","tourFlag":"dc","_json_att":"","REPEAT_SUBMIT_TOKEN":"443e9600dcaefe96a8c9e606aebf8b8f"}}
}

-(void)RequestResultOrderForDcQueueWithUrl:(NSString *)url  parameters:(id)parameters Success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
 
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];

    //{"表单数据":{"orderSequence_no":"EA56559501","_json_att":"","REPEAT_SUBMIT_TOKEN":"443e9600dcaefe96a8c9e606aebf8b8f"}}
}

@end
