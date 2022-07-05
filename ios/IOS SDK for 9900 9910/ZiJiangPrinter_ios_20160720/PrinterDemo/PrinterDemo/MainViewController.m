//
//  UIViewController+MainViewController.m
//  PrinterDemo
//
//  Created by ZJ on 4/12/22.
//

#import "MainViewController.h"
#import "PrinterSDK.h"
#import "PrinterListViewController.h"

#import "DeviceListController.h"
#import <QuartzCore/QuartzCore.h>
#import "EscCommand.h"
#import "TscCommand.h"
@interface MainViewController() <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    UIButton* _connectButton; //是否连接按钮（connect,disconnect）
   
    UIButton* _fontSizeButton;
    UIButton* _connectSetButton; //设置连接类型按钮
   
    
    NSInteger _fontSize;
    
    UIImagePickerController* _imagePicker;
    NSArray *array1;
    
    UITextView* _textView; //输入框
    
    UIButton *printText; //打印文本
   
    UIButton *PrintBitmap;//图形方式打印
    
    UIButton *PrintOneCode;//打印一维码
    UIButton *PrintQR;//打印二维码
   
    
}

@end

@implementation MainViewController:UIViewController

//切换连接模式
//-(void) changeIndex{
//    [[PrinterSDK defaultPrinterSDK] disconnect];
//    NSInteger index = _modeSegementedControl.selectedSegmentIndex;
//    NSLog(@"%ld",index);
//    if (0 == _modeSegementedControl.selectedSegmentIndex)
//    {
//        [_connectSetButton setTitle:NSLocalizedString(@"SelectPrinter", @"SelectPrinter") forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_connectSetButton setTitle:NSLocalizedString(@"ConnectIP", @"ConnectIP") forState:UIControlStateNormal];
//    }
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePrinterConnectedNotification:) name:PrinterConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePrinterDisconnectedNotification:) name:PrinterDisconnectedNotification object:nil];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePrinterConnectedNotification:) name:PrinterConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePrinterDisconnectedNotification:) name:PrinterDisconnectedNotification object:nil];


//    array1= [[NSArray alloc] initWithObjects:NSLocalizedString(@"Bluetooth", nil), @"Wifi",nil];
//    _modeSegementedControl = [[UISegmentedControl alloc] initWithItems:array1];
    //_modeSegementedControl.delegate = self;

    //设置frame
    //_modeSegementedControl.frame = CGRectMake(100, 80, self.view.frame.size.width/2, 30);
    //_modeSegementedControl.selectedSegmentIndex = 0;
    
    //切换事件
    //[_modeSegementedControl addTarget:self action:@selector(changeIndex) forControlEvents:(UIControlEventValueChanged)];

    //添加到视图
    //[self.view addSubview:_modeSegementedControl];


    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;

    
    //动态创建自己的按钮
    //1.创建按钮（UIButton）
       
    _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //_printWidthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _connectSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //创建文本输入框
    _textView = [[UITextView alloc] init];
    
    
    //创建按钮（打印数据）
    
    printText = [UIButton buttonWithType:UIButtonTypeSystem];
    
    
    PrintBitmap = [UIButton buttonWithType:UIButtonTypeSystem];
    
    PrintOneCode = [UIButton buttonWithType:UIButtonTypeSystem];
    PrintQR = [UIButton buttonWithType:UIButtonTypeSystem];
   
    
    
    
    //2.给按钮设置文字,大小
    [_connectButton setTitle:NSLocalizedString(@"NotConnected", @"NotConnected") forState:UIControlStateNormal];
    _connectButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
