//
//  TPOSJTWallet.h
//  TokenBank
//
//  Created by MarcusWoo on 26/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@interface TPOSJTWallet : NSObject

@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *address;

@end
