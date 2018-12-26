//
//  TPOSTransactionViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSTokenModel;
@class TPOSQRCodeResult;

@interface TPOSTransactionViewController : TPOSBaseViewController

@property (nonatomic, strong) TPOSQRCodeResult *qrResult;
@property (nonatomic, strong) TPOSTokenModel *currentTokenModel;

@end