//    [_printWidthButton setTitle:@"58mm" forState:UIControlStateNormal];
//    _printWidthButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [_connectSetButton setTitle:NSLocalizedString(@"SelectPrinter", @"SelectPrinter") forState:UIControlStateNormal];
    
   
    _connectSetButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    
    
    //    UIButton *PrintBitmap;//图形方式打印
    //    UIButton *PrintFontSize;//字体放大倍数
    //    UIButton *PrintOneCode;//打印一维码
    //    UIButton *PrintQR;//打印二维码
    //    UIButton *PrintCashBox;//开钱箱
    //    UIButton *PrintCutter;//切刀
    //    UIButton *PrintSelfTest;//自检页
    //    UIButton *PrintBeep;//蜂鸣
    //    UIButton *PrintTest;//打印测试页
    //    UIButton *PrintPic;//打印图片
    
    [printText setTitle:NSLocalizedString(@"PrintText", @"PrintText") forState:UIControlStateNormal];
    printText.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
   
    
    [PrintBitmap setTitle:NSLocalizedString(@"PrintBitmap", @"PrintBitmap") forState:UIControlStateNormal];
    PrintBitmap.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
   
    
    [PrintOneCode setTitle:NSLocalizedString(@"PrintOneCode", @"PrintOneCode") forState:UIControlStateNormal];
    PrintOneCode.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [PrintQR setTitle:NSLocalizedString(@"PrintQR", @"PrintQR") forState:UIControlStateNormal];
    PrintQR.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
   
   
    
    
    //3.设置高亮状态下的显示文字和颜色
        
    [_connectButton setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
    [_connectButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
//    [_printWidthButton setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
//    [_printWidthButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
    [_connectSetButton setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
    [_connectSetButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
    
    [printText.layer setMasksToBounds:YES];
    //[printText.layer setCornerRadius:10.0];
    [printText.layer setBorderWidth:1.0];
    printText.backgroundColor = [UIColor clearColor];
    
 
    
    [PrintBitmap.layer setMasksToBounds:YES];
   [PrintBitmap.layer setBorderWidth:1.0];
    PrintBitmap.backgroundColor = [UIColor clearColor];
    
 
    
    [PrintOneCode.layer setMasksToBounds:YES];
   [PrintOneCode.layer setBorderWidth:1.0];
    PrintOneCode.backgroundColor = [UIColor clearColor];
    
    [PrintQR.layer setMasksToBounds:YES];
   [PrintQR.layer setBorderWidth:1.0];
    PrintQR.backgroundColor = [UIColor clearColor];
    
   
  
        
    //4.设置view的frame
    
    _connectButton.frame = CGRectMake(30, 120,(self.view.frame.size.width-60)/3, 30);
   // _printWidthButton.frame = CGRectMake(30+(self.view.frame.size.width-60)/3, 120,(self.view.frame.size.width-60)/3, 30);
    _connectSetButton.frame = CGRectMake(30+(self.view.frame.size.width-60)*2/3, 120,(self.view.frame.size.width-60)/3, 30);
    
    
    
    //_textView位置
    
    _textView.frame = CGRectMake(15, 160, [UIScreen mainScreen].bounds.size.width  - 30, 200);
   
    //背景
    _textView.layer.borderWidth =1.0;

    _textView.layer.cornerRadius =5.0;
    _textView.font = [UIFont systemFontOfSize:16.0];
    
    
    //发送数据按钮
    
    printText.frame = CGRectMake(30, 380,(self.view.frame.size.width-70), 30);
    
    
    PrintBitmap.frame = CGRectMake(30,420,(self.view.frame.size.width-70), 30);
    
    
    PrintOneCode.frame = CGRectMake(30,460,(self.view.frame.size.width-70), 30);
    PrintQR.frame = CGRectMake(30, 500,(self.view.frame.size.width-70), 30);
    
    
    
 
    
   
   
    
    //5.设置按钮点击事件
    [_connectSetButton addTarget:self action:@selector(connectSetButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_connectButton addTarget:self action:@selector(disconnectButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    //[_printWidthButton addTarget:self action:@selector(printWidthButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    [printText addTarget:self action:@selector(printText) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    [PrintBitmap addTarget:self action:@selector(PrintBitmap) forControlEvents:(UIControlEventTouchUpInside)];
    
   
    
    [PrintOneCode addTarget:self action:@selector(PrintOneCode) forControlEvents:(UIControlEventTouchUpInside)];
    
    [PrintQR addTarget:self action:@selector(PrintQR) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    
    
    
    
    
        
    //把动态创建的按钮加到控制器所管理的那个view中
    [self.view addSubview:_connectButton];
    //[self.view addSubview:_printWidthButton];
    [self.view addSubview:_connectSetButton];
    
    [self.view addSubview:_textView];
    
    [self.view addSubview:printText];
    
    [self.view addSubview:PrintBitmap];
    
    [self.view addSubview:PrintOneCode];
    [self.view addSubview:PrintQR];

    
    [PrinterSDK defaultPrinterSDK];
}

//打印文本
-(void) printText{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:80 :40];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addCls];
    [command addDirection:1];
    [command addTextwithX:50 withY:50 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:_textView.text];
    [command addPrint:1 :1];
    NSData *data =  [command getCommand];
    [[PrinterSDK defaultPrinterSDK] writeData:data];
    
    
}

//图形方式打印
-(void) PrintBitmap{
    
    UIImage *image = [UIImage imageNamed:@"gprinter.png"];
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:80 :40];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addCls];
    [command addDirection:1];
    
    [command addBitmapwithX:100 withY:100 withMode:0 withWidth:200 withImage:image];
    [command addTextwithX:10 withY:10 withFont:@"4" withRotation:0 withXscal:1 withYscal:1 withText:_textView.text];
    [command addPrint:1 :1];
    NSData *data =  [command getCommand];
    [[PrinterSDK defaultPrinterSDK] writeData:data];

}


//打印一维码
-(void) PrintOneCode{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:80 :40];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addCls];
    [command addDirection:1];
    
    [command add1DBarcode:50 :50 :@"128" :80 :0 :0 :2 :4 :@"12345678"];
    [command addPrint:1 :1];
    NSData *data =  [command getCommand];
    
    [[PrinterSDK defaultPrinterSDK] writeData:data];
}

//打印二维码
-(void) PrintQR{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:80 :40];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addCls];
    [command addDirection:1];
    
    [command addQRCode:50 :50 :@"L" :8 :@"A" :0 :@"12345678"];
    [command addPrint:1 :1];
    NSData *data =  [command getCommand];
    
    [[PrinterSDK defaultPrinterSDK] writeData:data];
   
}







