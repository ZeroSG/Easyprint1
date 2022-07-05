//
//  ZJPrinterSDK.m
//  ZiJiangPrinterLibrary
//
//  Created by aduo on 5/30/16.
//
//

#import "ZXPrinterSDK.h"
#import "ZXPrinterManager.h"
#import "ImageHelper.h"
#import "GCDAsyncSocket.h"


NSString* ZXPrinterConnectedNotification = @"ZXPrinterConnectedNotification";
NSString* ZXPrinterDisconnectedNotification = @"ZXPrinterDisconnectedNotification";


@interface ZXPrinter ()

@property (nonatomic, strong) LGPeripheral* peripheral;

@end

@implementation ZXPrinter

- (NSString*)name
{
    return self.peripheral.name;
}

- (NSString*)UUIDString
{
    return self.peripheral.UUIDString;
}

@end

@interface ZXPrinterSDK ()
{
//    BOOL _isPoweredOn;
//    BOOL _isConnecting;
//    BOOL _isConnected;
    
//    GCDAsyncSocket* _socket;
    
    NSInteger _printWidth;
}
@property (nonatomic, strong)GCDAsyncSocket *socket;
@property (nonatomic, copy) ZXPrinterScanPrintersCallback scanBlock;
@property (nonatomic, copy) sendImageBlock sendBlock;
@end

@implementation ZXPrinterSDK

static ZXPrinterSDK* _sharedInstance;

+ (ZXPrinterSDK*)defaultZXPrinterSDK
{
    @synchronized(self)
    {
        if (nil == _sharedInstance)
        {
            _sharedInstance = [[ZXPrinterSDK alloc] init];
        }
    }
    
	return _sharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCBCentralManagerStatePoweredOn object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCBCentralManagerStatePoweredOff object:nil];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleToothBluePoweredOnNotification:) name:kCBCentralManagerStatePoweredOn object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleToothBluePoweredOffNotification:) name:kCBCentralManagerStatePoweredOff object:nil];
        
        [LGCentralManager sharedInstance];
        
        _printWidth = 384;
    }
    
    return self;
}

- (void)scanPrintersWithCompletion:(ZXPrinterScanPrintersCallback)callback
{
    self.scanBlock = callback;
    
    [[ZXPrinterManager sharedInstance] scanPedometersWithCompletion:^(LGPeripheral* peripheral)
    {
        if (self.scanBlock)
        {
            ZXPrinter* printer = [[ZXPrinter alloc] init];
            printer.peripheral = peripheral;
            
            self.scanBlock(printer);
        }
    }];
}

- (void)stopScanPrinters
{
    [[ZXPrinterManager sharedInstance] stopScanPedometers];
}

- (BOOL)connectIP:(NSString*)ipAddress
{
    if (nil != _socket)
    {
        _socket = nil;
    }
    
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    [_socket disconnect];
    
    NSError* error = nil;
    if (![_socket connectToHost:ipAddress onPort:9100 error:&error])
    {
        NSLog(@"Unable to connect to %@:%d, %@", ipAddress, 9100, error);
        
        return NO;
    }
    
    return YES;
}

- (void)connectBT:(ZXPrinter*)printer
{
    [[ZXPrinterManager sharedInstance] connectToPeripheral:printer.peripheral completion:^(LGPeripheral* peripheral)
    {
        _isConnecting = NO;
        _isConnected = YES;
    }];
}

- (void)disconnect
{
    if (nil != [ZXPrinterManager sharedInstance].connectedPeripheral)
    {
        [[ZXPrinterManager sharedInstance] disconnectToPeripheral:[ZXPrinterManager sharedInstance].connectedPeripheral completion:^(LGPeripheral* peripheral)
        {
            [[ZXPrinterManager sharedInstance] stopScanPedometers];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterDisconnectedNotification object:nil];
        }];
    }
    
    if (nil != _socket)
    {
        [_socket disconnect];
        _socket = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterDisconnectedNotification object:nil];
    }
}

- (void)setPrintWidth:(NSInteger)width
{
    _printWidth = width;
}

