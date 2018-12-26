//
//  TPOSAuthID.h
//  TokenBank
//
//  Created by MarcusWoo on 13/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  TouchID 状态
 */
typedef NS_ENUM(NSUInteger, TPOSAuthIDState){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    TPOSAuthIDStateNotSupport = 0,
    /**
     *  TouchID/FaceID 验证成功
     */
    TPOSAuthIDStateSuccess = 1,
    
    /**
     *  TouchID/FaceID 验证失败
     */
    TPOSAuthIDStateFail = 2,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    TPOSAuthIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    TPOSAuthIDStateInputPassword = 4,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    TPOSAuthIDStateSystemCancel = 5,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    TPOSAuthIDStatePasswordNotSet = 6,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置TouchID
     */
    TPOSAuthIDStateTouchIDNotSet = 7,
    /**
     *  TouchID/FaceID 无效
     */
    TPOSAuthIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    TPOSAuthIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    TPOSAuthIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    TPOSAuthIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    TPOSAuthIDStateVersionNotSupport = 12
};

typedef NS_ENUM(NSInteger, TPOSAuthSupportType) {
    TPOSAuthSupportTypeNone,
    TPOSAuthSupportTypeTouchID,
    TPOSAuthSupportTypeFaceID
};

@interface TPOSAuthID : LAContext

typedef void (^StateBlock)(TPOSAuthIDState state,NSError *error);

+ (instancetype)sharedInstance;

/**
 启动TouchID/FaceID进行验证
 
 @param desc TouchID/FaceID显示的描述
 @param block 回调状态的block
 */

- (void)tb_showAuthIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;

//返回支持的验证方式
- (TPOSAuthSupportType)supportBiometricType;

@end
