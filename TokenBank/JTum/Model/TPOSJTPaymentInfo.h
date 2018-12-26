//
//  TNJTPaymentInfo.h
//  TokenBank
//
//  Created by MarcusWoo on 30/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPOSJTPayment.h"

@import MJExtension;

@interface TPOSJTPaymentInfo : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSNumber *date;
@property (nonatomic, copy) NSString *py_hash;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *counterparty;
@property (nonatomic, strong) NSArray *memos;
@property (nonatomic, strong) TPOSJTAmount *amount;
@property (nonatomic, strong) NSArray *effects;


@end
