//
//  NSObject+TPOS.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/23.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "NSObject+TPOS.h"

@implementation NSObject (TPOS)

- (BOOL)tb_isNull {
    return [self isKindOfClass:[NSNull class]];
}

- (instancetype)tb_nullToNilIfNeed {
    if ([self tb_isNull]) {
        return nil;
    }
    return self;
}

@end
