//
//  ViewController.m
//  12306_Test
//
//  Created by 曹巍 on 2020/1/10.
//  Copyright © 2020 louis. All rights reserved.
//

#import "ViewController.h"
#import "ticketsVC.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
@property (weak) IBOutlet NSImageView *codeImage;
@property (nonatomic,strong)NSMutableArray *touchPointArr;
@property (nonatomic,strong)NSMutableArray *touchViewArr;
@property (weak) IBOutlet NSTextField *accountTf;
@property (weak) IBOutlet NSTextField *passwordTf;
@end

@implementation ViewController


- (void)viewWillAppear
{
    [super viewWillAppear];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(500, 400)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showView) name:@"ticketsVCDismiss" object:nil];
  
    self.touchPointArr=[NSMutableArray array];
    
    self.touchViewArr=[NSMutableArray array];
    
    __weak typeof(self)weakself=self;
    
    [MBProgressHUD showHUDAddedTo:self.codeImage animated:YES];

    [[loginHttpRequestManage shaerd]initRequestWithSuccess:^(NSDictionary * _Nonnull data) {
    
        if (data) {
            
            NSLog(@"初始化成功!");
            
            [weakself getNewRoute];
              
            dispatch_async(dispatch_get_main_queue(), ^{
                       
                NSClickGestureRecognizer *ClickGesture=[[NSClickGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageCode:)];
                       
                [weakself.codeImage addGestureRecognizer:ClickGesture];
                
            });
        
        }else{
           
            NSLog(@"初始化失败!");

        }
   
        [MBProgressHUD hideHUDForView:self.codeImage animated:YES];

    } failure:^(NSError * _Nonnull error) {
       
        NSLog(@"初始化失败!");

        [MBProgressHUD hideHUDForView:self.codeImage animated:YES];

    }];

    // Do any additional setup after loading the view.
}

-(void)showView{
    
    NSLog(@"退出程序!");

    exit(0);
    
}


-(void)clickImageCode:(NSClickGestureRecognizer *)ges{
    
    CGPoint touchPoint =[ges locationInView:ges.view];

//    NSLog(@"x:%f , y:%f",touchPoint.x,touchPoint.y);
    
    if (!self.codeImage.image || (160-touchPoint.y<-10 || touchPoint.y<25) || (touchPoint.x>300 || touchPoint.x<5)) {
        
        return;
    }
    
    BOOL isHaveSame=NO;
    
    for (int i=0; i<self.touchViewArr.count; i++) {
        
        NSView *view=self.touchViewArr[i];
        
        if (CGRectContainsPoint(view.frame,CGPointMake(touchPoint.x, touchPoint.y))) {
            
            if (self.touchPointArr.count == self.touchViewArr.count) {
                
                [self.touchPointArr removeObjectAtIndex:i];
                
                for (NSView *tmpView in self.codeImage.subviews) {
                    
                    if (CGRectContainsRect(view.frame, tmpView.frame)) {
                        
                        [tmpView removeFromSuperview];
                        
                        isHaveSame=YES;
                        
                        break;
                    }
                }
                
                if (isHaveSame) {
                    
                    [self.touchViewArr removeObjectAtIndex:i];
                    
                    break;
                }
            }
        }
    }
    
    if (!isHaveSame) {
                
        [self.touchPointArr addObject:@{@"x":[NSString stringWithFormat:@"%f",fabsf(ceilf(touchPoint.x-10)) ],@"y":[NSString stringWithFormat:@"%f",fabsf(160-ceilf(touchPoint.y))]}];
        
        NSView *view=[[NSView alloc]initWithFrame:CGRectMake(touchPoint.x-10, touchPoint.y-10, 20, 20)];
        
        view.wantsLayer = YES;
       
        view.layer.backgroundColor = [NSColor redColor].CGColor;

        [self.codeImage addSubview:view];
        
        [self.touchViewArr addObject:view];

    }
    
}
- (IBAction)clearCache:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableDictionary dictionary] forKey:@"cookieDic"];
        
    if ([[NSUserDefaults standardUserDefaults]synchronize]) {
      
        NSLog(@"缓存清除成功,请重新运行程序!");
        
       exit(0);
        
    }
        
}

- (IBAction)refreshCode:(id)sender {
    
    [self.touchPointArr removeAllObjects];
    
    [self.touchViewArr removeAllObjects];
    
    for (int i=0; i< self.codeImage.subviews.count; i++) {
        
        id view=self.codeImage.subviews[i];
        
        if ([view isKindOfClass:[NSView class]]) {
            
            NSView *tmpView=view;
            
            [tmpView removeFromSuperview];
            
            tmpView=nil;
            
            i-=1;

        }
    }
    
    [self getImageCode];
}

- (IBAction)login:(id)sender {
     
    if (self.passwordTf.stringValue.length<1) {
     
        NSLog(@"请输入账号!");
        
        return;
    }
    
    if (self.touchPointArr.count<1) {
        
        NSLog(@"请输入密码!");

        return;
    }
    
    //检验验证码是否正确
    [self checkVerificationCode];
}

