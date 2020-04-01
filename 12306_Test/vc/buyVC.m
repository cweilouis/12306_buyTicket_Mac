//
//  buyVC.m
//  12306_Test
//
//  Created by cwei on 2020/3/5.
//  Copyright © 2020 louis. All rights reserved.
//

#import "buyVC.h"
#import "confirmOrderVC.h"

@interface buyVC ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTextField *trainInfoView;
@property (weak) IBOutlet NSTextField *ticketInfoView;
@property(nonatomic,strong)selTrainInfoModel *sltModel;
@property (weak) IBOutlet NSScrollView *scorView;
@property(nonatomic,strong)NSButton *passengersBtn;
@property(nonatomic,strong)NSMutableArray *passengerInfoArr;
@property (weak) IBOutlet NSTableView *tableView;
@property(nonatomic,strong)NSMutableArray *selPassengerArr;
@end

@implementation buyVC

- (void)viewWillAppear
{
    [super viewWillAppear];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(800, 500)];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"购买";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BuySuccess) name:@"BuyTicketSuccess" object:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.scorView setHasHorizontalScroller:YES];
          
    [self.scorView setBorderType:NSGrooveBorder];
     
    self.scorView.scrollerStyle=NSScrollerStyleLegacy;

    self.passengerInfoArr=[NSMutableArray array];
    
    self.selPassengerArr=[NSMutableArray array];
            
    self.tableView.delegate=self;
    
    self.tableView.dataSource=self;
        self.tableView.selectionHighlightStyle=NSTableViewSelectionHighlightStyleNone;
    
    [self requestInfo];
            
}

-(void)BuySuccess{
    
    [self.view.window close];
    
}

-(void)CreatePassengersViewWithArr:(NSMutableArray *)arr{
    
    NSView *scroContenView=[[NSView alloc]initWithFrame:CGRectMake(0, 0, (15+80)*arr.count, 50)];
    
    for (int i=0; i<arr.count; i++) {
        
        self.passengersBtn=[[NSButton alloc]initWithFrame:CGRectMake((15+80)*i, 0, 80, 40)];
        
        [self.passengersBtn setButtonType:NSButtonTypeSwitch];
        
        passengersInfoModel *model=arr[i];
        
        self.passengersBtn.title=model.passenger_name;
        
        self.passengersBtn.font=[NSFont systemFontOfSize:15];
        
        self.passengersBtn.alignment=NSTextAlignmentCenter;
        
        self.passengersBtn.tag=i+1;
        
        [self.passengersBtn setAction:@selector(click:)];
        
        [scroContenView addSubview:self.passengersBtn];
        
    }
           
    self.scorView.documentView=scroContenView;
    
}

-(void)click:(NSButton *)btn{
    
    NSInteger index=btn.tag-1;
    
    if (self.passengerInfoArr.count>index) {
        
        passengersInfoModel *model=self.passengerInfoArr[index];
        
        if (btn.state==0) {
        
            model.isSel=NO;
            
            for (int i=0; i<self.selPassengerArr.count; i++) {
                
                passengersInfoModel *tmpModel=self.selPassengerArr[i];

                if ([model.passenger_name isEqualToString:tmpModel.passenger_name]) {
                    
                    if (self.selPassengerArr.count > i) {
                        
                        [self.selPassengerArr removeObjectAtIndex:i];
                                                               
                        break;
                    }
                }
            }
            
            if (self.selPassengerArr.count<1) {
                
                self.tableView.hidden=YES;
            }
            
        }else{
            
            model.isSel=YES;
            
            [self.selPassengerArr addObject:model];
            
            if (self.selPassengerArr.count>0) {
                                
                self.tableView.hidden=NO;

            }
            
        }
        
        [self.tableView reloadData];
    }
}

- (IBAction)backAction:(NSButton *)sender {
    
    [self dismissViewController:self];
}

