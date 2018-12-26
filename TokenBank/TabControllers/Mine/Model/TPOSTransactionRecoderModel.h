//
//  TPOSTransactionRecoderModel.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/12.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@interface TPOSTransactionRecoderModel : NSObject

/*
 "addr_token" = "";
 "block_number" = 4976795;
 from = 0x40e5a542087fa4b966209707177b103d158fd3a4;
 gas = 43600;
 hash = 0x45961450daae051804075c193c954f29543f838b0eaec600909aaba262f85f1a;
 "method_id" = "";
 status = 1;
 timestamp = 1516982624;
 to = 0x0d07301143cc8bea1ed470f574f6f8815c1ca2b8;
 "token_value" = 0;
 type = 0;
 "used_gas" = 0;
 value = 5000000000000000;
 */


@property (nonatomic, copy) NSString *addr_token;
@property (nonatomic, copy) NSString *block_number;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, copy) NSString *hashKey;
@property (nonatomic, copy) NSString *method_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *token_value;
@property (nonatomic, copy) NSString *decimal;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *used_gas;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *input;

@end
