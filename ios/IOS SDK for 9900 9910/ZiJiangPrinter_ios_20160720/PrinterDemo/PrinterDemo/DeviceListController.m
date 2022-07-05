//
//  UIViewController+DeviceListController.m
//  PrinterDemo
//
//  Created by ZJ on 4/14/22.
//

#import "DeviceListController.h"
#import "PrinterSDK.h"


@interface DeviceListController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray* printerArray;

}



@end

@implementation DeviceListController

- (instancetype)init{
    self = [super init];
    //printerArray = @[].mutableCopy;
    if(self) {
//        for (int i=0; i<20; i++) {
//            [_dataArray addObject:@(i)];
//        }
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
   
    self.view.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    
    [[PrinterSDK defaultPrinterSDK] scanPrintersWithCompletion:^(Printer* printer)
    {
        if (nil == printerArray)
        {
            printerArray = [[NSMutableArray alloc] initWithCapacity:1];
        }
       
            [printerArray addObject:printer];
        
      
        
        [tableView reloadData];
    }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[PrinterSDK defaultPrinterSDK] stopScanPrinters];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//返回列表数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return printerArray.count;
}
//返回每个条目对象
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    Printer* printer = [printerArray objectAtIndex:indexPath.row];

    cell.textLabel.text = printer.name;
    cell.detailTextLabel.text =  printer.UUIDString;

    return cell;
}
//点击条目角标
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Printer* printer = [printerArray objectAtIndex:indexPath.row];
    [[PrinterSDK defaultPrinterSDK] connectBT:printer];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
