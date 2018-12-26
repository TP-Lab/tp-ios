//
//  NSString+TPOS.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/13.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TPOS)

+ (NSString *)guid;

- (BOOL)tb_isEmpty;

- (NSString *)tb_md5;

//可逆加密
- (NSString*)tb_encodeStringWithKey:(NSString*)key;

@end
