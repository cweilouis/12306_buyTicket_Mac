//
//  httpRequestManage.m
//  12306_Test
//
//  Created by 曹巍 on 2020/1/13.
//  Copyright © 2020 louis. All rights reserved.
//
static NSString *const cookieDicKey = @"cookieDic";

static NSString *const RAIL_EXPIRATIONAndDEVICEIDKey = @"RAIL_EXPIRATIONAndDEVICEID";

#import "loginHttpRequestManage.h"
@interface loginHttpRequestManage ()
@property(nonatomic,strong)AFHTTPSessionManager *afManager;
@property(nonatomic,strong)NSDictionary *locationDic;

@end

@implementation loginHttpRequestManage
+(loginHttpRequestManage *)shaerd{
    static loginHttpRequestManage * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[loginHttpRequestManage alloc] init];
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

- (void)getWithURLString:(NSString *)urlString
              parameters:(id)parameters
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    
    self.afManager=[self getafManager];
    
    self.afManager.responseSerializer = [AFCompoundResponseSerializer serializer];
   
    self.afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/plain",@"application/x-javascript",@"application/octet-stream",@"text/html",@"application/xhtml+xml",@"application/xml",nil];

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
            
                if ([urlString isEqualToString:getJSUrl]) {
        
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"BIGipServerotn"]length]>0) {
                        
                        successBlock(@{@"state":@"1"});

                    }else{
                        
                        successBlock(nil);

                    }
                }
                
            }else if ([responseObject isKindOfClass:NSClassFromString(@"_NSInlineData")]){
             
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

//                NSLog(@"%@",result);
                
                if ([urlString containsString:getRAIL_EXPIRATIONAndDEVICEIDUrl]) {
                    
                    result=[[result stringByReplacingOccurrencesOfString:@"callbackFunction('" withString:@""] stringByReplacingOccurrencesOfString:@"')" withString:@""];
                    
                    dic=[self dictionaryWithJsonString:result];
                    
                    if (dic) {
                        
                        NSMutableDictionary *tmpCookie=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]];
                        
                        [tmpCookie setObject:[NSString stringWithFormat:@"%@=%@;%@=%@;",@"RAIL_EXPIRATION",dic[@"exp"],@"RAIL_DEVICEID",dic[@"dfp"]] forKey:RAIL_EXPIRATIONAndDEVICEIDKey];
                        
                         [[NSUserDefaults standardUserDefaults]setObject:tmpCookie forKey:cookieDicKey];
                                               
                        BOOL isSaved= [[NSUserDefaults standardUserDefaults]synchronize];
                                     
                        if (isSaved) {
                                  
                            successBlock(dic);

                        }
                    }
                    
                }else if ([urlString isEqualToString:getBIGipServerpool_indexUrl]) {
                    
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"BIGipServerpool_index"]length]>0) {
                        
                        successBlock(@{@"state":@"1"});

                    }
               
                }else if ([urlString isEqualToString:otn_resources_loginUrl]){
                    
                    successBlock(@{@"state":@"1"});

                }else if ([urlString containsString:getImageCodeUrl] || [urlString containsString:checkImageCodeUrl]){
                    
                  dic = [self dictionaryWithJsonString:result];
                    
                  successBlock(dic);

                }else if ([urlString containsString:userLoginUrl] ){
                    
                    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]];
                    
                    [dict setObject:task.currentRequest.URL.absoluteString forKey:@"location"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:cookieDicKey];
                       
                        [[NSUserDefaults standardUserDefaults]synchronize];                        successBlock(@{@"location":task.currentRequest.URL.absoluteString,@"state":@"1"});

                    });

                }else if (self.locationDic){
                    
                    successBlock(@{@"state":@"1"});
                    
                    self.locationDic=nil;
               
                }else if ([urlString containsString:merged_12306_index_iconfontUrl]){
                    
                    successBlock(@{@"state":@"1"});
                    
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

    self.afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
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
                        
                        if ([urlString isEqualToString:index_otn_login_confUrl]) {
                            
                            if ([[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"BIGipServerotn"]length]>0 && [[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"JSESSIONID"]length]>0 && [[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"route"]length]>0) {

                                dic=@{@"state":@"1"};

                            }
                       
                        }else if ([urlString isEqualToString:uamtk_staticUrl]){
                            
                            if ([[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"_passport_session"]length]>0 && [[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey][@"BIGipServerpool_passport"]length]>0) {

                                dic=@{@"state":@"1"};

                            }
                        }else if ([urlString isEqualToString:loginUrl] || [urlString isEqualToString:uamtkUrl] || [urlString isEqualToString:uamauthclientUrl] || [urlString isEqualToString:initMy12306ApiUrl]){
                            
                            dic =[self dictionaryWithJsonString:result];
                        }
                    }
                    
                }else  if ([responseObject isKindOfClass:[NSData class]]) {
                    
                    dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                }
                
            }else{
                
                dic=[NSDictionary dictionaryWithObject:@"null" forKey:@"data"];
                
            }
           
            successBlock(dic);
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

    if (dict.count>0) {
        
        if ([urlStr isEqualToString:index_otn_login_confUrl]) {
            
            cookieStr=[NSString stringWithFormat:@"%@%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerpool_index",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_index"]];

        }else if ([urlStr containsString:getRAIL_EXPIRATIONAndDEVICEIDUrl]){
         
            cookieStr=[cookieStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"]]];

        }else if ([urlStr isEqualToString:uamtk_staticUrl]) {
            
            cookieStr=[cookieStr stringByAppendingString:[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey]];
            
            for (int i=0; i<dict.count; i++) {
                                 
                if ([[dict allKeys][i] isEqualToString:@"BIGipServerotn"]) {
                    
                    cookieStr=[cookieStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[dict allKeys][i],[dict allValues][i]]];
                            
                }
            }
        
        }else if ([urlStr isEqualToString:otn_resources_loginUrl]){
            
            cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"]];

            
        }else if ([urlStr containsString:getImageCodeUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"_passport_session",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_session"]];
            
            if ([[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_ct"] length]>0) {
                
                 cookieStr=[cookieStr stringByAppendingString:[NSString stringWithFormat:@";%@=%@",@"_passport_ct",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_ct"]]];
            }
       
        }else if ([urlStr containsString:getImageCodeUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"_passport_session",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_session"],@"_passport_ct",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_ct"]];
            
        }else if ([urlStr containsString:loginUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"_passport_session",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_session"],@"_passport_ct",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_ct"],@"BIGipServerpassport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpassport"]];
            
        }else if ([urlStr containsString:userLoginUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"]];
            
        }else if (self.locationDic){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"]];
            
        }else if ([urlStr containsString:uamtkUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"_passport_session",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"_passport_session"],@"uamtk",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"uamtk"]];

        }else if ([urlStr containsString:merged_12306_index_iconfontUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"]];

        }else if ([urlStr containsString:getJSUrl]){
            
            if ([[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"] length] > 0 &&
                [[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"] length] >0 &&
                 [[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"] length] >0 &&
                [[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"] length] >0 ) {
                
                cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"]];
                
            }
        
        }else if ([urlStr containsString:uamauthclientUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"]];

        }else if ([urlStr containsString:initMy12306ApiUrl]){
            
             cookieStr=[NSString stringWithFormat:@"%@%@=%@;%@=%@;%@=%@;%@=%@;%@=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:RAIL_EXPIRATIONAndDEVICEIDKey],@"BIGipServerotn",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerotn"],@"BIGipServerpool_passport",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"BIGipServerpool_passport"],@"route",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"route"],@"JSESSIONID",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"JSESSIONID"],@"tk",[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"tk"]];

        }
        
    }
    
    if ([urlStr isEqualToString:index_otn_login_confUrl]) {
        
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

        [manager.requestSerializer setValue:@"https://www.12306.cn" forHTTPHeaderField:@"Origin"];
                 
        [manager.requestSerializer setValue:@"https://www.12306.cn/index/index.html" forHTTPHeaderField:@"Referer"];
        
        [manager.requestSerializer setValue:@"www.12306.cn" forHTTPHeaderField:@"Host"];

    }else if ([urlStr containsString:getRAIL_EXPIRATIONAndDEVICEIDUrl]) {
        
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
                 
        [manager.requestSerializer setValue:@"https://www.12306.cn/index/" forHTTPHeaderField:@"Referer"];
        
        [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

    }else if ([urlStr isEqualToString:uamtk_staticUrl]) {
       
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
            
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            
            [manager.requestSerializer setValue:@"https://www.12306.cn" forHTTPHeaderField:@"Origin"];
        
            [manager.requestSerializer setValue:@"https://www.12306.cn/index/" forHTTPHeaderField:@"Referer"];
            
            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];
        }

    }else if ([urlStr isEqualToString:otn_resources_loginUrl]){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
            
            [manager.requestSerializer setValue:@"text/html;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                    
            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://www.12306.cn/index/index.html" forHTTPHeaderField:@"Referer"];
            
            [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
        }
        
    }else if ([urlStr containsString:getImageCodeUrl] || [urlStr containsString:checkImageCodeUrl] ){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
            
            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/resources/login.html" forHTTPHeaderField:@"Referer"];
            
        }
        
    }else if ([urlStr containsString:loginUrl]){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/resources/login.html" forHTTPHeaderField:@"Referer"];
            
        }
        
    }else if ([urlStr containsString:userLoginUrl]){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/resources/login.html" forHTTPHeaderField:@"Referer"];
            
            [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];

        }
   
    }else if (self.locationDic){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/resources/login.html" forHTTPHeaderField:@"Referer"];
            
            [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];

        }
    
    }else if ([urlStr containsString:uamtkUrl]){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"location"] forHTTPHeaderField:@"Referer"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

        }
   
    }else if ([urlStr containsString:merged_12306_index_iconfontUrl]){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/resources/merged/common_css.css?cssVersion=1.9058" forHTTPHeaderField:@"Referer"];

        }
   
    }else if ([urlStr containsString:merged_12306_index_iconfontUrl]){
        
        if (cookieStr.length>0) {
                   
            [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

            [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

            [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/resources/merged/common_css.css?cssVersion=1.9058" forHTTPHeaderField:@"Referer"];
        }
   
    }else if ([urlStr containsString:getJSUrl]){
        
        if (cookieStr.length>0) {
                   
            if ([[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"location"] length] >0) {
                
                [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

                [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

                [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"location"] forHTTPHeaderField:@"Referer"];
            }
        
        }
    
    }else if ([urlStr containsString:uamauthclientUrl]){
         
         if (cookieStr.length>0) {
                    
             [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

             [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

             [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey]objectForKey:@"location"] forHTTPHeaderField:@"Referer"];

             [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

         }
    
     }else if ([urlStr containsString:initMy12306ApiUrl]){
          
          if (cookieStr.length>0) {
                     
              [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];

              [manager.requestSerializer setValue:@"kyfw.12306.cn" forHTTPHeaderField:@"Host"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/view/index.html" forHTTPHeaderField:@"Referer"];

              [manager.requestSerializer setValue:@"https://kyfw.12306.cn" forHTTPHeaderField:@"Origin"];

          }
     
      }
    
   if (![urlStr containsString:getJSUrl] && cookieStr.length>0){

       [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:71.0) Gecko/20100101 Firefox/71.0" forHTTPHeaderField:@"User-Agent"];

   }
}

//-(NSString *)getCookieStrWithUrlStr:(NSString *)urlStr{
//
//    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:cookieDicKey];
//
//    NSString *cookieStr=@"";
//
//    if ([urlStr isEqualToString:@""]) {
//
//    }else if ([urlStr isEqualToString:@""]) {
//
//    }else if ([urlStr isEqualToString:@""]) {
//
//    }else if ([urlStr isEqualToString:@""]) {
//
//    }
//
//    for (int i=0; i<dict.count; i++) {
//
//        NSString *cookieKey=[dict allKeys][i];
//
//        NSString *cookieValue=[dict allValues][i];
//
//        cookieStr=[cookieStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",cookieKey,cookieValue]];
//
//        if (i==0 && dict.count>1) {
//
//            cookieStr=[cookieStr stringByAppendingString:@","];
//
//        }
//
//    }
//
//    return cookieStr;
//
//}

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

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
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

#pragma mark -请求方法

-(void)initRequestWithSuccess:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{

    [self requesGetJSWithUrl:getJSUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
        
        if (data) {
            
            NSLog(@"获得'BIGipServerotn'成功!");

            [self requesGetBIGipServerpool_indexUrlWithUrl:getBIGipServerpool_indexUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
                
                if (data) {
                    
                    NSLog(@"获得'BIGipServerpool_index'成功!");

                    [self requesgetRAIL_EXPIRATIONAndDEVICEIDUrlWithUrl:[NSString stringWithFormat:@"%@%@",getRAIL_EXPIRATIONAndDEVICEIDUrl,[NSString currentTimeStamp]] parameters:nil success:^(NSDictionary * _Nonnull data) {
                        
                        if (data && data.count>0) {
                            
                            [self requesindex_otn_login_confUrlWithUrl:index_otn_login_confUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
                                NSLog(@"获得'route,JSESSIONID,BIGipServerotn'成功!");
                                      
                                [self requesUamtk_staticWithUrl:uamtk_staticUrl parameters:@{@"appid":@"otn"} success:^(NSDictionary * _Nonnull data) {
                                
                                    if (data) {
                                        
                                        NSLog(@"获得'_passport_session,BIGipServerpool_passport'成功!");

                                        if (successBlock) {
                                            
                                            successBlock(@{@"state":@"1"});
                                        }
                                        
                                    }else{
                                        
                                        NSLog(@"获得'_passport_session,BIGipServerpool_passpor'失败!");

                                        if (failureBlock) {
                                            
                                            NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"state":@"0"}];
                                                                                
                                            failureBlock(error);
                                        }
                                    }
                                    
                                } failure:failureBlock];
                        
                                
                            } failure:failureBlock];
                            
                        }else{
                            NSLog(@"获得'route,JSESSIONID,BIGipServerotn'失败!");
                            
                            if (failureBlock) {
                                
                                NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"state":@"0"}];
                                                                    
                                failureBlock(error);
                            }

                        }
                        
                    } failure:failureBlock];
                    
                                        
                }else{
                    
                    NSLog(@"获得'BIGipServerpool_index'失败!");
                    
                    if (failureBlock) {
                        
                        NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"state":@"0"}];
                                                            
                        failureBlock(error);
                    }

                }
                
            } failure:failureBlock];
            
        }else{
            
            NSLog(@"获得'BIGipServerotn'失败!");
            
            if (successBlock) {

                successBlock(nil);
            }
        }
               
    } failure:^(NSError * _Nonnull error) {
       
        if (failureBlock) {

            failureBlock(error);
            
        }
        
    }];
    
}