-(void)getNewRoute{
    
    __weak typeof(self)weakself=self;
  
    [[loginHttpRequestManage shaerd]requesOtn_resources_loginWithUrl:otn_resources_loginUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
        
        if (data) {
            
            NSLog(@"获取最新'route'成功!");

            [weakself getImageCode];
            
        }else{
         
            NSLog(@"获取最新'route'失败!");

            [MBProgressHUD hideHUDForView:weakself.codeImage animated:NO];

        }
        
    } failure:^(NSError * _Nonnull error) {
       
        NSLog(@"获取最新'route'失败!");
        
        [MBProgressHUD hideHUDForView:weakself.codeImage animated:NO];

    }];
}


-(void)getImageCode{
    
    __weak typeof(self)weakself=self;
    
    [MBProgressHUD showHUDAddedTo:self.codeImage animated:YES];

    [[loginHttpRequestManage shaerd]requesGetImageCodeWithUrl:[NSString stringWithFormat:@"%@%@",getImageCodeUrl,[NSString currentTimeStamp]] parameters:nil success:^(NSDictionary * _Nonnull data) {
       
        [MBProgressHUD hideHUDForView:weakself.codeImage animated:NO];

        if ([data[@"result_code"] intValue] == 0 && data) {
        
            NSLog(@"获取验证码成功!");
            
            weakself.codeImage.image=[weakself decodeBase64ToImage:data[@"image"]];
            
        }else{
            
            NSLog(@"获取验证码失败!");

        }
        
    } failure:^(NSError * _Nonnull error) {
       
        NSLog(@"获取验证码失败!");
        
        [MBProgressHUD hideHUDForView:weakself.codeImage animated:NO];

    }];
        
        
}

-(void)checkVerificationCode{
    
    __weak typeof(self)weakself=self;
        
    [[loginHttpRequestManage shaerd]requesCheckVerificationCodeWithUrl:[NSString stringWithFormat:@"%@answer=%@&rand=sjrand&login_site=E&_=%@",checkImageCodeUrl,[self getVerificationCodeLocationStrWithType:0],[NSString currentTimeStamp]] parameters:nil success:^(NSDictionary * _Nonnull data) {
        
        if ([data[@"result_code"] intValue] == 4) {
       
            NSLog(@"验证码校验成功!");

            //验证码校验成功 去走登录接口
            [weakself login];
            
        }else{
            
            NSLog(@"验证码校验失败!重新获取验证码...");

            //刷新验证码
            [weakself refreshCode:nil];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"验证码校验失败!");

    }];
}

-(void)login{
  
    __weak typeof(self)weakself=self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[loginHttpRequestManage shaerd]requesLoginWithUrl:loginUrl parameters:@{@"username":self.accountTf.stringValue,@"password":self.passwordTf.stringValue,@"appid":@"otn",@"answer":[self getVerificationCodeLocationStrWithType:1]} success:^(NSDictionary * _Nonnull data) {
        
        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

        if (data && data.count>0) {

            NSLog(@"%@ %@",data[@"data"][@"user_name"],data[@"data"][@"user_regard"]);
            
            [weakself.view.window close];
            
            ticketsVC *vc=[[ticketsVC alloc]init];
               
            vc.nameStr=[NSString stringWithFormat:@"%@  %@",data[@"data"][@"user_name"],data[@"data"][@"user_regard"]];
            
            [weakself presentViewControllerAsModalWindow:vc];
            
        }else{
           
            NSLog(@"登录失败!");

        }
        
    } failure:^(NSError * _Nonnull error) {
       
        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

        NSLog(@"登录失败!");

    }];
}


-(NSString *)getVerificationCodeLocationStrWithType:(NSInteger)type{
    
    NSString *locationStr=@"";
           
    for (int i=0; i<self.touchPointArr.count; i++) {
                   
        NSString *xStr=[[self.touchPointArr[i][@"x"] componentsSeparatedByString:@"."] firstObject];
           
        NSString *yStr=[[self.touchPointArr[i][@"y"] componentsSeparatedByString:@"."] firstObject];
                  
        if (type==0) {
               
            locationStr=[locationStr stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",xStr,@"%2C",yStr]];
                     
            if (i==0 && self.touchPointArr.count>1) {
            
                locationStr=[locationStr stringByAppendingString:@"%2C"];

            }
         
        }else{
               
            locationStr=[locationStr stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",xStr,@",",yStr]];
                  
            if (i==0 && self.touchPointArr.count>1) {
                                  
                locationStr=[locationStr stringByAppendingString:@","];
                
            }
        }
                  
    }
    
   
    return locationStr;
}

- (NSImage*)decodeBase64ToImage:(NSString*)strEncodeData {

    if (strEncodeData.length<1) {
        
        return nil;
    }
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [[NSImage alloc]initWithData:data];

}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