- (void)printText:(NSString*)text
{

////    NSLog(@"text = %@",text);
//    while (text.length > 180)//20   180
//    {
//        NSString* strPrint = [text substringToIndex:180];
//        [self writeData:[strPrint dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000 | kCFStringEncodingDOSLatin1)]];
//
//        text = [text substringFromIndex:180];
//    }
//
//    if (text.length > 0)
//    {
//        [self writeData:[text dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000 | kCFStringEncodingDOSLatin1)]];
//    }
////
////    Byte line[1] = { 0x0A };
////    [self writeData:[NSData dataWithBytes:line length:1]];
////
////    Byte skip[3] = { 0x1B, 0x4A, 0x28 };
////    [self writeData:[NSData dataWithBytes:skip length:3]];
    
    
    while (text.length > 20)
    {
        NSString* strPrint = [text substringToIndex:20];
        [self writeData:[strPrint dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsLatin1)]];

        text = [text substringFromIndex:20];
    }

    if (text.length > 0)
    {
        [self writeData:[text dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsLatin1)]];
    }
}

- (void)printTextImage:(NSString*)text
{
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _printWidth/2, 10000.0f)];
    [textView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    textView.text = text;
    [self printImage:[self snapshot:textView] completion:^(int sendSize, int totalSize) {
        
    }];
}

