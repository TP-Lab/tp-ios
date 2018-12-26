//
//  TPOSChooseTokenViewController.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSTokenModel;

@interface TPOSChooseTokenViewController : TPOSBaseViewController

@property (nonatomic, copy) NSString *blockChainId;

@property (nonatomic, copy) void (^selectBlock)(TPOSTokenModel *tokenModel);

@end
