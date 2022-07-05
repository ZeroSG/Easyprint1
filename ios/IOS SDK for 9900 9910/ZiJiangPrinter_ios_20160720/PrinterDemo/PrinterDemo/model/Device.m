//
//  NSObject+Device.m
//  PrinterDemo
//
//  Created by ZJ on 4/20/22.
//

#import "Device.h"

@implementation Device :NSObject

-(void) configWithDictionary:(NSDictionary *)dictionary{
    self.name = [dictionary objectForKey:@"name"];
    self.uuid = [dictionary objectForKey:@"uuid"];
}
@end
