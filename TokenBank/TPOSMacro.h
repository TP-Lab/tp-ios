//
//  TPOSMacro.h
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#ifndef TPOSMacro_h
#define TPOSMacro_h

#define kScreenWidth               [UIScreen mainScreen].bounds.size.width
#define kScreenHeight              [UIScreen mainScreen].bounds.size.height

#define kIphoneX (kScreenHeight == 812)
#define kIphone5 (kScreenHeight == 568)
#define kIphone6 (kScreenHeight == 667)
#define kIphone7 (kScreenHeight == 667)
#define kIphonePlus (kScreenHeight == 736)

#define kBuglyAppId @""
#define kWXAppId @""
#define kQQAppId @""

// blockchain type
#define ethChain @"1"
#define swtcChain @"2"

// token type
#define nativeToken @"0"
#define nonnativeToken @"1"

// transaction status code
#define transactionSuccess @"1"
#define transactionFail @"0"

// jingchang api code
#define jingchangSuccessCode @"0"

#define kDBVersion 1

#define kCreateWalletNotification @"kCreateWalletNotification"
#define kEditWalletNotification   @"kEditWalletNotification"
#define kDeleteWalletNotification @"kDeleteWalletNotification"
#define kChangeWalletNotification @"kChangeWalletNotification"

#define kBackupWalletNotification   @"kBackupWalletNotification"

//国际化通知
#define kLocalizedNotification    @"kLocalizedNotification"

//JT加载完成的通知
#define kJTFinishLoadedTxNotification @"kJTFinishLoadedTxNotification"
#define kJTFinishLoadedWalletNotification @"kJTFinishLoadedWalletNotification"

//验证登入key
#define kAuthEnterAppSuccessNotification    @"kAuthEnterAppSuccessNotification"
#define kAuthSwithOnStatusKey       @"kAuthSwithOnStatusKey"        //获取开关状态
#define kAuthPasswordKey            @"kAuthPasswordKey"             //获取密码
#define kAuthTypePassword           @"kAuthTypePassword"            //密码识别
#define kAuthTypeTouchId            @"kAuthTypeTouchId"             //TouchId识别
#define kAuthTypeFaceId             @"kAuthTypeFaceId"              //FaceId识别
#define kAuthTypeKey                @"kAuthTypeKey"                 //授权登录方式

//debug log
#ifdef DEBUG
#define TPOSLog(...) NSLog(__VA_ARGS__)
#else
#define TPOSLog(...) {}
#endif

#endif /* TPOSMacro_h */
