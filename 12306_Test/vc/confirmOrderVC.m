//
//  confirmOrderVC.m
//  12306_Test
//
//  Created by icasa_ios on 2020/3/27.
//  Copyright © 2020 louis. All rights reserved.
//

#import "confirmOrderVC.h"
#import "orderManage.h"

@interface confirmOrderVC ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *titlelab;
@property (weak) IBOutlet NSTextField *subTitlelab;
@property (nonatomic,strong)NSMutableArray *selSeatArr;
@property (weak) IBOutlet NSButton *sureBtn;
@property (nonnull,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL isHaveResult;
@end

@implementation confirmOrderVC

- (void)viewWillAppear{
    
    [super viewWillAppear];

    self.view.window.restorable = NO;

    if (self.canSelSeat) {
        self.titlelab.stringValue=@"*如果本次列车剩余席位无法满足您的选座需求,系统将自动为您分配席位.";
        
        [self.view.window setContentSize:NSMakeSize(500, 300)];
        
        self.tableView.hidden=NO;

    }else{
    
        self.titlelab.stringValue=@"*系统将为您随机申请席位,暂不支持自选席位.";
        
        [self.view.window setContentSize:NSMakeSize(500, 70)];

        self.tableView.hidden=YES;
    }
    
     
    if (self.isHaveticket){
        
        self.sureBtn.enabled=YES;

        if (self.numberOfline>0){
            
            self.subTitlelab.stringValue=[NSString stringWithFormat:@"本次列车尚有余票! 当前排队人数:  %ld",(long)self.numberOfline];

        }else{
            
            self.subTitlelab.stringValue=@"本次列车已尚有余票,请尽快提交购票订单!";

        }
        
    }else{
        
        self.subTitlelab.stringValue=@"请注意: 本次列车已无余票!";

        self.sureBtn.enabled=NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer=[NSTimer timerWithTimeInterval:5 target:self selector:@selector(requestTime) userInfo:nil repeats:YES];
       
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self.timer setFireDate:[NSDate distantFuture]];

    
    self.tableView.selectionHighlightStyle=NSTableViewSelectionHighlightStyleNone;

    self.selSeatArr=[NSMutableArray array];
    
    for (int i=0; i<self.numberOfPassengers; i++) {
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        
        [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"index"];
        
        NSMutableArray *tmpArr=[NSMutableArray array];
        
        for (int j=0; j<5; j++) {
            
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            
            [dict1 setObject:[NSString stringWithFormat:@"%d",j+1] forKey:@"index"];
                   
            [dict1 setObject:@"0" forKey:@"isSel"];
            
            [tmpArr addObject:dict1];
        }
      
        [dict setObject:tmpArr forKey:@"subSel"];

        [self.selSeatArr addObject:dict];

    }
    
    // Do view setup here.
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return self.selSeatArr.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    return @1;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    
    return 25;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"confirmOrderCell" owner:self];
    
    NSMutableDictionary *dict=self.selSeatArr[row];

    NSInteger index=0;

    for (NSMutableDictionary *dict1 in dict[@"subSel"]) {

        if ([dict1[@"isSel"] isEqualToString:@"1"]) {

            index=[dict1[@"index"] integerValue];

            break;
        }

    }

    for (id view in cellView.subviews) {

        if ([view isKindOfClass:[NSButton class]]) {

            NSButton *btn =(NSButton *)view;

            if (index==btn.tag-100) {

                btn.layer.backgroundColor= [NSColor colorWithDeviceRed:44/255.0 green:122/255.0 blue:240/255.0 alpha:1].CGColor;
                          
            }else{

                btn.layer.backgroundColor=[NSColor whiteColor].CGColor;

            }
        }
    }
       
    return cellView;

}

- (IBAction)chooseSeatAction:(NSButton *)sender {
 
    NSInteger selCellIndex=[self.tableView rowForView:sender];
    
    if (self.selSeatArr.count > selCellIndex) {
        
        NSMutableDictionary *dic=self.selSeatArr[selCellIndex];
        
        for (int i=0; i<[dic[@"subSel"] count]; i++) {
            
            NSString *index=dic[@"subSel"][i][@"index"];
            
            if (index.integerValue == sender.tag-100) {
                
                if ([dic[@"subSel"][i][@"isSel"] isEqualToString:@"0"]) {
                    
                    dic[@"subSel"][i][@"isSel"]=@"1";
                
                }else{
                    
                    dic[@"subSel"][i][@"isSel"]=@"0";

                }
            
            }else{
                
                dic[@"subSel"][i][@"isSel"]=@"0";

            }
        }

        [self.tableView reloadData];
    }
    
}

- (IBAction)back:(id)sender {
    
    [self.view.window close];

}

- (IBAction)sureBtnClick:(NSButton *)sender {
    
    [self hideHudWith:NO];

    __weak typeof(self)weakself=self;
     
    [[BuyHttpRequestManager shaerd]RequestConfirmSingleForQueueWithUrl:confirmSingleForQueueUrl parameters:[self ForConfirmSingleForQueueData] Success:^(NSDictionary * _Nonnull data) {
          
        if (data && data.count>0) {
        
            [weakself RequestQueryOrderWaitTime];
            
            [weakself.timer setFireDate:[NSDate distantPast]];
           
        }else{
            
            [weakself hideHudWith:YES];
        }
       
    } failure:^(NSError * _Nonnull error) {
               
        [weakself hideHudWith:YES];

    }];
}

