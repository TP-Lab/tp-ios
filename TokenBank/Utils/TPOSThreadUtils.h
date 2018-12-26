//
//  TPOSThreadUtils.h
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOSThreadUtils : NSObject

+ (void)runOnMainThread:(dispatch_block_t)block;

@end
