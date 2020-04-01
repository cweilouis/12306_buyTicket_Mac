//
//  ticketsVC.m
//  12306_Test
//
//  Created by 曹巍 on 2020/1/21.
//  Copyright © 2020 louis. All rights reserved.
//

#import "ticketsVC.h"
#import "searchTicketModel.h"
#import "buyVC.h"
#import "orderManage.h"

@interface ticketsVC ()<NSTableViewDelegate,NSTableViewDataSource,ASHDatePickerDelegate>
@property (weak) IBOutlet NSColorWell *bgView;
@property (weak) IBOutlet NSTextField *nameLab;
@property (weak) IBOutlet NSTextField *formTF;
@property (weak) IBOutlet NSTextField *toTF;
@property (weak) IBOutlet NSButton *dateBtn;
@property (weak) IBOutlet NSTableView *tableView;
@property(nonatomic,strong)NSMutableArray *stationArr;
@property(nonatomic,strong)NSMutableArray *searchTicketArr;
@property (weak) IBOutlet NSTableView *headTabelView;
@property (weak) IBOutlet ASHDatePicker *datePick;
@end

@implementation ticketsVC

- (void)viewWillAppear
{
    [super viewWillAppear];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(900, 600)];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"查票";
    
    self.nameLab.stringValue=self.nameStr;
    
    self.stationArr=[NSMutableArray array];
    
    self.dateBtn.title=[NSString currentDate];
    
    self.datePick.delegate = self;
    
    self.datePick.dateValue = [NSDate date];;
    
    self.datePick.preferredPopoverEdge = NSMinYEdge;
 
    self.tableView.selectionHighlightStyle=NSTableViewSelectionHighlightStyleNone;
    
    [self getStationInfo];  
}

-(NSMutableArray *)searchTicketArr{
    
    if (!_searchTicketArr) {
    
        _searchTicketArr=[NSMutableArray array];
    }
    
    return _searchTicketArr;
}


- (BOOL)datePickerShouldShowPopover:(ASHDatePicker *)datepicker{
  
    return YES;
}
- (IBAction)exchangeStationAction:(id)sender {
    
    if (self.formTF.stringValue.length>0 && self.toTF.stringValue.length>0) {
        
        NSString *tmpStr=self.formTF.stringValue;
        
        self.formTF.stringValue=self.toTF.stringValue;
        
        self.toTF.stringValue=tmpStr;
        
    }
    
}

- (IBAction)searchClick:(id)sender {
    
    if (self.formTF.stringValue.length<1 || ![self isSameStationWithSationStr:self.formTF.stringValue]) {
        
        NSLog(@"请输正确的入出发地!");
        
        return;
    }
    
    if (self.toTF.stringValue.length<1 || ![self isSameStationWithSationStr:self.toTF.stringValue]) {
        
        NSLog(@"请输入正确的到达地!");
        
        return;
    }
    
    [self.searchTicketArr removeAllObjects];
    
    [self.tableView reloadData];
    
    [self searchTicketsWithAllWrittenForm:self.formTF.stringValue shorthandForm:[self getShorthandStationWithSationStr:self.formTF.stringValue] AllWrittenTo:self.toTF.stringValue shorthandTo:[self getShorthandStationWithSationStr:self.toTF.stringValue] currentTime:[NSString currentDate] selTime:[NSString coverTimeWithStr:self.datePick.dateValue]];
        
}
- (IBAction)ticketOrderAction:(id)sender {
    
    orderManage *vc=[[orderManage alloc]init];
        
    [self presentViewControllerAsModalWindow:vc];

        
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    if (tableView == self.headTabelView) {
        
        return 1;
    }
    
    return self.searchTicketArr.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    return @1;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    
    return 65;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

    if (tableView==self.headTabelView) {

        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"12345" owner:self];

          return cellView;

    }

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"1234" owner:self];
   
    searchTicketModel *model=self.searchTicketArr[row];
    
    [self setCellValue:cellView model:model];
        
    return cellView;

}

