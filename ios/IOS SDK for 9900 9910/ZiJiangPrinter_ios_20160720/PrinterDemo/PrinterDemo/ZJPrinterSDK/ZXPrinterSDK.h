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


extern NSString* ZXPrinterConnectedNotification;
extern NSString* ZXPrinterDisconnectedNotification;

@class ZXPrinter;

typedef void (^ZXPrinterScanPrintersCallback) (ZXPrinter* printer);



@interface ZXPrinter : NSObject

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* UUIDString;

@end

@interface ZXPrinterSDK : NSObject

//BOOL _isPoweredOn;
//BOOL _isConnecting;
//BOOL _isConnected;

+ (ZXPrinterSDK*)defaultZXPrinterSDK;

@property (nonatomic, readonly) BOOL isPoweredOn;
@property (nonatomic, readonly) BOOL isConnecting;
@property (nonatomic, readonly) BOOL isConnected;

typedef void (^sendImageBlock) (int sendSize,int totalSize);
- (void)scanPrintersWithCompletion:(ZXPrinterScanPrintersCallback)callback;

- (void)stopScanPrinters;

- (BOOL)connectIP:(NSString*)ipAddress;

- (void)connectBT:(ZXPrinter*)printer;
- (void)disconnect;

- (void)setPrintWidth:(NSInteger)width;

- (void)printText:(NSString*)text;
- (void)printTextImage:(NSString*)text;
- (void)sendHex:(NSString*)hex;

- (void)printCodeBar:(NSString*)text;
- (void)printQrCode:(NSString*)text;

- (void)cutPaper;
- (void)beep;
- (void)openCasher;
- (void)setFontSizeMultiple:(NSInteger)multiple;

- (void)printTestPaper;
- (void)selfTest;



#pragma mark
#pragma mark ESC
- (void)printImage:(UIImage*)image completion:(sendImageBlock)callback;
    
#pragma mark
#pragma mark TSPL
- (void)printJBOText:(NSString*)text;
- (void)printJBOQrCode:(NSString*)text;
- (void)printImageTspl:(UIImage*)image :(int) w :(int) h;

- (void)addPrint:(int)m :(int)n;


@end

#endif
