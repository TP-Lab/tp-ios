//
//  TPOSJTPaymentResult.h
//  TokenBank
//
//  Created by MarcusWoo on 30/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOSJTPaymentResult : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *py_hash;
@property (nonatomic, copy) NSString *resultMsg;

@end
