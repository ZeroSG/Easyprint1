//
//  NSObject+Device.h
//  PrinterDemo
//
//  Created by ZJ on 4/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Device :NSObject

@property(nonatomic,copy,readwrite) NSString *name;
@property(nonatomic,copy,readwrite) NSString *uuid;

-(void) configWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
