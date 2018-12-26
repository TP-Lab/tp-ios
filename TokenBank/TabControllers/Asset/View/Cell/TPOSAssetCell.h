//
//  TPOSAssetCell.h
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSTokenModel;

@interface TPOSAssetCell : UITableViewCell

- (void)updateWithModel:(TPOSTokenModel *)tokenModel ;

- (void)updatePrivateStatus:(BOOL)status;

@end
