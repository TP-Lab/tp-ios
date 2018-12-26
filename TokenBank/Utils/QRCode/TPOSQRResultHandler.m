//
//  TPOSQRResultHandler.m
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSQRResultHandler.h"
#import "TPOSQRCodeResult.h"

@implementation TPOSQRResultHandler

+ (instancetype)sharedInstance {
    static TPOSQRResultHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TPOSQRResultHandler alloc] init];
    });
    return sharedInstance;
}

- (TPOSQRCodeResult *)codeResultWithScannedString:(NSString *)codeString {
    TPOSQRCodeResult *result = [[TPOSQRCodeResult alloc] init];
    if (codeString) {
        NSArray *comps = [codeString componentsSeparatedByString:@"?"];
        if (comps && comps.count > 0) {
            NSString *ibanPart = comps.firstObject;
            NSArray *ibanComps = [ibanPart componentsSeparatedByString:@":"];
            if (ibanComps && ibanComps.count > 0) {
                if ([ibanComps.firstObject isEqualToString:@"iban"]) {
                    result.iban = ibanComps.lastObject;
                } else {
                    result.address = ibanComps.lastObject;
                }
            }
            
            NSString *otherPart = comps.lastObject;
            NSArray *otherComps = [otherPart componentsSeparatedByString:@"&"];
            if (otherComps && otherComps.count > 0) {
                for (NSString *comp in otherComps) {
                    NSArray *keyValue = [comp componentsSeparatedByString:@"="];
                    if ([keyValue.firstObject isEqualToString:@"amount"]) {
                        if (keyValue.lastObject) {
                            result.amount = [NSNumber numberWithFloat:[keyValue.lastObject floatValue]];
                        }
                    } else if ([keyValue.firstObject isEqualToString:@"token"]) {
                        if (keyValue.lastObject) {
                            result.token = keyValue.lastObject;
                        }
                    }
                }
            }
        }
    }
    return result;
}

@end