- (void)sendHex:(NSString*)hex
{
    NSString* strHex = [hex stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData* data = [[NSMutableData alloc] init];
    
    unsigned char wholeByte;
    char byteChars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([strHex length] / 2); i++)
    {
        byteChars[0] = [strHex characterAtIndex:i*2];
        byteChars[1] = [strHex characterAtIndex:i*2+1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    Byte* buf = malloc(data.length);
    memset(buf, 0, data.length);
    [data getBytes:buf length:data.length];
    
    NSInteger index = 0;
    while (data.length - index > 20)
    {
        [self writeData:[NSData dataWithBytes:buf+index length:20]];
        index += 20;
    }
    
    if (data.length - index > 0)
    {
        [self writeData:[NSData dataWithBytes:buf+index length:data.length - index]];
    }
    
    free(buf);
}



- (void)printQrCode:(NSString*)text
{
    NSData* textData = [text dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];

    Byte* data = malloc(textData.length+7);
    memset(data, 0, textData.length+7);
    
    data[0] = 0x1B;
    data[1] = 0x5A;
    data[2] = 0x00;
    data[3] = 0x01;
    data[4] = 0x08;
    data[5] = textData.length & 0xff;
    data[6] = textData.length >> 8 & 0xff;
    
    for (NSInteger i = 0; i < textData.length; i++)
    {
        data[7+i] = ((Byte*)textData.bytes)[i];
    }
    
    [self writeData:[NSData dataWithBytes:data length:textData.length+7]];
    
    free(data);
    
    Byte line[1] = { 0x0A };
    [self writeData:[NSData dataWithBytes:line length:1]];
    
    Byte skip[3] = { 0x1B, 0x4A, 0x28 };
    [self writeData:[NSData dataWithBytes:skip length:3]];
}

- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

- (NSInteger)getValue:(NSInteger)value {
    //200SDK拿到手的默认值  178  150。 测试的使用值110
    if (value > 178)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

- (void)cutPaper
{
    Byte data[4] = { 0x1D, 0x56, 0x42, 0x5A };
    [self writeData:[NSData dataWithBytes:data length:4]];
}

- (void)beep
{
    Byte data[4] = { 0x1B, 0x42, 0x03, 0x03 };
    [self writeData:[NSData dataWithBytes:data length:4]];
}

- (void)openCasher
{
    Byte data[5] = { 0x1B, 0x70, 0x00, 0x40, 0x50 };
    [self writeData:[NSData dataWithBytes:data length:5]];
}

- (void)setFontSizeMultiple:(NSInteger)multiple
{
    Byte data[3] = { 0x1D, 0x21, 0x00 };
    switch (multiple)
    {
        case 0:
            data[2] = 0x00;
            break;
            
        case 1:
            data[2] = 0x11;
            break;
            
        case 2:
            data[2] = 0x22;
            break;
            
        case 3:
            data[2] = 0x33;
            break;
            
        default:
            break;
    }
    
    [self writeData:[NSData dataWithBytes:data length:3]];
}

- (void)printTestPaper
{
    Byte mode[3] = { 0x1B, 0x21, 0x00 };
    mode[2] |= 0x10;
    [self writeData:[NSData dataWithBytes:mode length:3]];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    NSString* currentLang = [languages objectAtIndex:0];
    if (NSOrderedSame == [currentLang compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch])
    {
        [self writeData:[@"恭喜您！\n\n" dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    }
    else
    {
        [self writeData:[@"Congratulations!\n\n" dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    }
    
    mode[2] &= 0xEF;
    [self writeData:[NSData dataWithBytes:mode length:3]];
    
    [NSThread sleepForTimeInterval:0.05f];
    
    if (NSOrderedSame == [currentLang compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch])
    {
        [self writeData:[@"  您已经成功的连接上了我们的打印机！\n\n  我们公司是一家专业从事研发，生产，销售商用票据打印机和条码扫描设备于一体的高科技企业." dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    }
    else
    {
        [self writeData:[@"  You have sucessfully created communications between your device and our bluetooth printer.\n\n" dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
        [self writeData:[@"  the company is a high-tech enterprise which specializes in R&D,manufacturing,marketing of thermal printers and barcode scanners." dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    }
    
    Byte line[1] = { 0x0A };
    [self writeData:[NSData dataWithBytes:line length:1]];
    
    Byte skip[3] = { 0x1B, 0x4A, 0x28 };
    [self writeData:[NSData dataWithBytes:skip length:3]];
}

- (void)selfTest
{
    Byte data[3] = { 0x1F, 0x11, 0x04 };
    [self writeData:[NSData dataWithBytes:data length:3]];
}

- (void)writeData:(NSData*)data
{
    if (nil != _socket)
    {
        [_socket writeData:data withTimeout:-1 tag:0];
    }
    else
    {
        [[ZXPrinterManager sharedInstance] writeData:data];
    }
}

- (void)writeWifiEndData:(NSData*)data
{
    if (nil != _socket)
    {
        [_socket writeData:data withTimeout:-1 tag:100];
    }
}

- (void)handleToothBluePoweredOnNotification:(NSNotification*)notification
{
    _isPoweredOn = YES;
    
    if (nil != [ZXPrinterManager sharedInstance].connectedPeripheral)
    {
        [[ZXPrinterManager sharedInstance] connectToPeripheral:[ZXPrinterManager sharedInstance].connectedPeripheral completion:^(LGPeripheral* peripheral)
        {
            _isConnecting = NO;
            _isConnected = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterConnectedNotification object:nil];
        }];
    }
}

- (void)handleToothBluePoweredOffNotification:(NSNotification*)notification
{
    _isPoweredOn = NO;
    _isConnected = NO;
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port
{
    NSLog(@"Success to connect tcp to %@:%d", host, port);
    
    _isConnected = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterConnectedNotification object:nil];
}

- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Success to send TCP data");
    if (tag == 100) {
        if (self.sendBlock) {
            self.sendBlock(0,0);
        }
    }
}

- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag
{
    NSLog(@"TCP data received");
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err
{
    NSLog(@"TCP disconnected");
    
    _isConnected = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterDisconnectedNotification object:nil];
}

- (UIImage*)snapshot:(UITextView*)textView
{
    static CGFloat maxHeight = MAXFLOAT;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    size.width = frame.size.width;
    
    if (nil != UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    [textView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)printImage:(UIImage*)image completion:(sendImageBlock)callback
{
    //换行并清除掉之前的缓存
    Byte nine[1] = { 0x0A };
    [self writeData:[NSData dataWithBytes:nine length:1]];
    
    self.sendBlock = callback;
    UIImage* tempImage = [ImageHelper resizeImageWithNewSize:CGSizeMake(_printWidth, image.size.height*_printWidth/image.size.width) image:image];//调整图像大小
    
    CGImageRef imageref = [tempImage CGImage];//像素位图
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();////颜色空间，比如rgb CMYK Gray
    NSInteger width = CGImageGetWidth(imageref);// 位图的宽度 单位为像素
    NSInteger height = CGImageGetHeight(imageref);// 位图的高度 单位为像素
    NSInteger bytesPerPixel = 4;////每一个像素占用的bits，15 位24位 32位等等
    NSInteger bytesPerRow = bytesPerPixel * width;////位图每一行占用多少bytes（字节数） 注意是bytes不是bits，一个像素一个byte。 （1byte ＝ 8bit？？？？？）
    NSInteger bitsPerComponent = 8;//位图每个颜色的bits  内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
    NSInteger intPointValue = 0;
    NSInteger s = 0;
    //创建要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
    unsigned char* imagedata = malloc(width * height * bytesPerPixel);
    //创建byte数组内存的地址
    Byte* printdata = malloc(width / 8 * height);
    //创建绘制图片的上下文
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata, width, height, bitsPerComponent, bytesPerRow, colorspace, kCGImageAlphaPremultipliedFirst);
    //创建绘制图片的rect
    CGRect therect = CGRectMake(0, 0, width, height);
    //根据上下文绘制图片
    CGContextDrawImage(cgcnt, therect, imageref);
    //创建byte数组内存的地址
    Byte* bitbuf = malloc(width / 8);
    
    NSInteger intPix = 0;
    //1个像素8位 一个8位的像素点可以有2的8次方种颜色，也就是256色，32位像素是65536种颜色
    NSInteger p0 = 0, p1 = 0, p2 = 0, p3 = 0, p4 = 0, p5 = 0, p6 = 0, p7 = 0;
    // 循环位图的高度
    for (NSInteger i = 0; i < height; i++)
    {// 循环位图的宽度 1个像素8位 一个8位的像素点可以有2的8次方种颜色，也就是256色，32位像素是65536种颜色
        for (NSInteger k = 0; k < width / 8 ; k++)
        {
            intPix = i * width * 4 + k * 8 * 4 + 1;
            intPointValue = imagedata[intPix];// 返回指定坐标的颜色
            p0 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p1 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p2 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p3 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p4 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p5 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p6 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p7 = [self getValue:intPointValue];
            
            NSInteger value = p0 * 128 + p1 * 64 + p2 * 32 + p3 * 16 + p4 * 8 + p5 * 4 + p6 * 2 + p7;
            bitbuf[k] = (Byte)value;
        }
        
        for (NSInteger t = 0; t < width / 8; t++)
        {
            printdata[s] = bitbuf[t];
            s += 1;
        }
    }
    //创建byte数组内存的地址
    Byte* pData = malloc((width / 8)*2 + 8);
    
    NSInteger index = 0;
    // 循环位图的高度
    for (NSInteger i = 0; i < height; i+=2)
    {
        NSInteger s = 0;
        // 打印光栅位图的指令
        pData[s++] = 0x1D;// 十六进制0x1D  十进制29
        pData[s++] = 0x76;
        pData[s++] = 0x30;
        pData[s++] = 0x00;// 位图模式 0,1,2,3
        pData[s++] = (Byte)(width / 8);// 表示水平方向位图字节数（xL+xH × 256）
        pData[s++] = 0x00;// 表示垂直方向位图点数（ yL+ yH × 256）
        pData[s++] = 0x02;
        pData[s++] = 0x00;
        
        for (int n = 0; n < 2; n ++) {
            // 循环位图的宽度 1个像素8位 一个8位的像素点可以有2的8次方种颜色，也就是256色，32位像素是65536种颜色
            for (NSInteger j = 0 ; j < width / 8; j++)
            {
                pData[s++] = printdata[index++];
            }
        }
        
        [self writeData:[NSData dataWithBytes:pData length:(width / 8)*2 + 8]];
    }

    free(imagedata);
    free(printdata);
    free(bitbuf);
    free(pData);
    
    Byte line[1] = { 0x0A };
    //    [self writeData:[NSData dataWithBytes:line length:1]];
    
    if (nil != _socket)
    {
        [self writeWifiEndData:[NSData dataWithBytes:line length:1]];
    }
    else
    {
        [[ZXPrinterManager sharedInstance] writeData:[NSData dataWithBytes:line length:1] sendNum:1 completion:^(int sendSize, int totalSize) {
            if (self.sendBlock) {
                self.sendBlock(sendSize,totalSize);
            }
        }];
    }
}



- (void)addPrint:(int)m :(int)n {
    NSString *str = [NSString stringWithFormat:@"PRINT %d,%d\n",m,n];
    [self printText:str];
}

- (void)printImageTspl:(UIImage *)image :(int)labelWidth :(int)labelHeight {
    _printWidth = 8*labelWidth;
    //self.sendBlock = callback;
//    UIImage* tempImage = [ImageHelper resizeImageWithNewSize:CGSizeMake(_printWidth, image.size.height*_printWidth/image.size.width) image:image];//调整图像大小
    UIImage* tempImage = image;
    
    CGImageRef imageref = [tempImage CGImage];//像素位图
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();////颜色空间，比如rgb CMYK Gray
    NSInteger width = CGImageGetWidth(imageref);// 位图的宽度 单位为像素
    NSInteger height = CGImageGetHeight(imageref);// 位图的高度 单位为像素
    NSInteger bytesPerPixel = 4;////每一个像素占用的bits，15 位24位 32位等等
    NSInteger bytesPerRow = bytesPerPixel * width;////位图每一行占用多少bytes（字节数） 注意是bytes不是bits，一个像素一个byte。 （1byte ＝ 8bit？？？？？）
    NSInteger bitsPerComponent = 8;//位图每个颜色的bits  内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
    NSInteger intPointValue = 0;
    NSInteger s = 0;
    //创建要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
    unsigned char* imagedata = malloc(width * height * bytesPerPixel);
    //创建byte数组内存的地址
    Byte* printdata = malloc(width / 8 * height);
    //创建绘制图片的上下文
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata, width, height, bitsPerComponent, bytesPerRow, colorspace, kCGImageAlphaPremultipliedFirst);
    //创建绘制图片的rect
    CGRect therect = CGRectMake(0, 0, width, height);
    //根据上下文绘制图片
    CGContextDrawImage(cgcnt, therect, imageref);
    //创建byte数组内存的地址
    Byte* bitbuf = malloc(width / 8);
    
    NSInteger intPix = 0;
    //1个像素8位 一个8位的像素点可以有2的8次方种颜色，也就是256色，32位像素是65536种颜色
    NSInteger p0 = 0, p1 = 0, p2 = 0, p3 = 0, p4 = 0, p5 = 0, p6 = 0, p7 = 0;
    // 循环位图的高度
    for (NSInteger i = 0; i < height; i++)
    {// 循环位图的宽度 1个像素8位 一个8位的像素点可以有2的8次方种颜色，也就是256色，32位像素是65536种颜色
        for (NSInteger k = 0; k < width / 8 ; k++)
        {
            intPix = i * width * 4 + k * 8 * 4 + 1;
            intPointValue = imagedata[intPix];// 返回指定坐标的颜色
            p0 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p1 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p2 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p3 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p4 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p5 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p6 = [self getValue:intPointValue];
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            p7 = [self getValue:intPointValue];
            
            NSInteger value = p0 * 128 + p1 * 64 + p2 * 32 + p3 * 16 + p4 * 8 + p5 * 4 + p6 * 2 + p7;
            bitbuf[k] = (Byte)(255-value);
        }
        
        for (NSInteger t = 0; t < width / 8; t++)
        {
            printdata[s] = bitbuf[t];
            s += 1;
        }
    }

    
    NSString *haha = [NSString stringWithFormat:@"DIRECTION %d\n",0];
    
    NSString *speed = [NSString stringWithFormat:@"SPEED %d\n",4];
    NSString *density = [NSString stringWithFormat:@"DENSITY %d\n",8];//0~15
    NSString *bitmap = [NSString stringWithFormat:@"BITMAP %d,%d,%d,%d,0,",0,0,(int)ceilf(tempImage.size.width/8.f),(int)tempImage.size.height];
    NSString *size = [NSString stringWithFormat:@"SIZE %d mm,%d mm\n",labelWidth,labelHeight];

    NSString *gap = nil;
    gap = @"GAP 2 mm,0 mm\n";
    [self printText:size];//设定卷标纸的宽度和长度
    [self printText:gap];//两张卷标纸间的垂直间距距离（间隙长度和间隙偏移）
    [self printText:speed];
    [self printText:density];
    [self printText:haha];
    [self printText:@"REFERENCE 0,0\n"];
    [self printText:@"SET TEAR ON\n"];//撕纸模式on
    [self printText:@"CLS\n"];//清除影响缓冲区(image buffer)的数据
//    [self printText:@"SET CUTTER OFF"];//裁剪（切刀）模式off
    [self printText:bitmap];//打印位图指令

    //创建byte数组内存的地址
    Byte* bitmapData = malloc(160);
    NSInteger h = (int)ceil(s/160.f);
    NSInteger index = 0;
    for (NSInteger i = 0; i < h; i++) {
        NSInteger s1 = 0;
        for (NSInteger j = 0 ; j < 160; j++) {
            bitmapData[s1++] = printdata[index++];
        }
        NSData *subData = [NSData dataWithBytes:bitmapData length:160];
        [self writeData:subData];
    }

    [self printText:@"\n"];

    NSString *sendText = nil;
    sendText = @"PRINT 1,1\n";
    
   
    
    if (nil != _socket)
    {
        [self writeWifiEndData:[sendText dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] ];
    }
    else
    {
        [[ZXPrinterManager sharedInstance] writeData:[sendText dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] sendNum:1 completion:^(int sendSize, int totalSize) {
            if (self.sendBlock) {
                self.sendBlock(sendSize,totalSize);
            }
        }];
    }
    
    free(imagedata);
    free(printdata);
    free(bitbuf);
    free(bitmapData);
}
    

    
- (NSString *)convertDataToHexStr:(NSData *)data {
    
    if (!data || [data length] == 0) {
        return @"";
    }
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString*hexStr= [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if([hexStr length] == 2){
                [string appendString:hexStr];
            } else{
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
    
@end
