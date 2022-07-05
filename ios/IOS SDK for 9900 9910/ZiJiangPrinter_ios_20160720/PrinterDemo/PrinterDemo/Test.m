//
//  UIViewController+Test.m
//  PrinterDemo
//
//  Created by ZJ on 4/13/22.
//

#import "Test.h"
#import "HLPrinter.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "ConnecterManager.h"
#import "EscCommand.h"
#import "TscCommand.h"
#include "Compress.h"

@interface Test () <CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>{
    CBCentralManager *_centralManager;
    CBPeripheral *_connectedPeripheral;
    CBCharacteristic  *_characteristic;
    //NSString *name ;
    NSMutableArray* printerArray;
    UITableView* tableView;
    UIButton *button;
    UIImageView *mimage;
}

@end

@implementation Test : UIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"SelectPrinter", @"SelectPrinter");
//    mimage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 70, 50, 50)];
//    mimage.image = [UIImage imageNamed:@"gprinter.png"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(30, 70, 50, 30)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
   [button.layer setBorderWidth:1.0];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(sendData) forControlEvents:(UIControlEventTouchUpInside)];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:button];
    [self.view addSubview:mimage];
    [self.view addSubview:tableView];
    
    //name = @"BlueTooth Printer";
    if (nil == printerArray)
    {
        printerArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    
}


-(void) sendData{
    Byte byte[] = {0x1B,0x68};//打印机状态指令
       
    HLPrinter *printer = [[HLPrinter alloc] init];
    
//    [printer appendText:@"dsaddsadsadadad\n"];
//
//    [printer appendText:@"的地方递四方速递\n"];
    UIImage *image = [UIImage imageNamed:@"gprinter.png"];
    
    //[printer printWithImage:image width:50.0 height:50.0];
    [self printerImage:image];
    //NSData *data = [printer getData];
       
           NSLog(@"发送获取状态指令");
           //[_connectedPeripheral writeValue:data forCharacteristic: _characteristic type:CBCharacteristicWriteWithResponse];
            
       
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"数据发送成功");
}

-(void)printerImage:(UIImage *)image{
    NSData *imageData = [self imageToThermalData:image];
    
    //NSData *imageData = [self tscCommand];
    
    BYTE *byteData = (BYTE *)[imageData bytes];
    char *charData = [imageData bytes];
   //  NSData *imageData = [self getDataForPrintWith:image];
   // EscCommand *command = [[EscCommand alloc]init];
    //[command addInitializePrinter];
    //[command addPrintAndFeedLines:5];

    //[command addOriginrastBitImage:image];
    //[command addOriginrastBitImage:image width:384];
    char *destData;
   // Compress(charData, charData , destData);

    NSData *lastData = [[NSData alloc] initWithBytes:destData length:10000];
    //NSData *imageData = [command getCommand];
    
     [self printLongData:lastData];
    
    
}


- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


-(NSData *)tscCommand{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:75 :40];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addCls];
    [command addDirection:1];
    UIImage *image = [UIImage imageNamed:@"gprinter.png"];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    //UIImage *resultImage = [UIImage imageWithData:data];
    NSData * data1 = UIImagePNGRepresentation(image);
    NSInteger length = data1.length;
    UIImage *lastImage = [self compressImage:image toByte:length];
    [command addBitmapwithX:0 withY:0 withMode:0 withWidth:600 withImage:lastImage];
    [command addPrint:1 :1];
    return [command getCommand];
}

#pragma mark ********************另一种打印图片的方式****************************
typedef struct ARGBPixel {
    
    u_int8_t             red;
    u_int8_t             green;
    u_int8_t             blue;
    u_int8_t             alpha;
    
} ARGBPixel ;

