//
//  HLPrinter.h
//  PrinterDemo
//
//  Created by ZJ on 4/21/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HLPrinter : NSObject
@property(nonatomic,copy,readwrite) NSMutableData *array;

-(void) appendText:(NSString *)text;
-(NSData*) getData;
- (void)printWithImage:(UIImage *)image width:(float)width height:(float)height;
@end

NS_ASSUME_NONNULL_END
