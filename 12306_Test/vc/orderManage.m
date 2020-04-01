//
//  orderManage.m
//  12306_Test
//
//  Created by icasa_ios on 2020/3/30.
//  Copyright © 2020 louis. All rights reserved.
//

#import "orderManage.h"

@interface orderManage ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet OSXPullToRefreshScrollView *tableScrollView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSSegmentedControl *segmentControl;
@property (weak) IBOutlet NSTextField *tipsLab;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation orderManage

- (void)viewWillAppear
{
    [super viewWillAppear];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(800, 600)];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"车票订单";
    
    self.dataArr=[NSMutableArray array];
    
    __weak typeof(self)weakself=self;
    
    [self.tableScrollView beginLoadingWithStartLoadinBlock:^{
    
        [weakself.dataArr removeAllObjects];
        
        if (weakself.segmentControl.selectedSegment==0) {
            
            [weakself requesQueryMyOrderNoComplete];
            
        }else{
         
            [weakself QueryMyOrderWithSelIndex:weakself.segmentControl.selectedSegment];
        }
        
    }];
    
    [self.tableScrollView startLoading];
    
    // Do view setup here.
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return self.dataArr.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    return @1;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    
    return 65;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"orderManageCell" owner:self];
    
    [self setCellDataWithArr:self.dataArr row:row cellView:cellView];
    
    return cellView;

}

-(void)setCellDataWithArr:(NSMutableArray *)arr row:(NSInteger)row cellView:(NSTableCellView *)cellView{
    
    myOrderModel *model=self.dataArr[row];
    
    NSTextField *trainLab=[cellView viewWithTag:101];

    if (trainLab) {
        
        trainLab.stringValue=[NSString stringWithFormat:@"%@ --> %@ %@",model.stationTrainDTO[@"from_station_name"],model.stationTrainDTO[@"to_station_name"],model.stationTrainDTO[@"station_train_code"]];
    }
    
    NSTextField *timeLab=[cellView viewWithTag:102];

    if (timeLab) {
        
        timeLab.stringValue=[NSString stringWithFormat:@"%@ 开",model.start_train_date_page];
    }
    
    NSTextField *nameLab=[cellView viewWithTag:201];

    if (nameLab) {
        
        nameLab.stringValue=model.passengerDTO[@"passenger_name"];
    }
    
    NSTextField *identityLab=[cellView viewWithTag:202];

    if (identityLab) {
        
        identityLab.stringValue=model.passengerDTO[@"passenger_id_type_name"];
    }
    
    NSTextField *SeatLab=[cellView viewWithTag:301];

    if (SeatLab) {
        
        SeatLab.stringValue=model.seat_type_name;
    }
    
    NSTextField *locationLab=[cellView viewWithTag:302];

    if (locationLab) {
        
        locationLab.stringValue=[NSString stringWithFormat:@"%@车%@",model.coach_name,model.seat_name];
    }
    
    NSTextField *ticketLab=[cellView viewWithTag:401];

    if (ticketLab) {
        
        ticketLab.stringValue=model.ticket_type_name;
    }
      
    NSTextField *priceLab=[cellView viewWithTag:402];

    if (priceLab) {
        
        priceLab.stringValue=[NSString stringWithFormat:@"%@元",model.str_ticket_price_page];
    }
    
    NSTextField *stateLab=[cellView viewWithTag:501];

    if (stateLab) {
        
        stateLab.stringValue=model.ticket_status_name;
    }
}


- (IBAction)selSegment:(NSSegmentedControl *)sender {
    
    if (sender.selectedSegment==0) {
        
        self.tipsLab.hidden=YES;
        
    }else{
        
        self.tipsLab.hidden=NO;

    }
    
    [self.tableScrollView startLoading];
}

-(void)requesQueryMyOrderNoComplete{
    
    __weak typeof(self)weakself=self;
    
    [[orderManageHttpRequestManager shaerd]requesQueryMyOrderNoCompleteWithUrl:queryMyOrderNoCompleteUrl parameters:@{@"_json_att":@""} success:^(NSDictionary * _Nonnull data) {
       
        if (data && data.count>0) {
            
            if ([data[@"data"][@"orderDBList"] firstObject][@"tickets"]) {
                
                NSMutableArray *tickets=[data[@"data"][@"orderDBList"] firstObject][@"tickets"];

                for (NSMutableDictionary *dict in tickets) {
                                   
                    myOrderModel *model=[myOrderModel mj_objectWithKeyValues:dict];
                                                  
                    [weakself.dataArr addObject:model];
                                                  
                }
                            
            }
        }
        
        [weakself.tableView reloadData];

        [weakself.tableScrollView stopLoading];

    } failure:^(NSError * _Nonnull error) {
        
        [weakself.tableScrollView stopLoading];

    }];
}

-(void)QueryMyOrderWithSelIndex:(NSInteger)index{
    
    __weak typeof(self)weakself=self;

    //query_where -> H 历史   -> G 未出行
    
    NSString *queryStartDate=@"";
    
    NSString *queryEndDate=@"";

    NSString *query_where=@"";
    
    if (index==1) {
        
        query_where=@"G";
        
        queryStartDate=[NSString currentDateToBackDateWithDate:[NSString coverTimeStrToDateWithStr:[NSString currentDate]] Day:-30];
       
        queryEndDate=[NSString currentDate];
        
    }else if (index==2){
        
        query_where=@"H";

        queryStartDate=[NSString currentDateToBackDateWithDate:[NSString coverTimeStrToDateWithStr:[NSString currentDate]] Day:-29];
        
        queryEndDate=[NSString currentDateToBackDateWithDate:[NSString coverTimeStrToDateWithStr:[NSString currentDate]] Day:-1];
    }
    
    [[orderManageHttpRequestManager shaerd]requesQueryMyOrderWithUrl:queryMyOrderUrl parameters:@{@"come_from_flag":@"my_order",@"pageIndex":@"0",@"pageSize":@"20",@"query_where":query_where,@"queryStartDate":queryStartDate,@"queryEndDate":queryEndDate,@"queryType":@"1",@"sequeue_train_name":@""} success:^(NSDictionary * _Nonnull data) {
        
        if (data && data.count>0) {

            if ([data[@"data"][@"OrderDTODataList"] firstObject][@"tickets"]) {
                
                NSMutableArray *tickets=[data[@"data"][@"OrderDTODataList"] firstObject][@"tickets"];
                
                for (NSMutableDictionary *dict in tickets) {
                    
                    myOrderModel *model=[myOrderModel mj_objectWithKeyValues:dict];
                                   
                    [weakself.dataArr addObject:model];
                                   
                }
                
            }
        }
        
        [weakself.tableView reloadData];

        [weakself.tableScrollView stopLoading];

    } failure:^(NSError * _Nonnull error) {
       
        [weakself.tableScrollView stopLoading];
    }];
    
}

@end