- (IBAction)submitOrder:(NSButton *)sender {
    
    [self requestCheckOrderInfo];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return self.selPassengerArr.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    return @1;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    
    return 25;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"selPasCell" owner:self];
   
    [self setCellInfoWithIndex:row cellView:cellView];
    
    return cellView;

}

-(void)setCellInfoWithIndex:(NSInteger)index cellView:(NSTableCellView *)cellView{
    
    if (self.selPassengerArr.count >index) {
        
        passengersInfoModel *model=self.selPassengerArr[index];
        
        NSTextField *index_idLab=[cellView viewWithTag:101];
        
        if (index_idLab) {
            
            index_idLab.stringValue=[NSString stringWithFormat:@"%d",model.index_id.intValue+1];
        }
        
        NSPopUpButton *xibie=[cellView viewWithTag:103];
        
        if (xibie) {
            
            [xibie removeAllItems];
            
            [xibie setTitle:self.sltModel.CanBuyTick_left.firstObject];
            
            [xibie addItemsWithTitles:self.sltModel.CanBuyTick_left];
        
            for (NSDictionary *dic in self.sltModel.seat_type_codes) {
                
                if ([self.sltModel.CanBuyTick_left.firstObject containsString:dic[@"value"]]) {
                    
                    model.xibie=dic[@"id"];
                    
                    break;
                }
            }
            
            [xibie setAction:@selector(xibieChange:)];
        }
        
        NSTextField *passenger_nameLab=[cellView viewWithTag:104];
               
        if (passenger_nameLab) {
        
            passenger_nameLab.stringValue=model.passenger_name;

        }
        
        NSTextField *passenger_id_noLab=[cellView viewWithTag:106];
               
        if (passenger_id_noLab) {
        
            passenger_id_noLab.stringValue=model.passenger_id_no;

        }
        
        NSTextField *mobile_noLab=[cellView viewWithTag:107];
               
        if (mobile_noLab) {
        
            mobile_noLab.stringValue=model.mobile_no;

        }
        
    }
}


-(void)xibieChange:(NSPopUpButton *)xibie{
    
    NSInteger cellIndex=[self.tableView rowForView:xibie];

    if (self.selPassengerArr.count > cellIndex) {
        
        passengersInfoModel *model=self.selPassengerArr[cellIndex];
        
        for (NSDictionary *dic in self.sltModel.seat_type_codes) {
                       
            if ([xibie.selectedItem.title containsString:dic[@"value"]]) {
                           
                model.xibie=dic[@"id"];
                           
                break;
            }
        }
    }
}

- (IBAction)deleteSelPasAction:(NSButton *)sender {
    
    if (sender.tag==108) {
        
        NSInteger deleteIndex=[self.tableView rowForView:sender];
        
        if (self.selPassengerArr.count > deleteIndex) {
        
            passengersInfoModel *model=self.selPassengerArr[deleteIndex];
            
            for (passengersInfoModel *tmpModel in self.passengerInfoArr) {
                
                if ([model.index_id isEqualToString:tmpModel.index_id]) {
                    
                    tmpModel.isSel=NO;
                    
                    break;
                }
            }
            
            for (NSButton *btn in self.scorView.documentView.subviews) {
                
                if ([btn.title isEqualToString:model.passenger_name]) {
                    
                    btn.state=NO;
                    
                    break;
                }
            }
            
            [self.selPassengerArr removeObjectAtIndex:deleteIndex];
                                                      
            [self.tableView reloadData];

            if (self.selPassengerArr.count<1) {
                               
                self.tableView.hidden=YES;
                               
            }
        }
    }
}