-(void)setCellValue:(NSTableCellView *)cell model:(searchTicketModel*)model{
    
    for (NSTextField *view in cell.subviews) {
        
        if (view.tag == 1) {
               
            view.stringValue=model.station_train_code;
               
        }else if (view.tag == 2) {
               
            view.stringValue=[NSString stringWithFormat:@"%@\r%@",model.from_station_name,model.to_station_name];
                          
        }else if (view.tag == 16) {
               
            view.stringValue=model.buttonTextInfo;
                           
            if ([model.buttonTextInfo isEqualToString:@"列车停运"]) {
                   
                view.textColor=[NSColor lightGrayColor];
             
            }else{
                                  
                if (model.canBuy) {
                
                    view.textColor=[NSColor blueColor];
                 
                }else{
                
                    view.textColor=[NSColor lightGrayColor];

                }
                 
            }
          
        }
           
        if (![model.buttonTextInfo isEqualToString:@"列车停运"]) {
            
            if (view.tag == 3) {
                
                view.stringValue=[NSString stringWithFormat:@"%@\r%@",model.start_time,model.arrive_time];

            }else if (view.tag == 4) {
                
                view.stringValue=[NSString stringWithFormat:@"%@\r%@",model.lishi,model.isOntheday?@"当日到达":@"次日到达"];

            }
            
            if (view.tag == 5) {
                
                view.stringValue=model.swz_num;//商务座特等座
                
            }else if (view.tag == 6) {
                
                view.stringValue=model.zy_num;//一等座
                
            }else if (view.tag == 7) {
                
                view.stringValue=model.ze_num;//二等座二等包座
                
            }else if (view.tag == 8) {
                
                view.stringValue=model.gr_num;//高级软卧
                
            }else if (view.tag == 9) {
                
                view.stringValue=model.rw_num;//软卧一等卧
                
            }else if (view.tag == 10) {
                
                view.stringValue=@"";//动卧
                
            }else if (view.tag == 11) {
                
                view.stringValue=model.yw_num;//硬卧二等卧
                
            }else if (view.tag == 12) {
                
                view.stringValue=model.rz_num;//软座
                
            }else if (view.tag == 13) {
                
                view.stringValue=model.yz_num;//硬座
                
            }else if (view.tag == 14) {
                
                view.stringValue=model.wz_num;//无座
                
            }else if (view.tag == 15) {
                
                view.stringValue=model.qt_num;//其他
                
            }
   
        }else{
            
            if (view.tag == 3) {
                
                view.stringValue=@"----";

            }else if (view.tag == 4) {
                
                view.stringValue=@"----";

            }else if (view.tag == 5) {
                            
                view.stringValue=@"--";
                                                
            }else if (view.tag == 6) {
                            
                view.stringValue=@"--";
                                
            }else if (view.tag == 7) {

                view.stringValue=@"--";
                
            }else if (view.tag == 8) {
                                
                view.stringValue=@"--";
                
            }else if (view.tag == 9) {
                                
                view.stringValue=@"--";
                
            }else if (view.tag == 10) {
                                
                view.stringValue=@"--";
                                                            
            }else if (view.tag == 11) {
                                
                view.stringValue=@"--";
                                
            }else if (view.tag == 12) {
                                            
                view.stringValue=@"--";
                
            }else if (view.tag == 13) {
                            
                view.stringValue=@"--";
                                
            }else if (view.tag == 14) {
                            
                view.stringValue=@"--";
                                
            }else if (view.tag == 15) {
                                
                view.stringValue=@"--";
                                
            }
        }
    }
}

- (IBAction)buyAction:(NSClickGestureRecognizer *)sender {
    
    id view=sender.view;

    if ([view isKindOfClass:[NSTextField class]]) {
        
        NSTextField *view1=view;
        
        NSInteger clickIndex=[self.tableView rowForView:view1];
        
        if (self.searchTicketArr.count > clickIndex) {
            
            searchTicketModel *model=self.searchTicketArr[clickIndex];
        
            if (model.canBuy) {
                
                NSLog(@"%ld 可以购买",clickIndex);

                buyVC *vc=[[buyVC alloc]init];                
          
                vc.dict=@{@"secretStr":[NSString stringDecodeWithStr:model.secretStr],@"train_date":[NSString coverStrWithStr:model.start_train_date],@"back_train_date":[NSString coverStrWithStr:model.start_train_date],@"tour_flag":@"dc",@"purpose_codes":@"ADULT",@"query_from_station_name":model.from_station_name,@"query_to_station_name":model.to_station_name,@"undefined":@""};
                
                [self presentViewControllerAsModalWindow:vc];
                
            }
        
        }
        
    }
    
}

