//
//  TPOSImportWalletViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSBlockChainModel;

typedef NS_ENUM(NSInteger, TPOSImportWalletType) {
    TPOSImportWalletTypeMemonic = 1 << 0,
    TPOSImportWalletTypePrivateKey = 1 << 1
};

@interface TPOSImportWalletViewController : TPOSBaseViewController
@property (nonatomic, strong) TPOSBlockChainModel *blockchain;
@end