-(void)requesGetJSWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

}

-(void)requesGetBIGipServerpool_indexUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];
}

-(void)requesgetRAIL_EXPIRATIONAndDEVICEIDUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url  parameters:parameters success:successBlock failure:failureBlock];
}


-(void)requesindex_otn_login_confUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];
}

-(void)requesUamtk_staticWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];
}


-(void)requesOtn_resources_loginWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

}


-(void)requesGetImageCodeWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];
}

-(void)requesCheckVerificationCodeWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

}

-(void)requesLoginWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:^(NSDictionary * _Nonnull data) {
        

        if ( data && [data[@"result_code"] intValue] == 0) {
             
            NSLog(@"登录成功!");

            [self requesUserLoginUrlWithUrl:userLoginUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
                
                if (data) {
                  
                    NSLog(@"获取'lcaotion'成功!");
                    
                    self.locationDic=@{@"location":data[@"location"]};
                                           
                    [self requesLocationUrlWithUrl:data[@"location"] parameters:nil success:^(NSDictionary * _Nonnull data) {
                        
                        if (data) {
                                                 
                            NSLog(@"获取'JSESSIONID'成功!");
                            
                            self.locationDic=nil;
                            
                            [self requesGetJSWithUrl:getJSUrl parameters:nil success:^(NSDictionary * _Nonnull data) {

                                if (data) {
                                                                                 
                                    NSLog(@"更新'BIGipServerotn'成功!");
                                                                   
                                    [self requesMerged_12306_index_iconfontUrlWithUrl:merged_12306_index_iconfontUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
                                                                    
                                        if (data) {
                                                                                         
                                            NSLog(@"更新'JSESSIONID'成功!");
                                                                                        
                                            [self requesUamtkUrlWithUrl:uamtkUrl parameters:@{@"appid":@"otn"} success:^(NSDictionary * _Nonnull data) {
                                                
                                                if ([data[@"result_code"] intValue] == 0 && data) {

                                                    [self requesUamauthclientUrlWithUrl:uamauthclientUrl parameters:@{@"tk":data[@"newapptk"]} success:^(NSDictionary * _Nonnull data) {
                                                        
                                                        if ([data[@"result_code"] intValue] == 0 && data) {
                                                            NSLog(@"%@,用户验证通过!",data[@"username"]);

                                                            [self requesInitMy12306ApiUrlWithUrl:initMy12306ApiUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
                                                                
                                                                if (data) {
                                                                    
                                                                    successBlock(data);
                                                                    
                                                                }else{
                                                                                                            successBlock(nil);

                                                                }
                                                                
                                                            } failure:failureBlock];
                                                            
                                                        }else{
                                                            
                                                            NSLog(@"用户验证未通过!");

                                                        }
                                                        
                                                    } failure:^(NSError * _Nonnull error) {
                                                        
                                                        NSLog(@"用户验证未通过!");

                                                    }];
                                                    
                                                }else{

                                                    NSLog(@"用户验证未通过!");

                                                }
                                                
                                            } failure:^(NSError * _Nonnull error) {
                                               
                                                NSLog(@"用户验证未通过!");

                                            }];
                                            
                                        }else{
                                                                                         
                                            NSLog(@"更新'JSESSIONID'失败!");

                                        }
                                                              
                                    } failure:^(NSError * _Nonnull error) {

                                        NSLog(@"更新'JSESSIONID'失败!");
                                    
                                    }];
                                                                                               
                                }else{
                                                                                 
                                    NSLog(@"更新'BIGipServerotn'失败!");
                                
                                }
                                                                                                
                            } failure:^(NSError * _Nonnull error) {
                                                                             
                                NSLog(@"更新'BIGipServerotn'失败!");

                            }];
                                                   
                        }else{
                                                   
                            NSLog(@"获取'JSESSIONID'失败!");
                                            
                        }
                                          
                    } failure:^(NSError * _Nonnull error) {
                                          
                        NSLog(@"获取'JSESSIONID'失败!");
                        
                    }];

                }else{
                    
                    NSLog(@"获取'lcaotion'失败!");

                }
                
            } failure:^(NSError * _Nonnull error) {
                
                NSLog(@"获取'lcaotion'失败!");

                
            }];
            
        }else{
                           
            NSLog(@"登录失败!");
            
            NSError *error=[[NSError alloc]initWithDomain:@"" code:0 userInfo:@{@"state":@"0"}];
                                                
            failureBlock(error);

        }
        
    } failureblock:failureBlock];

}

-(void)requesUserLoginUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

}

-(void)requesLocationUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

}


-(void)requesMerged_12306_index_iconfontUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self getWithURLString:url parameters:parameters success:successBlock failure:failureBlock];

}

-(void)requesUamtkUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];
}

-(void)requesUamauthclientUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];
}

-(void)requesInitMy12306ApiUrlWithUrl:(NSString *)url  parameters:(id)parameters  success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    [self postWithURLString:url parameters:parameters successblock:successBlock failureblock:failureBlock];
}





@end
