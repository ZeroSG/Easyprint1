//
//  UIViewController+DeviceListController.h
//  PrinterDemo
//
//  Created by ZJ on 4/14/22.
//

#import <UIKit/UIKit.h>
#import "ConnecterManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceListController : UIViewController
@property(nonatomic,copy)ConnectDeviceState state;
@end

NS_ASSUME_NONNULL_END
