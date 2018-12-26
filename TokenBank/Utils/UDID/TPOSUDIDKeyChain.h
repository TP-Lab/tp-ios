//
//  TPOSUDIDKeyChain.h
//  KeyChainStore
//
//  Created by MarcusWoo on 28/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOSUDIDKeyChain : NSObject

+ (NSString *)myCurrentDevideId;
+ (NSString *)myUniqueDeviceId;

@end
