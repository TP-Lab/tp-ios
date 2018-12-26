//
//  TPOSScanQRCodeViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@interface TPOSScanQRCodeViewController : TPOSBaseViewController

@property (nonatomic, copy) void(^kTPOSScanQRCodeResult)(NSString *result);

@end
