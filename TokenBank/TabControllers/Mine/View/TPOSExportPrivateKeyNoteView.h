//
//  TPOSExportPrivateKeyNoteView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"

@class TPOSWalletModel;

@interface TPOSExportPrivateKeyNoteView : TPOSAlertView

+ (TPOSExportPrivateKeyNoteView *)exportPrivateKeyNoteViewWithWalletModel:(TPOSWalletModel *)walletModel;

@end
