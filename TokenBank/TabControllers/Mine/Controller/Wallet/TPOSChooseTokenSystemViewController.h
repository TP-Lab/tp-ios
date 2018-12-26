//
//  TPOSChooseTokenSystemViewController.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSBlockChainModel;

/**!
 * 选择token体系
 */
@interface TPOSChooseTokenSystemViewController : TPOSBaseViewController

@property (nonatomic, copy) void (^chooseAction)(TPOSBlockChainModel *blockChainModel);
@end
