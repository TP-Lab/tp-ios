//
//  UIDevice+Utility.h
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>

@interface UIDevice (Utility)

- (NSString *)tb_appVersion;
- (NSString *)tb_deviceModel;
- (NSString *)tb_appBundleVersion;
- (NSString *)tb_appBundleIdentifier;
- (BOOL)highPerformanceDevice;

@end
