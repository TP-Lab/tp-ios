//
//  TPOSJTPOSalance.h
//  TokenBank
//
//  Created by MarcusWoo on 30/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@interface TPOSJTPOSalance : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *issuer;
@property (nonatomic, copy) NSString *freezed;

@end