//断开连接
-(void) disconnectButtonClicked{
    NSLog(@"disconnectButtonClicked");
    
    [[PrinterSDK defaultPrinterSDK] disconnect];
    
    
    _connectButton.userInteractionEnabled = NO;
    
    NSLog(@"NotConnected");
    [_connectButton setTitle:NSLocalizedString(@"NotConnected", @"NotConnected") forState:UIControlStateNormal];
    
    
}



//设置打印类型（蓝牙，wifi）
-(void) connectSetButtonClicked{

    NSLog(@"connectSetButtonClicked");

    
   
        self.navigationController.navigationBarHidden = NO;

        DeviceListController* viewController = [[DeviceListController alloc] init];

        [self.navigationController pushViewController:viewController animated:YES];

    
   

}

//蓝牙连接成功监听
- (void)handlePrinterConnectedNotification:(NSNotification*)notification
{
    //if (!_connectButton.userInteractionEnabled)
    //{
        double delayInSeconds = 1.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            //[[ZXPrinterSDK defaultZXPrinterSDK] printTestPaper];
        });
    //}
    NSLog(@"Connected");
    _connectButton.userInteractionEnabled = YES;
    [_connectButton setTitle:NSLocalizedString(@"Connected", @"Connected") forState:UIControlStateNormal];
}

//蓝牙断开监听
- (void)handlePrinterDisconnectedNotification:(NSNotification*)notification
{
    
    _connectButton.userInteractionEnabled = NO;
    
    NSLog(@"NotConnected");
    [_connectButton setTitle:NSLocalizedString(@"NotConnected", @"NotConnected") forState:UIControlStateNormal];
    
    
}








#pragma mark - UIActionSheetDelegate
//图片获取回调
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[PrinterSDK defaultPrinterSDK] printImage:image];
    
}


#pragma mark - UIAlertViewDelegate
//ip获取回调
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [[PrinterSDK defaultPrinterSDK] connectIP:[alertView textFieldAtIndex:0].text];
    }
}

@end
