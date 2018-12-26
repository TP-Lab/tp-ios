//
//  TPOSAuthPasswordViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 13/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

typedef NS_ENUM(NSInteger, kTPOSPasswordType) {
    kTPOSPasswordTypeSet = 0,
    kTPOSPasswordTypeReconfirm = 1,
    kTPOSPasswordTypeEnter = 2,
    kTPOSPasswordTypeCancel = 3
};

@interface TPOSAuthPasswordViewController : TPOSBaseViewController
@property (nonatomic, assign) kTPOSPasswordType pwdType;
@property (nonatomic, strong) NSString *prePassword;
@end
