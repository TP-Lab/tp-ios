//
//  TPOSQRCodeResult.h
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOSQRCodeResult : NSObject

@property (nonatomic, copy) NSString *iban; //iban（ETH）
@property (nonatomic, copy) NSString *address; //地址 （暂时给jt用）
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSNumber *amount;

@end
