//
//  TPOSAssetAddTokenCell.h
//  TokenBank
//
//  Created by MarcusWoo on 09/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSTokenModel;

@protocol TPOSAssetAddTokenCellDelegate<NSObject>
- (void)TPOSAssetAddTokenCellDidTapAddButton:(TPOSTokenModel *)token indexPath:(NSIndexPath *)indexPath;
@end

@interface TPOSAssetAddTokenCell : UITableViewCell
@property (nonatomic, weak) id<TPOSAssetAddTokenCellDelegate> delegate;
- (void)update:(TPOSTokenModel *)model atIndexPath:(NSIndexPath *)idx;
@end
