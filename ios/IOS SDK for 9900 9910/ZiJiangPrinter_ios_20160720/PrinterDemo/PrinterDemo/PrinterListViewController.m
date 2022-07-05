//
//  PrinterListViewController.m
//  ZiJiangPrinterDemo
//
//  Created by aduo on 6/3/16.
//
//

#import "PrinterListViewController.h"
#import "PrinterSDK.h"


@interface PrinterListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *devices;
@property(nonatomic,strong)NSMutableDictionary *dicts;
@property (strong, nonatomic) IBOutlet UITableView *deviceList;


@end

@implementation PrinterListViewController


-(NSMutableArray *)devices {
    if (!_devices) {
        _devices = [[NSMutableArray alloc]init];
    }
    return _devices;
}

-(NSMutableDictionary *)dicts {
    if (!_dicts) {
        _dicts = [[NSMutableDictionary alloc]init];
    }
    return _dicts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"SelectPrinter", @"SelectPrinter");
}

- (void)viewDidAppear:(BOOL)animated
{
    if (Manager.bleConnecter == nil) {
        [Manager didUpdateState:^(NSInteger state) {
            switch (state) {
                case CBCentralManagerStateUnsupported:
                    NSLog(@"The platform/hardware doesn't support Bluetooth Low Energy.");
                    break;
                case CBCentralManagerStateUnauthorized:
                    NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
                    break;
                case CBCentralManagerStatePoweredOff:
                    NSLog(@"Bluetooth is currently powered off.");
                    break;
                case CBCentralManagerStatePoweredOn:
                    [self startScane];
                    NSLog(@"Bluetooth power on");
                    break;
                case CBCentralManagerStateUnknown:
                default:
                    break;
            }
        }];
    } else {
        [self startScane];
    }
}


-(void)startScane {
    [Manager scanForPeripheralsWithServices:nil options:nil discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
        if (peripheral.name != nil) {
            NSLog(@"name -> %@",peripheral.name);
            NSUInteger oldCounts = [self.dicts count];
            [self.dicts setObject:peripheral forKey:peripheral.identifier.UUIDString];
            if (oldCounts < [self.dicts count]) {
                [_deviceList reloadData];
            }
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [Manager stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - table delegate and data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dicts allKeys]count];
}

/***********************************************************************
 * 方法名称： cellForRowAtIndexPath
 * 功能描述： 获取cell视图
 * 输入参数： indexPath  位置信息
 * 输出参数：
 * 返回值：   cell  视图
 ***********************************************************************/
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CtrlViewController *ctrlViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CtrlViewController"];
//    [self.navigationController pushViewController:ctrlViewController animated:YES];
    [self connectDevice:peripheral];
}

-(void)connectDevice:(CBPeripheral *)peripheral {
    [Manager connectPeripheral:peripheral options:nil timeout:2 connectBlack:self.state];
}

@end
