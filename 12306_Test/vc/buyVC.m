//
//  buyVC.m
//  12306_Test
//
//  Created by 曹巍 on 2020/3/5.
//  Copyright © 2020 louis. All rights reserved.
//

#import "buyVC.h"

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
    [self.view.window setContentSize:NSMakeSize(800, 600)];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"购买";
    
    [self.scorView setHasHorizontalScroller:YES];
          
    [self.scorView setBorderType:NSGrooveBorder];
     
    self.scorView.scrollerStyle=NSScrollerStyleLegacy;

    self.passengerInfoArr=[NSMutableArray array];
    
    self.selPassengerArr=[NSMutableArray array];
            
    self.tableView.delegate=self;
    
    self.tableView.dataSource=self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
    [self requestInfo];
            
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
        
        NSTextField *xuhaoLab=[cellView viewWithTag:101];
        
        if (xuhaoLab) {
            
            xuhaoLab.stringValue=[NSString stringWithFormat:@"%d",model.index_id.intValue+1];
        }
        
        NSPopUpButton *xibie=[cellView viewWithTag:103];
        
        if (xibie) {
            
            [xibie removeAllItems];
            
            [xibie setTitle:self.sltModel.CanBuyTick_left.firstObject];
            
            [xibie addItemsWithTitles:self.sltModel.CanBuyTick_left];
            
            [xibie setAction:@selector(xibieChange:)];
        }
    }
}


-(void)xibieChange:(NSPopUpButton *)xibie{
    
    NSInteger clickIndex=[self.tableView rowForView:xibie];

    
    
}

- (IBAction)deleteSelPasAction:(NSButton *)sender {
    
    if (sender.tag==108) {
        
        NSInteger deleteIndex=[self.tableView rowForView:sender];
        
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
        
        if (self.selPassengerArr.count > deleteIndex) {
            
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
    // 一个乘客 座位类型,passenger_flag,passenger_type/passenger_id_type_code,名字,证件类型,证件号,电话号码,isOldThan60/isYongThan10/isYongThan14/is_buy_ticket,allEncStr
    
}
@end
