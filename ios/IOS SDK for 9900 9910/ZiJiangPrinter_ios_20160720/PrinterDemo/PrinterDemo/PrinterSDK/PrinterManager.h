//
//  PrinterManager.h
//  PrinterManager
//
//  Created by aduo on 5/30/16.
//
//

#import <Foundation/Foundation.h>

#import "LGCentralManager.h"

typedef void (^PedometerManagerScanPedometersCallback) (LGPeripheral* peripheral);
typedef void (^PedometerManagerPedometerConnectedCallback) (LGPeripheral* peripheral);


@interface PrinterManager : NSObject
{
}

@property (nonatomic, readonly) LGPeripheral* connectedPeripheral;

+ (PrinterManager*)sharedInstance;

- (void)scanPedometersWithCompletion:(PedometerManagerScanPedometersCallback)callback;
- (void)stopScanPedometers;
- (void)connectToPeripheral:(LGPeripheral*)peripheral completion:(PedometerManagerPedometerConnectedCallback)callback;
- (void)disconnectToPeripheral:(LGPeripheral*)peripheral completion:(PedometerManagerPedometerConnectedCallback)callback;

- (void)writeData:(NSData*)data;

@end
