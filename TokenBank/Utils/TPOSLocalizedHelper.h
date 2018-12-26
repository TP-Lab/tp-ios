//
//  TPOSLocalizedHelper.h
//  TokenBank
//
//  Created by MarcusWoo on 26/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TPOSLocalizedString(key) [[TPOSLocalizedHelper standardHelper] stringWithKey:key]

@interface TPOSLocalizedHelper : NSObject

+ (instancetype)standardHelper;

- (NSBundle *)bundle;

- (NSString *)currentLanguage;

- (void)setUserLanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;

@end
