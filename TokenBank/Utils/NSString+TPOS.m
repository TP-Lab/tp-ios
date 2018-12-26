//
//  NSString+TPOS.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/13.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "NSString+TPOS.h"
#import <CommonCrypto/CommonDigest.h>

static inline NSString * NSStringCCHashFunction(unsigned char *(function)(const void *data, CC_LONG len, unsigned char *md), CC_LONG digestLength, NSString *string) {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[digestLength];
    
    function(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:digestLength * 2];
    
    for (int i = 0; i < digestLength; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@implementation NSString (TPOS)

+ (NSString *)guid {
    return [NSUUID UUID].UUIDString;
}

- (BOOL)tb_isEmpty {
    return self.length == 0;
}

- (NSString *)tb_md5 {
    return NSStringCCHashFunction(CC_MD5, CC_MD5_DIGEST_LENGTH, self);
}

- (NSString*)tb_encodeStringWithKey:(NSString*)key {
    NSString *result = self;
    return result;
}

@end
