//
//  TPOSTransactionHighOptionView.h
//  TokenBank
//
//  Created by MarcusWoo on 09/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPOSTransactionTextField.h"

@interface TPOSTransactionHighOptionView : UIView
@property (nonatomic, strong) TPOSTransactionTextField *gasPriceTextfield;
@property (nonatomic, strong) TPOSTransactionTextField *gasAmountTextfield;
@end