-(void)getStationInfo{
    
    __weak typeof(self)weakself=self;
    
    [[ticketsHttpRequestManager shaerd]requesStationUrlWithUrl:stationUrl parameters:nil success:^(NSDictionary * _Nonnull data) {
    
        if (data && data.count>0) {
           
            NSLog(@"获取最新站点信息成功!");

            NSArray *tmpStationArr=[data[@"station"] componentsSeparatedByString:@"|"];
            
//            NSLog(@"%@",tmpStationArr);

            NSString *keyStr=@"";

            NSString *valueStr=@"";

            int count=3;
            
            for (int i=0; i<tmpStationArr.count; i++) {
                
                NSString  *satStr=tmpStationArr[i];
                
                if (i==0) continue;
                
                if (count==3) {
                    
//                    i+=2;
                    
                    count=2;
                   
                    keyStr=satStr;

                }else if(count==2) {
                    
                    i+=3;
                    
                    count=3;

                    valueStr=satStr;

                }
                
                if (keyStr.length>0 && valueStr.length>0) {
                    
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];

                    [dict setObject:[valueStr uppercaseString] forKey:keyStr];
                    
                    [weakself.stationArr addObject:dict];
                    
                    keyStr=@"";
                    
                    valueStr=@"";
                }
            }
                    
        }else{
            
            NSLog(@"获取最新站点信息失败!");

        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"获取最新站点信息失败!");
    }];
}

-(void)searchTicketsWithAllWrittenForm:(NSString *)AllWrittenForm shorthandForm:(NSString*)shorthandForm AllWrittenTo:(NSString *)AllWrittenTo  shorthandTo:(NSString*)shorthandTo currentTime:(NSString*)currentTime selTime:(NSString*)selTime{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"cookieDic"]];
    
    if (dict) {
        
        [dict setObject:currentTime forKey:@"_jc_save_fromDate"];
        
        [dict setObject:selTime forKey:@"_jc_save_toDate"];

        [dict setObject:[NSString stringWithFormat:@"%@,%@",AllWrittenForm,shorthandForm] forKey:@"_jc_save_fromStation"];

        [dict setObject:[NSString stringWithFormat:@"%@,%@",AllWrittenTo,shorthandTo] forKey:@"_jc_save_toStation"];
        
        [dict setObject:@"dc" forKey:@"_jc_save_wfdc_flag"];

        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"cookieDic"];
        
        BOOL isSueeces=[[NSUserDefaults standardUserDefaults]synchronize];

        __weak typeof(self)weakself=self;
        
        if (isSueeces) {
            
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];

            [[ticketsHttpRequestManager shaerd]requesleftTicket_queryUrlWithUrl:[NSString stringWithFormat:@"%@leftTicketDTO.train_date=%@&leftTicketDTO.from_station=%@&leftTicketDTO.to_station=%@&purpose_codes=ADULT",leftTicket_queryUrl,selTime,shorthandForm,shorthandTo] parameters:nil success:^(NSDictionary * _Nonnull data) {
                
                if (data && data.count>0) {
                           
                    NSMutableArray *tmpCanBuyArr=[NSMutableArray array];
                    
                    NSArray *allTicketInfoArr=data[@"data"][@"result"];
                    
                    for (NSString *ticketInfoStr in allTicketInfoArr) {
                        
                        NSArray *tmpOneTicketInfo=[ticketInfoStr componentsSeparatedByString:@"|"];
                                                
                        searchTicketModel *model=[[searchTicketModel alloc]initWithDataArr:tmpOneTicketInfo stationNameArr:weakself.stationArr];
                        
                        if (model.canBuy) {
                            
                            [tmpCanBuyArr addObject:model];
                      
                        }else{
                            
                            [weakself.searchTicketArr addObject:model];

                        }
                    }
                    
                    for (searchTicketModel *model in [[tmpCanBuyArr reverseObjectEnumerator] allObjects] ) {
                        
                        [weakself.searchTicketArr insertObject:model atIndex:0];

                    }
                
                }else{
                    
                    NSLog(@"车票查询失败!");

                }
                
                [weakself.tableView reloadData];

                [MBProgressHUD hideAllHUDsForView:weakself.tableView animated:YES];

            } failure:^(NSError * _Nonnull error) {
                
                NSLog(@"车票查询失败!");
                
                [weakself.tableView reloadData];

                [MBProgressHUD hideAllHUDsForView:weakself.tableView animated:YES];

            }];
        }
    }
}

-(BOOL)isSameStationWithSationStr:(NSString *)SationStr{
    
    BOOL isSame=NO;

    for (NSMutableDictionary *dict in self.stationArr) {
        
        NSString *keyName=dict.allKeys.firstObject;
        
        if ([keyName isEqualToString:SationStr]) {
            
            isSame=YES;
            
            break;
        }
    }
    
    return isSame;
}

-(NSString *)getShorthandStationWithSationStr:(NSString *)SationStr{
    
    NSString *shorthandStation=@"";

    for (NSMutableDictionary *dict in self.stationArr) {
        
        NSString *keyName=dict.allKeys.firstObject;
        
        if ([keyName isEqualToString:SationStr]) {
            
            shorthandStation=dict.allValues.firstObject;
            
            break;
        }
    }
    
    return shorthandStation;
}



-(void)dealloc{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"ticketsVCDismiss" object:nil];

}



@end