-(void)requestInfo{
    
    __weak typeof(self)weakself=self;
    
    [[BuyHttpRequestManager shaerd]RequestWithUrl:checkUserUrl parameters:self.dict Success:^(NSDictionary * _Nonnull data) {
       
        if (data && data.count>0) {
            
            weakself.sltModel=[[selTrainInfoModel alloc]initWithDic:data];
            
            if (weakself.sltModel) {
                
                weakself.trainInfoView.stringValue=[NSString stringWithFormat:@"%@  %@次   %@站 (%@开) -- %@站 (%@到)",weakself.sltModel.date,weakself.sltModel.station_train_code,weakself.sltModel.from_station_name,weakself.sltModel.start_time,weakself.sltModel.to_station_name,weakself.sltModel.arrive_time];
                weakself.ticketInfoView.stringValue=weakself.sltModel.leftDetails;
                
                [weakself requestGetPassengers];
                
            }
            
        }else{
            
            NSLog(@"信息加载失败!请重新选择车次!");

        }
        
        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

        NSLog(@"%@ \r 请重新选择车次!",error.userInfo[@"infor"]);

        [weakself.view.window close];

    }];
}

-(void)requestGetPassengers{
    
    __weak typeof(self)weakself=self;

    [[BuyHttpRequestManager shaerd]RequestGetPassengerDTOsWithUrl:getPassengerDTOsUrl parameters:@{@"_json_att":@"",@"REPEAT_SUBMIT_TOKEN":self.sltModel.globalRepeatSubmitToken} Success:^(NSDictionary * _Nonnull data) {
        
        if (data && data.count>0) {
            
            NSArray *arr= data[@"data"][@"normal_passengers"];
            
            for (NSDictionary *dict in arr ) {
                
                passengersInfoModel *model=[passengersInfoModel mj_objectWithKeyValues:dict];
                
                [weakself.passengerInfoArr addObject:model];
                
            }
            
            if (weakself.passengerInfoArr.count>0) {
                
                [weakself CreatePassengersViewWithArr:weakself.passengerInfoArr];
                
            }
            
        }else{
            
            NSLog(@"获取乘车人信息失败,请稍后重试");

        }
        
        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
    
        NSLog(@"获取乘车人信息失败,请稍后重试");

        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

    }];
}

-(void)requestCheckOrderInfo{

    __weak typeof(self)weakself=self;
    
    NSMutableDictionary *parameters=[self CheckOrderInfoDicWithArr:self.selPassengerArr globalRepeatSubmitToken:self.sltModel.globalRepeatSubmitToken];
    
    NSString *SeatType=[parameters[@"passengerTicketStr"]length]>1? [parameters[@"passengerTicketStr"]substringWithRange:NSMakeRange(0, 1)]:@"";
    
    NSMutableDictionary *parameters1=[self getQueueCountDicWithSeatType:SeatType];
    
    [[BuyHttpRequestManager shaerd]RequestCheckOrderInfoWithUrl:checkOrderInfoUrl parameters:parameters parameters1:parameters1 Success:^(NSDictionary * _Nonnull data) {
     
        if (data && data.count>0) {
            
            [weakself gotoSureVCWithData:data CheckOrderInfoData:[parameters copy] getQueueCountData:[parameters1 copy]];
            
        }
                
    } failure:^(NSError * _Nonnull error) {
                
    }];
}

-(void)gotoSureVCWithData:(NSDictionary *)data CheckOrderInfoData:(NSMutableDictionary *)dict getQueueCountData:(NSMutableDictionary *)dict1{
    
    confirmOrderVC *vc=[[confirmOrderVC alloc]init];
     
     if ([data[@"canChooseSeats"] isEqualToString:@"Y"]) {
         
         vc.canSelSeat=YES;
    
     }else{
         
         vc.canSelSeat=NO;

     }
     
     vc.numberOfline=[data[@"count"] intValue];
     
     vc.numberOfPassengers=self.selPassengerArr.count;
     
     if ([data[@"ticket"] containsString:@","]) {
         
         NSArray *ticketNumArr=[data[@"ticket"] componentsSeparatedByString:@","];
         
         BOOL ishave=NO;
         
         for (NSString *tickStr in ticketNumArr) {
             
             if ([tickStr intValue]>0) {
                 
                 ishave=YES;
                 
                 break;
             }
         }
         
         if (ishave) {
             
             vc.isHaveticket=YES;
         
         }else{
             
             vc.isHaveticket=NO;

         }
         
     }else{
         
         if ([data[@"ticket"] intValue]>0) {
             
             vc.isHaveticket=YES;
         
         }else{
             
             vc.isHaveticket=NO;

         }
     }
       
    vc.CheckOrderInfoData=dict;

    vc.getQueueCountData=dict1;

    vc.key_check_isChange=self.sltModel.key_check_isChange;
    
    [self presentViewControllerAsSheet:vc];
}

