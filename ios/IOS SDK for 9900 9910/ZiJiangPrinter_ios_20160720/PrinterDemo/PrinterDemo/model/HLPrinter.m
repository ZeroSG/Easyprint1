//
//  HLPrinter.m
//  PrinterDemo
//
//  Created by ZJ on 4/21/22.
//

#import "HLPrinter.h"


@implementation HLPrinter

- (instancetype)init{
    self = [super init];
    if(self){
        [self defaultSetting];
    }
    return self;
}

-(void) defaultSetting{
    _array = [[NSMutableData alloc] init];
    
    Byte initBytes[] = {0x1B,0x40};
    [_array appendBytes:initBytes length:sizeof(initBytes)];
    Byte lineSpace[] = {0x1B,0x32};
    [_array appendBytes:lineSpace length:sizeof(lineSpace)];
    
    
}
-(void) appendText:(NSString *)text{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [text dataUsingEncoding:enc];
    [_array appendData:data];
    
}
//打印图片
- (void)printWithImage:(UIImage *)image width:(float)width height:(float)height {
    UIImage * printImage = [self scaleImageWithImage:image width:width height:height];
    NSData *data = [self imageToThermalData:printImage];
    [_array appendData:data];
}


-(NSData *) getData{
    return _array;
}

-(UIImage*)scaleImageWithImage:(UIImage*)image width:(NSInteger)width height:(NSInteger)height
{
    CGSize size;
    size.width = width;
    size.height = height;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
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

- (NSData *) imageToThermalData:(UIImage*)image {
    CGImageRef imageRef = image.CGImage;
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self CreateARGBBitmapContextWithCGImageRef:imageRef];
    if(!context) {
        return NULL;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
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
@end
