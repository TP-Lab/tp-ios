//
//  NSDate+TPOS.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/27.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TPOS)

//xx前
+ (NSString *)dateDescriptionFrom:(NSInteger)timestamp;

//
+ (NSString *)dateDescriptionFromUTC:(NSString *)utc;

//x/x
+ (NSString *)tb_timeFormat:(NSInteger)timestamp;

@end
