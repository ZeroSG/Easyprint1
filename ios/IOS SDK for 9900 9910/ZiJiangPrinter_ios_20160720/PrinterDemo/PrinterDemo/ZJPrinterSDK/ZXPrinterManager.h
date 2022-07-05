//
//  ZiJiangPrinterManager.h
//  ZiJiangPrinterManager
//
//  Created by aduo on 5/30/16.
//
//

#import <Foundation/Foundation.h>

#import "LGCentralManager.h"

typedef void (^PedometerManagerScanPedometersCallback) (LGPeripheral* peripheral);
typedef void (^PedometerManagerPedometerConnectedCallback) (LGPeripheral* peripheral);
typedef void (^sendImageBlock) (int sendSize,int totalSize);

@interface ZXPrinterManager : NSObject
{
}

@property (nonatomic, readonly) LGPeripheral* connectedPeripheral;

+ (ZXPrinterManager*)sharedInstance;

//@property(nonatomic,copy)void(^sendImageBlock)(int sendSize,int totalSize);
- (void)scanPedometersWithCompletion:(PedometerManagerScanPedometersCallback)callback;
- (void)stopScanPedometers;
- (void)connectToPeripheral:(LGPeripheral*)peripheral completion:(PedometerManagerPedometerConnectedCallback)callback;
- (void)disconnectToPeripheral:(LGPeripheral*)peripheral completion:(PedometerManagerPedometerConnectedCallback)callback;

- (void)writeData:(NSData*)data sendNum:(int)sendNum completion:(sendImageBlock)callback;
- (void)writeData:(NSData*)data;

@end
