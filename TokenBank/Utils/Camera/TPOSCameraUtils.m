//
//  TPOSCameraUtils.m
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSCameraUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "TPOSScanQRCodeViewController.h"
#import "TPOSLocalizedHelper.h"
#import "TPOSMacro.h"

@implementation TPOSCameraUtils

+ (instancetype)sharedInstance {
    static TPOSCameraUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TPOSCameraUtils alloc] init];
    });
    return sharedInstance;
}

- (void)startScanCameraWithVC:(UIViewController *)viewController completion:(TPOSCameraScanResult)resultBlock {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    __weak typeof(UIViewController *) weakVC = viewController;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        TPOSScanQRCodeViewController *vc = [[TPOSScanQRCodeViewController alloc] init];
                        vc.kTPOSScanQRCodeResult = ^(NSString *result) {
                            if (resultBlock) {
                                resultBlock(result);
                            }
                        };
                        [weakVC.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    TPOSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    TPOSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            TPOSScanQRCodeViewController *vc = [[TPOSScanQRCodeViewController alloc] init];
            vc.kTPOSScanQRCodeResult = ^(NSString *result) {
                if (resultBlock) {
                    resultBlock(result);
                }
            };
            [viewController.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"warm_tip"] message:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"camera_setting_tips"] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [viewController presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            TPOSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"warm_tip"] message:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"no_camera"] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [viewController presentViewController:alertC animated:YES completion:nil];
    }
}


@end
