/*
 ============================================================================
 Name        : PedometerManager.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : User pedometer manager class
 ============================================================================
 */

#import <CoreBluetooth/CoreBluetooth.h>

#import "ZXPrinterManager.h"
#import "ZXPrinterSDK.h"

#define SERVICE_ID             @"18F0"
#define CHARACTER_WRITE        @"2AF1"
#define CHARACTER_NOTIFICATION @"2AF0"


@interface ZXPrinterManager ()
{
    NSMutableArray* _peripheralArray;
    LGPeripheral* _connectedPeripheral;
}

@property (nonatomic, copy) PedometerManagerScanPedometersCallback scanBlock;
@property (nonatomic, copy) PedometerManagerPedometerConnectedCallback connectedBlock;
@property (nonatomic, copy) PedometerManagerPedometerConnectedCallback disconnectedBlock;
@property (nonatomic, copy) sendImageBlock sendBlock;

@property (nonatomic,assign) int shouNum;
@property (nonatomic,assign) int finalNum;
@property (nonatomic, retain) LGCharacteristic* characterWrite;
@property (nonatomic, retain) LGCharacteristic* characterNotification;

@end

@implementation ZXPrinterManager

static ZXPrinterManager* _sharedInstance;

+ (ZXPrinterManager*)sharedInstance
{
    @synchronized(self)
    {
        if (nil == _sharedInstance)
        {
            _sharedInstance = [[ZXPrinterManager alloc] init];
        }
    }
    
	return _sharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLGPeripheralDidDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCBCentralManagerStatePoweredOn object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCBCentralManagerStatePoweredOff object:nil];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _peripheralArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePeripheralConnectNotification:) name:kLGPeripheralDidConnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePeripheralDisconnectNotification:) name:kLGPeripheralDidDisconnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleToothBluePoweredOnNotification:) name:kCBCentralManagerStatePoweredOn object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleToothBluePoweredOffNotification:) name:kCBCentralManagerStatePoweredOff object:nil];
    }
    
    return self;
}

- (void)handlePeripheralConnectNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterConnectedNotification object:nil];
}

- (void)handlePeripheralDisconnectNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterDisconnectedNotification object:nil];
    
    if (notification.object == _connectedPeripheral)
    {
        [self connectToPeripheral:_connectedPeripheral completion:nil];
    }
}

- (void)handleToothBluePoweredOnNotification:(NSNotification*)notification
{
    if (nil != _connectedPeripheral)
    {
        [self connectToPeripheral:_connectedPeripheral completion:nil];
    }
}

- (void)handleToothBluePoweredOffNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXPrinterDisconnectedNotification object:nil];
}

- (void)connectToPeripheral:(LGPeripheral*)peripheral completion:(PedometerManagerPedometerConnectedCallback)callback
{
    self.connectedBlock = callback;
    
    [peripheral connectWithCompletion:^(NSError* error)
    {
        [peripheral discoverServicesWithCompletion:^(NSArray* services, NSError* error)
        {
            for (LGService* service in services)
            {
                if (NSOrderedSame == [service.UUIDString caseInsensitiveCompare:SERVICE_ID])
                {
                    [service discoverCharacteristicsWithCompletion:^(NSArray* characteristics, NSError* error)
                    {
                        for (LGCharacteristic* charact in characteristics)
                        {
                            if (NSOrderedSame == [charact.UUIDString caseInsensitiveCompare:CHARACTER_WRITE])
                            {
                                self.characterWrite = charact;
                            }
                            else if (NSOrderedSame == [charact.UUIDString caseInsensitiveCompare:CHARACTER_NOTIFICATION])
                            {
                                self.characterNotification = charact;
                            }
                        }
                        
                        _connectedPeripheral = peripheral;
                        
                        if (self.connectedBlock)
                        {
                            self.connectedBlock(peripheral);
                        }
                        
                        self.connectedBlock = nil;
                    }];
                    
                    break;
                }
            }
        }];
    }];
}

- (void)disconnectToPeripheral:(LGPeripheral*)peripheral completion:(PedometerManagerPedometerConnectedCallback)callback
{
    self.disconnectedBlock = callback;
    
    [peripheral disconnectWithCompletion:^(NSError* error)
    {
        _connectedPeripheral = nil;
        
        if (self.disconnectedBlock)
        {
            self.disconnectedBlock(peripheral);
        }
        
        self.disconnectedBlock = nil;
    }];
}

- (void)scanPedometersWithCompletion:(PedometerManagerScanPedometersCallback)callback
{
    [_peripheralArray removeAllObjects];
    
    self.scanBlock = callback;
    
    [[LGCentralManager sharedInstance] scanForPeripheralsWithServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:SERVICE_ID], nil] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}
    completion:^(LGPeripheral* peripheral)
    {
        BOOL isFound = NO;
        
        for (LGPeripheral* tempPeriheral in _peripheralArray)
        {
            if (tempPeriheral.cbPeripheral == peripheral.cbPeripheral)
            {
                isFound = YES;
            }
        }
        
        if (!isFound)
        {
            [_peripheralArray addObject:peripheral];
            
            if (self.scanBlock)
            {
                self.scanBlock(peripheral);
            }
        }
    }];
}

- (void)stopScanPedometers
{
    self.scanBlock = nil;
    [[LGCentralManager sharedInstance] stopScanForPeripherals];
}

- (void)writeData:(NSData*)data sendNum:(int)sendNum completion:(sendImageBlock)callback
{
    self.finalNum = sendNum;
    self.sendBlock = callback;
    [self.characterWrite writeValue:data completion:^(NSError* error)
    {
        self.shouNum++;
        if (self.sendBlock) {
            self.sendBlock(self.shouNum,self.finalNum);
        }
    }];
}

- (void)writeData:(NSData*)data
{
    [self.characterWrite writeValue:data completion:^(NSError* error)
     {
         
     }];
}

@end