-(NSMutableDictionary *)CheckOrderInfoDicWithArr:(NSMutableArray *)selPassArr globalRepeatSubmitToken:(NSString *)globalRepeatSubmitToken{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    [dict setObject:@"2" forKey:@"cancel_flag"];
    
    [dict setObject:@"000000000000000000000000000000" forKey:@"bed_level_order_num"];

    [dict setObject:@"dc" forKey:@"tour_flag"];

    [dict setObject:@"" forKey:@"randCode"];

    [dict setObject:@"1" forKey:@"whatsSelect"];

    [dict setObject:@"" forKey:@"sessionId"];

    [dict setObject:@"" forKey:@"sig"];
    
    [dict setObject:@"nc_login" forKey:@"scene"];

    [dict setObject:@"" forKey:@"_json_att"];

    [dict setObject:self.sltModel.globalRepeatSubmitToken forKey:@"REPEAT_SUBMIT_TOKEN"];
    
    NSString *tmpOldPassengerStr=@"";
    
    NSString *tmpPassengerTicketStr=@"";
    
    for (int i=0; i<self.selPassengerArr.count; i++) {
        
        passengersInfoModel *model=self.selPassengerArr[i];
        
        tmpOldPassengerStr=[tmpOldPassengerStr stringByAppendingString:[NSString stringWithFormat:@"%@,1,%@,",model.passenger_name,model.passenger_id_no]];
        
        tmpOldPassengerStr=[tmpOldPassengerStr stringByAppendingString:@"1_"];
        
        //  席别(座位类型),passenger_flag,passenger_type/passenger_id_type_code,乘客类型(默认 1 -> 成人票),名字,证件类型(默认 1-> 身份证),证件号,电话号码,isOldThan60/isYongThan10/isYongThan14/is_buy_ticket,allEncStr

        tmpPassengerTicketStr=[tmpPassengerTicketStr stringByAppendingString:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@",model.xibie,model.passenger_flag,@"1",model.passenger_name,@"1",model.passenger_id_no,model.mobile_no,model.isOldThan60,model.allEncStr]];
        
        if (i!=self.selPassengerArr.count-1) {
            
            tmpPassengerTicketStr=[tmpPassengerTicketStr stringByAppendingString:@"_"];

        }
        
    }
    
    [dict setObject:tmpOldPassengerStr forKey:@"oldPassengerStr"];

    [dict setObject:tmpPassengerTicketStr forKey:@"passengerTicketStr"];

    return dict;
}

-(NSMutableDictionary *)getQueueCountDicWithSeatType:(NSString *)seatType{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    [dict setObject:self.sltModel.train_date forKey:@"train_date"];
    
    [dict setObject:self.sltModel.train_no forKey:@"train_no"];

    [dict setObject:self.sltModel.station_train_code forKey:@"stationTrainCode"];

    [dict setObject:seatType forKey:@"seatType"];

    [dict setObject:self.sltModel.fromStationTelecode forKey:@"fromStationTelecode"];

    [dict setObject:self.sltModel.toStationTelecode forKey:@"toStationTelecode"];

    [dict setObject:self.sltModel.leftTicketStr forKey:@"leftTicket"];
    
    [dict setObject:self.sltModel.purpose_codes forKey:@"purpose_codes"];

    [dict setObject:self.sltModel.train_location forKey:@"train_location"];
    
    [dict setObject:@"" forKey:@"_json_att"];

    [dict setObject:self.sltModel.globalRepeatSubmitToken forKey:@"REPEAT_SUBMIT_TOKEN"];

    return dict;
}



@end