#pragma mark 获取打印图片数据
-(NSData *)getDataForPrintWith:(UIImage *)image{
    
    CGImageRef cgImage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    
    NSData* bitmapData = [self getBitmapImageDataWith:cgImage];
    
    const char * bytes = bitmapData.bytes;
    
    NSMutableData * data = [[NSMutableData alloc] init];
    
    //横向点数计算需要除以8
    NSInteger w8 = width / 8;
    //如果有余数，点数+1
    NSInteger remain8 = width % 8;
    if (remain8 > 0) {
        w8 = w8 + 1;
    }
    /**
     根据公式计算出 打印指令需要的参数
     指令:十六进制码 1D 76 30 m xL xH yL yH d1...dk
     m为模式，如果是58毫秒打印机，m=1即可
     xL 为宽度/256的余数，由于横向点数计算为像素数/8，因此需要 xL = width/(8*256)
     xH 为宽度/256的整数
     yL 为高度/256的余数
     yH 为高度/256的整数
     **/
    NSInteger xL = w8 % 256;
    NSInteger xH = width / (88 * 256);
    NSInteger yL = height % 256;
    NSInteger yH = height / 256;
    
    Byte cmd[] = {0x1d,0x76,0x30,0,xL,xH,yL,yH};
    
    
    [data appendBytes:cmd length:8];
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < w8; w++) {
            u_int8_t n = 0;
            for (int i=0; i<8; i++) {
                int x = i + w * 8;
                u_int8_t ch;
                if (x < width) {
                    int pindex = h * (int)width + x;
                    ch = bytes[pindex];
                }
                else{
                    ch = 0x00;
                }
                n = n << 1;
                n = n | ch;
            }
            [data appendBytes:&n length:1];
        }
    }
    return data;
}
#pragma mark 获取图片点阵图数据
-(NSData *)getBitmapImageDataWith:(CGImageRef)cgImage{
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    NSInteger psize = sizeof(ARGBPixel);
    
    ARGBPixel * pixels = malloc(width * height * psize);
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    [self ManipulateImagePixelDataWithCGImageRef:cgImage imageData:pixels];
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            
            int pIndex = (w + (h * (u_int32_t)width));
            ARGBPixel pixel = pixels[pIndex];
            
            if ((0.3*pixel.red + 0.59*pixel.green + 0.11*pixel.blue) <= 127) {
                //打印黑
                u_int8_t ch = 0x01;
                [data appendBytes:&ch length:1];
            }
            else{
                //打印白
                u_int8_t ch = 0x00;
                [data appendBytes:&ch length:1];
            }
        }
    }
    
    return data;
}

// 获取像素信息
-(void)ManipulateImagePixelDataWithCGImageRef:(CGImageRef)inImage imageData:(void*)oimageData
{
    // Create the bitmap context
    CGContextRef cgctx = [self CreateARGBBitmapContextWithCGImageRef:inImage];
    if (cgctx == NULL)
    {
        // error creating context
        return;
    }
    
    // Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    void *data = CGBitmapContextGetData(cgctx);
    if (data != NULL)
    {
        CGContextRelease(cgctx);
        memcpy(oimageData, data, w * h * sizeof(u_int8_t) * 4);
        free(data);
        return;
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data)
    {
        free(data);
    }
    
    return;
}






- (void) printLongData:(NSData *)printContent{
    
    NSUInteger i;
    // 打印数据长度
    NSUInteger strLength;
    //打印行数
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    //数据长度
    strLength = [printContent length];
    if (strLength < 1) {
        return;
    }
    int MAX_CHARACTERISTIC_VALUE_SIZE = 120;
    cellCount = (strLength % MAX_CHARACTERISTIC_VALUE_SIZE) ? (strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        NSRange rang = NSMakeRange(cellMin, cellLen);
        //        截取打印数据
        NSData *subData = [printContent subdataWithRange:rang];
        //循环写入数据
        [_connectedPeripheral writeValue:subData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    }
}

// 参考 http://developer.apple.com/library/mac/#qa/qa1509/_index.html
-(CGContextRef)CreateARGBBitmapContextWithCGImageRef:(CGImageRef)inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace =CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}









typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;


