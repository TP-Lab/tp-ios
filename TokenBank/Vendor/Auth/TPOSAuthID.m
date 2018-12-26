//
//  TPOSAuthID.m
//  TokenBank
//
//  Created by MarcusWoo on 13/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAuthID.h"
#import <UIKit/UIKit.h>
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"

@implementation TPOSAuthID

+ (instancetype)sharedInstance {
    static TPOSAuthID *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TPOSAuthID alloc] init];
    });
    return instance;
}

- (TPOSAuthSupportType)supportBiometricType {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        if (kIphoneX) {
            return TPOSAuthSupportTypeFaceID;
        } else {
            return TPOSAuthSupportTypeTouchID;
        }
    } else {
        return TPOSAuthSupportTypeNone;
    }
}

- (void)tb_showAuthIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TPOSLog(@"系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)");
            block(TPOSAuthIDStateVersionNotSupport,nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    
    // 验证失败提示信息，为 @"" 则不提示
    context.localizedFallbackTitle = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_pwd"];
    
    NSError *error = nil;
    
    // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
    // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:desc == nil ? [[TPOSLocalizedHelper standardHelper] stringWithKey:@"auth_with_touchId"] : desc reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TPOSLog(@"TouchID/FaceID 验证成功");
                    block(TPOSAuthIDStateSuccess,error);
                });
            }else if(error){
                
                if (@available(iOS 11.0, *)) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID/FaceID 验证失败");
                                block(TPOSAuthIDStateFail,error);
                            });
                            break;
                        }
                        case LAErrorUserCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID/FaceID 被用户手动取消");
                                block(TPOSAuthIDStateUserCancel,error);
                            });
                        }
                            break;
                        case LAErrorUserFallback:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"用户不使用TouchID/FaceID,选择手动输入密码");
                                block(TPOSAuthIDStateInputPassword,error);
                            });
                        }
                            break;
                        case LAErrorSystemCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                                block(TPOSAuthIDStateSystemCancel,error);
                            });
                        }
                            break;
                        case LAErrorPasscodeNotSet:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID/FaceID 无法启动,因为用户没有设置密码");
                                block(TPOSAuthIDStatePasswordNotSet,error);
                            });
                        }
                            break;
                            //case LAErrorTouchIDNotEnrolled:{
                        case LAErrorBiometryNotEnrolled:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID/FaceID 无法启动,因为用户没有设置TouchID");
                                block(TPOSAuthIDStateTouchIDNotSet,error);
                            });
                        }
                            break;
                            //case LAErrorTouchIDNotAvailable:{
                        case LAErrorBiometryNotAvailable:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 无效");
                                block(TPOSAuthIDStateTouchIDNotAvailable,error);
                            });
                        }
                            break;
                            //case LAErrorTouchIDLockout:{
                        case LAErrorBiometryLockout:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)");
                                block(TPOSAuthIDStateTouchIDLockout,error);
                            });
                        }
                            break;
                        case LAErrorAppCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                                block(TPOSAuthIDStateAppCancel,error);
                            });
                        }
                            break;
                        case LAErrorInvalidContext:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                                block(TPOSAuthIDStateInvalidContext,error);
                            });
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    // iOS 11.0以下的版本只有 TouchID 验证
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 验证失败");
                                block(TPOSAuthIDStateFail,error);
                            });
                            break;
                        }
                        case LAErrorUserCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 被用户手动取消");
                                block(TPOSAuthIDStateUserCancel,error);
                            });
                        }
                            break;
                        case LAErrorUserFallback:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"用户不使用TouchID,选择手动输入密码");
                                block(TPOSAuthIDStateInputPassword,error);
                            });
                        }
                            break;
                        case LAErrorSystemCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                                block(TPOSAuthIDStateSystemCancel,error);
                            });
                        }
                            break;
                        case LAErrorPasscodeNotSet:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 无法启动,因为用户没有设置密码");
                                block(TPOSAuthIDStatePasswordNotSet,error);
                            });
                        }
                            break;
                        case LAErrorTouchIDNotEnrolled:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                                block(TPOSAuthIDStateTouchIDNotSet,error);
                            });
                        }
                            break;
                            //case :{
                        case LAErrorTouchIDNotAvailable:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 无效");
                                block(TPOSAuthIDStateTouchIDNotAvailable,error);
                            });
                        }
                            break;
                        case LAErrorTouchIDLockout:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                                block(TPOSAuthIDStateTouchIDLockout,error);
                            });
                        }
                            break;
                        case LAErrorAppCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                                block(TPOSAuthIDStateAppCancel,error);
                            });
                        }
                            break;
                        case LAErrorInvalidContext:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                TPOSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                                block(TPOSAuthIDStateInvalidContext,error);
                            });
                        }
                            break;
                        default:
                            break;
                    }
                }
                
            }
        }];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TPOSLog(@"当前设备不支持TouchID/FaceID");
            block(TPOSAuthIDStateNotSupport,error);
        });
        
    }
}

@end
