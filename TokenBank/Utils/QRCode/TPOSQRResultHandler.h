//
//  TPOSQRResultHandler.h
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPOSQRCodeResult;

@interface TPOSQRResultHandler : NSObject

+ (instancetype)sharedInstance;

- (TPOSQRCodeResult *)codeResultWithScannedString:(NSString *)codeString;

@end