-(void)requestTime{
    
    if (!self.isHaveResult) {
                
        [self RequestQueryOrderWaitTime];
    }
    
}


-(void)RequestQueryOrderWaitTime{
    
    __weak typeof(self)weakSelf=self;
        
    [[BuyHttpRequestManager shaerd]RequestQueryOrderWaitTimeWithUrl:[NSString stringWithFormat:@"%@random=%@&tourFlag=dc&_json_att=&REPEAT_SUBMIT_TOKEN=%@",queryOrderWaitTimeUrl,[NSString currentTimeStamp],self.getQueueCountData[@"REPEAT_SUBMIT_TOKEN"]] parameters:nil Success:^(NSDictionary * _Nonnull data) {
    
        if (data && data.count>0) {

            if (weakSelf.isHaveResult) return ;
               
            [weakSelf.timer setFireDate:[NSDate distantFuture]];

            if (![data[@"orderId"] isKindOfClass:[NSNull class]]) {
               
                //确认订单下单是否成功
                [weakSelf RequestResultOrderForDcQueueWithorderSequence_no:data[@"orderId"]];
           
            }else {
                
                NSLog(@"%@",data[@"msg"]);
                
                [weakSelf hideHudWith:YES];
                
            }
            
            weakSelf.isHaveResult=YES;
        }

    } failure:^(NSError * _Nonnull error) {
    
        [weakSelf.timer setFireDate:[NSDate distantFuture]];
        
        [weakSelf hideHudWith:YES];

    }];
    
}

-(void)RequestResultOrderForDcQueueWithorderSequence_no:(NSString *)orderSequence_no{
    
    __weak typeof(self)weakSelf=self;

    [[BuyHttpRequestManager shaerd]RequestResultOrderForDcQueueWithUrl:resultOrderForDcQueueUrl parameters:@{@"orderSequence_no":orderSequence_no,@"_json_att":@"",@"REPEAT_SUBMIT_TOKEN":self.getQueueCountData[@"REPEAT_SUBMIT_TOKEN"]} Success:^(NSDictionary * _Nonnull data) {
        
        if (data && data.count>0) {
        
            [weakSelf hideHudWith:YES];
            
            NSLog(@"订票成功,请尽快去支付!");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BuyTicketSuccess" object:nil];
            
            [weakSelf.view.window close];

            //跳转订单详情
            orderManage *vc=[[orderManage alloc]init];
                      
            [weakSelf presentViewControllerAsModalWindow:vc];
            
            return;
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {

        NSLog(@"订票失败!");
        
        [weakSelf hideHudWith:YES];
        
    }];
}


-(NSMutableDictionary *)ForConfirmSingleForQueueData{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    [dict setObject:self.CheckOrderInfoData[@"passengerTicketStr"] forKey:@"passengerTicketStr"];
    
    [dict setObject:self.CheckOrderInfoData[@"oldPassengerStr"] forKey:@"oldPassengerStr"];

    [dict setObject:@"" forKey:@"randCode"];
    
    [dict setObject:self.getQueueCountData[@"purpose_codes"] forKey:@"purpose_codes"];

    [dict setObject:self.key_check_isChange forKey:@"key_check_isChange"];

    [dict setObject:self.getQueueCountData[@"leftTicket"] forKey:@"leftTicketStr"];

    [dict setObject:self.getQueueCountData[@"train_location"] forKey:@"train_location"];

    [dict setObject:[self getChoose_seatsStr] forKey:@"choose_seats"];

    [dict setObject:@"000" forKey:@"seatDetailType"];

    [dict setObject:@"1" forKey:@"whatsSelect"];
    
    [dict setObject:@"00" forKey:@"roomType"];

    [dict setObject:@"N" forKey:@"dwAll"];

    [dict setObject:@"N" forKey:@"_json_att"];

    [dict setObject:self.getQueueCountData[@"REPEAT_SUBMIT_TOKEN"] forKey:@"REPEAT_SUBMIT_TOKEN"];

    return dict;
}

-(NSString *)getChoose_seatsStr{

    NSString *seats=@"";
    
    for (int i=0; i<self.selSeatArr.count; i++) {

        seats=[seats stringByAppendingString:self.selSeatArr[i][@"index"]];
        
        for (int j=0; j<[self.selSeatArr[i][@"subSel"] count]; j++) {
            
            if ([self.selSeatArr[i][@"subSel"][j][@"isSel"] isEqualToString:@"1"]) {
                
                seats=[seats stringByAppendingString:[self zhStrCoverToEnStr:self.selSeatArr[i][@"subSel"][j][@"index"]]];

            }
        }

    }

    return seats;
}

-(NSString *)zhStrCoverToEnStr:(NSString *)text{
    
    if ([text isEqualToString:@"1"]) {
        
        return @"A";
        
    }else if ([text isEqualToString:@"2"]){
        
        return @"B";

    }else if ([text isEqualToString:@"3"]){
        
        return @"C";

    }else if ([text isEqualToString:@"4"]){
        
        return @"D";

    }else if ([text isEqualToString:@"5"]){
        
        return @"F";

    }

    return @"";

}

-(void)hideHudWith:(BOOL)isHide{
    
    if (isHide) {
        
        if (self.tableView.hidden) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }else{
         
            [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];

        }
        
    }else{
        
        if (self.tableView.hidden) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        }else{
         
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];

        }
    }
    
}

@end
