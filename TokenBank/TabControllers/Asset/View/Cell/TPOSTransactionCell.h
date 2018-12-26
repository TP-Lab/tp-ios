//
//  TPOSTransactionCellTableViewCell.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/3.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSTransactionCell;

@protocol TPOSTransactionCellDelegate <NSObject>

- (void)transactionCell:(TPOSTransactionCell *)cell valueChange:(NSString *)value;

@end

@interface TPOSTransactionCell : UITableViewCell

@property (nonatomic, weak) id<TPOSTransactionCellDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField *inputTextField;

+ (NSString *)reuseIdentifier;

- (void)textFieldEnable:(BOOL)enable;

- (void)updateWithTitle:(NSString *)title value:(NSString *)value;

@end
