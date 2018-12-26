//
//  TPOSWalletChainCell.h
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSBlockChainModel;

@interface TPOSWalletChainCell : UITableViewCell

- (void)updateWithChainModel:(TPOSBlockChainModel *)chainModel;

@end
