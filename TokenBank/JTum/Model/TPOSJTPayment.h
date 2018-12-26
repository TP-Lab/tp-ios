//
//  TPOSJTPayment.h
//  TokenBank
//
//  Created by MarcusWoo on 30/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOSJTAmount : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *issuer;

- (NSDictionary *)amountParam;

@end

@interface TPOSJTPayment : NSObject

@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) TPOSJTAmount *amount;
@property (nonatomic, strong) NSArray *memos;
@property (nonatomic, strong) NSString *choice;//如果发起交易的是swt，则不需要传

- (NSDictionary *)paymentParam;

@end
