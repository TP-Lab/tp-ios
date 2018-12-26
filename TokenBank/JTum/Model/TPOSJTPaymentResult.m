//
//  TPOSJTPaymentResult.m
//  TokenBank
//
//  Created by MarcusWoo on 30/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSJTPaymentResult.h"

@implementation TPOSJTPaymentResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"py_hash":@"hash"};
}

@end
