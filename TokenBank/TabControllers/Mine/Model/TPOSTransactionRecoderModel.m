//
//  TPOSTransactionRecoderModel.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/12.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionRecoderModel.h"

@implementation TPOSTransactionRecoderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"hashKey":@"hash"};
}

@end
