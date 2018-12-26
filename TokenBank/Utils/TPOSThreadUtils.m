//
//  TPOSThreadUtils.m
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSThreadUtils.h"

@implementation TPOSThreadUtils

+ (void)runOnMainThread:(dispatch_block_t)block {
    if (block) {
        if ([[NSThread currentThread] isMainThread]) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    }
}

@end
