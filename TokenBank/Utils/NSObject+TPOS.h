//
//  NSObject+TPOS.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/23.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TPOS)

- (BOOL)tb_isNull;

- (instancetype)tb_nullToNilIfNeed;

@end
