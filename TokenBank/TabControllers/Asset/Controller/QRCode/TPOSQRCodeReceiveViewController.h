//
//  TPOSQRCodeReceiveViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

typedef NS_ENUM(NSInteger, TPOSBasicTokenType) {
    TPOSBasicTokenTypeEtheruem    = 0,
    TPOSBasicTokenTypeJingTum     = 1,
    TPOSBasicTokenTypeBitCoin     = 2,
};

@interface TPOSQRCodeReceiveViewController : TPOSBaseViewController

@property (nonatomic, assign) TPOSBasicTokenType basicType;
@property (nonatomic, assign) CGFloat tokenAmount;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic, copy) NSString *address;

@end
