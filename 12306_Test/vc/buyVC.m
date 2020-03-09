//
//  buyVC.m
//  12306_Test
//
//  Created by 曹巍 on 2020/3/5.
//  Copyright © 2020 louis. All rights reserved.
//

#import "buyVC.h"

@interface buyVC ()
@property (weak) IBOutlet NSTextField *trainInfoView;
@property (weak) IBOutlet NSTextField *ticketInfoView;
@property(nonatomic,strong)selTrainInfoModel *sltModel;
@property (weak) IBOutlet NSScrollView *scorView;
@property(nonatomic,strong)NSButton *passengersBtn;
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
    [self requestInfo];
    
    [self CreatePassengersViewWithArr:@[@"1"]];
}

-(void)CreatePassengersViewWithArr:(NSMutableArray *)arr{
    
    NSView *scroContenView=[[NSView alloc]initWithFrame:CGRectMake(0, 0, (15+60)*arr.count, 50)];
    
    for (int i=0; i<arr.count; i++) {
        
        self.passengersBtn=[[NSButton alloc]initWithFrame:CGRectMake((15+60)*i, 0, 60, 40)];
        
        [self.passengersBtn setButtonType:NSButtonTypeSwitch];
        
        self.passengersBtn.title=[NSString stringWithFormat:@"%d",i];
        
        [self.passengersBtn setAction:@selector(click:)];
        
        [scroContenView addSubview:self.passengersBtn];
        
    }
           
    self.scorView.documentView=scroContenView;
    
}

-(void)click:(NSButton *)btn{
    
    
}

- (IBAction)backAction:(NSButton *)sender {
    
    [self dismissViewController:self];
}

- (IBAction)submitOrder:(NSButton *)sender {
    
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
            
            [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

        }
        
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
            
        }else{
            
            NSLog(@"获取乘车人信息失败q,请稍后重试");

        }
        
        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
    
        NSLog(@"获取乘车人信息失败q,请稍后重试");

        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];

    }];
}


@end
