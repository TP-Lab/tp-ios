//
//  TPOSJTPayment.m
//  TokenBank
//
//  Created by MarcusWoo on 30/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSJTPayment.h"

@implementation TPOSJTAmount

- (NSDictionary *)amountParam {
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (self.value) {
        [params setObject:self.value forKey:@"value"];
    }
    if (self.currency) {
        [params setObject:self.currency forKey:@"currency"];
    }
    if (self.issuer) {
        [params setObject:self.issuer forKey:@"issuer"];
    }
    return params;
}

@end

@implementation TPOSJTPayment

- (NSDictionary *)paymentParam {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (self.source && self.source.length > 0) {
        [params setObject:self.source forKey:@"source"];
    }
    if (self.destination && self.destination.length > 0) {
        [params setObject:self.destination forKey:@"destination"];
    }
    if (self.amount) {
        NSMutableDictionary *amountDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (self.amount.value && self.amount.value.length > 0) {
            [amountDic setObject:self.amount.value forKey:@"value"];
        }
        if (self.amount.currency && self.amount.currency.length > 0) {
            [amountDic setObject:self.amount.currency forKey:@"currency"];
        }
        if (self.amount.issuer) {
            [amountDic setObject:self.amount.issuer forKey:@"issuer"];
        }
        [params setObject:amountDic forKey:@"amount"];
    }
    
    
    if (self.memos && self.memos.count > 0) {
        [params setObject:self.memos forKey:@"memos"];
    }
    if (self.choice && self.choice.length > 0) {
        if (![@"swt" isEqualToString:[self.amount.currency lowercaseString]]) {
            [params setObject:self.choice forKey:@"choice"];
        }
    }

    return @{@"payment" : params};
}

@end
