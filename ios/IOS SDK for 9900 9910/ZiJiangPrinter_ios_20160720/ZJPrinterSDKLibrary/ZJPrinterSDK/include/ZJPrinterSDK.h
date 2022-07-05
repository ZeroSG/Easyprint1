//
//  ZJPrinterSDK.h
//  ZiJiangPrinterLibrary
//
//  Created by aduo on 5/30/16.
//
//

#ifndef __ZJPRINTERSDK_H__
#define __ZJPRINTERSDK_H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* ZJPrinterConnectedNotification;
extern NSString* ZJPrinterDisconnectedNotification;

@class ZJPrinter;

typedef void (^ZJPrinterScanPrintersCallback) (ZJPrinter* printer);

typedef enum CodeBarType
{
    CodeBarType_UPC_A = 0,
    CodeBarType_UPC_E,
    CodeBarType_JAN13,
    CodeBarType_JAN8,
    CodeBarType_CODE39,
    CodeBarType_ITF,
    CodeBarType_CODABAR,
    CodeBarType_CODE93,
    CodeBarType_CODE128
} CodeBarType;

@interface ZJPrinter : NSObject

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* UUIDString;

@end

@interface ZJPrinterSDK : NSObject

+ (ZJPrinterSDK*)defaultZJPrinterSDK;

- (void)scanPrintersWithCompletion:(ZJPrinterScanPrintersCallback)callback;
- (void)stopScanPrinters;

- (BOOL)connectIP:(NSString*)ipAddress;

- (void)connectBT:(ZJPrinter*)printer;
- (void)disconnect;

- (void)setPrintWidth:(NSInteger)width;

- (void)printText:(NSString*)text;
- (void)printTextImage:(NSString*)text;
- (void)sendHex:(NSString*)hex;

- (void)printCodeBar:(NSString*)text type:(CodeBarType)type;
- (void)printQrCode:(NSString*)text;
- (void)printImage:(UIImage*)image;

- (void)cutPaper;
- (void)beep;
- (void)openCasher;
- (void)setFontSizeMultiple:(NSInteger)multiple;

- (void)printTestPaper;
- (void)selfTest;

@end

#endif
