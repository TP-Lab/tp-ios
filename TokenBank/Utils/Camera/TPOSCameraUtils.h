//
//  TPOSCameraUtils.h
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TPOSCameraScanResult) (NSString *result);

@interface TPOSCameraUtils : NSObject

+ (instancetype)sharedInstance;
- (void)startScanCameraWithVC:(UIViewController *)viewController completion:(TPOSCameraScanResult)resultBlock;

@end
