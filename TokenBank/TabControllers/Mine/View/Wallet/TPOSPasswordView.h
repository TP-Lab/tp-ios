//
//  TPOSPasswordView.h
//  TPOSUIProject
//
//  Created by yf on 07/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    eEmptyPassword,
    eWeakPassword,
    eSosoPassword,
    eGoodPassword,
    eSafePassword,
} PasswordEnum;

@interface TPOSPasswordView : UIView

@property (nonatomic, assign) PasswordEnum strongType;

- (void)showPasswordViewEffectWith:(PasswordEnum)strongType;

@end