- (NSData *) imageToThermalData:(UIImage*)image
{
    
    CGImageRef imageRef = image.CGImage;
     // Create a bitmap context to draw the uiimage into
     CGContextRef context = [self CreateARGBBitmapContextWithCGImageRef:imageRef];
     if(!context) {
         return NULL;
     }
     
     size_t width = CGImageGetWidth(imageRef);
     size_t height = CGImageGetHeight(imageRef);
    
//    size_t width = 384;
//    size_t height = 384;
     
     CGRect rect = CGRectMake(0, 0, width, height);
    
     
     // Draw image into the context to get the raw image data
     CGContextDrawImage(context, rect, imageRef);
     
     // Get a pointer to the data
     uint32_t *bitmapData = (uint32_t *)CGBitmapContextGetData(context);
     
     if(bitmapData) {
         
         uint8_t *m_imageData = (uint8_t *) malloc(width * height/8 + 8*height/8);
         memset(m_imageData, 0, width * height/8 + 8*height/8);
         int result_index = 0;
         
         for(int y = 0; (y + 24) < height;) {
             m_imageData[result_index++] = 27;
             m_imageData[result_index++] = 51;
             m_imageData[result_index++] = 0;
             
             m_imageData[result_index++] = 27;
             m_imageData[result_index++] = 42;
             m_imageData[result_index++] = 33;
             
             m_imageData[result_index++] = width%256;
             m_imageData[result_index++] = width/256;
             for(int x = 0; x < width; x++) {
                 int value = 0;
                 for (int temp_y = 0 ; temp_y < 8; ++temp_y)
                 {
                     uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                     uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                     
                     if (gray < 127)
                     {
                         value += 1<<(7-temp_y)&255;
                     }
                 }
                 m_imageData[result_index++] = value;
                 
                 value = 0;
                 for (int temp_y = 8 ; temp_y < 16; ++temp_y)
                 {
                     uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                     uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                     
                     if (gray < 127)
                     {
                         value += 1<<(7-temp_y%8)&255;
                     }
                     
                 }
                 m_imageData[result_index++] = value;
                 
                 value = 0;
                 for (int temp_y = 16 ; temp_y < 24; ++temp_y)
                 {
                     uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                     uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                     
                     if (gray < 127)
                     {
                         value += 1<<(7-temp_y%8)&255;
                     }
                     
                 }
                 m_imageData[result_index++] = value;
             }
             m_imageData[result_index++] = 13;
             m_imageData[result_index++] = 10;
             y += 24;
         }
         NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
         [data appendBytes:m_imageData length:result_index];
         free(bitmapData);
         return data;
         
     } else {
         NSLog(@"Error getting bitmap pixel data\n");
     }
     
     CGContextRelease(context);
     
     return nil ;
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString * state = nil;
            switch ([central state])
            {
                case CBCentralManagerStateUnsupported:
                    state = @"The platform doesn't support the Bluetooth Low Energy Central/Client role.";
                    break;
                case CBCentralManagerStateUnauthorized:
                    state = @"The application is not authorized to use the Bluetooth Low Energy role.";
                    break;
                case CBCentralManagerStatePoweredOff:
                    state = @"蓝牙关闭状态";
                    break;
                case CBCentralManagerStatePoweredOn:
                    state = @"蓝牙打开状态可用";
                    [central scanForPeripheralsWithServices:nil options:nil];
                    break;
                case CBCentralManagerStateUnknown:
                default:
                ;
            }
            NSLog(@"Central manager state: %@", state);
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral)
       {
           if(peripheral.name!=nil ){
               NSLog(@"扫描到一个设备设备：%@",peripheral.name);
               _centralManager.delegate = self;
               Device *device = [[Device alloc] init];
               device.name = peripheral.name;
               //device.uuid = peripheral.u
               Boolean isContains = [printerArray containsObject:peripheral];
               if(!isContains){
                   [printerArray addObject:peripheral];
                   [tableView reloadData];
               }
               
           }
           //NSLog(@"foundDevice. name[%s],RSSI[%d]\n",peripheral.name.UTF8String,peripheral.RSSI.intValue);
//           [centralManager connectPeripheral:peripheral options:nil];
//
//           centralManager connectPeripheral:peripheral options:<#(nullable NSDictionary<NSString *,id> *)#>
               //发现设备后即可连接该设备 调用完该方法后会调用代理CBCentralManagerDelegate的- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral表示连接上了设别
               //如果不能连接会调用 - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
       }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSString *kServiceUUID = @"00001101-0000-1000-8000-00805F9B34FB";
    NSLog(@"connected periphheral sucess");
    //peripheral discoverServices:<#(nullable NSArray<CBUUID *> *)#>
    _connectedPeripheral = peripheral;
    [_connectedPeripheral setDelegate:self];
    [peripheral discoverServices:nil];
    [_centralManager stopScan];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error{
    NSLog(@"搜服务代理2");
    for (CBService *service in peripheral.services) {
        NSLog(@"discovered service %@",service);
        
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"didDiscoverServices");
    if (error)
    {
    NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
    return;
    }
    //服务并不是我们的目标，也没有实际意义。我们需要用的是服务下的特征，查询（每一个服务下的若干）特征
    for (CBService *service in peripheral.services)
    {
    [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"didDiscoverCharacteristicsForService");
//    for (CBCharacteristic *characteristic in service.characteristics)
//    {
//        NSLog(@"UUID = %@",characteristic.UUID.UUIDString);
//        _connectedPeripheral writeValue:<#(nonnull NSData *)#> forCharacteristic:<#(nonnull CBCharacteristic *)#> type:<#(CBCharacteristicWriteType)#>
//    }
    
    
    if (error==nil) {
          for (CBCharacteristic *characteristic in service.characteristics){
              if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"]]){
                   _characteristic = characteristic;
                  NSLog(@"characteristic = %@",characteristic.UUID.UUIDString);
              }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]){
                   [peripheral setNotifyValue:TRUE forCharacteristic:characteristic];
              }
              _connectedPeripheral = peripheral;
          }
      }
    
    
    
}
   
    



- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //此时连接发生错误
    NSLog(@"connected periphheral failed");
    
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"DisconnectPeripheral");
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
    CBPeripheral* printer = [printerArray objectAtIndex:indexPath.row];

    cell.textLabel.text = printer.name;
    cell.detailTextLabel.text =  printer.identifier.UUIDString;
    
    return cell;
}
//点击条目角标
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral* printer = [printerArray objectAtIndex:indexPath.row];
    
    //[[PrinterSDK defaultPrinterSDK] connectBT:printer];
    
    [_centralManager connectPeripheral:printer options:nil];
    
   // [self.navigationController popViewControllerAnimated:YES];
    
}


    
@end
