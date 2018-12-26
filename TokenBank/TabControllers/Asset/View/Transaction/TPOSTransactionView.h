//
//  TPOSTransactionView.h
//  TokenBank
//
//  Created by MarcusWoo on 08/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPOSTransactionViewDelegate<NSObject>
- (void)TPOSTransactionViewDidTapNextButtonWithTransOrder:(id)transOrder;

- (void)TPOSTransactionViewDidTapNextButton;

@end

@interface TPOSTransactionView : UIView

@property (nonatomic, weak) UIViewController<TPOSTransactionViewDelegate> *delegate;
@property (nonatomic, assign, readonly) CGFloat minerfee;
@property (nonatomic, assign, readonly) CGFloat transAmount;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *highLevelGas;
@property (nonatomic, strong, readonly) NSString *highLevelGasPrice;
@property (nonatomic, assign, readonly) BOOL isHighLevel;

- (void)fillToAddress:(NSString *)address;
- (void)fillToAmount:(CGFloat)amount;
- (void)fillRemark:(NSString *)remarkString;

@end
