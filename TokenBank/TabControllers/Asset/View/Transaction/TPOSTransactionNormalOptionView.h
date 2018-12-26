//
//  TPOSTransactionNormalOptionView.h
//  TokenBank
//
//  Created by MarcusWoo on 09/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPOSTransactionNormalOptionViewDelegate<NSObject>
- (void)TPOSTransactionNormalOptionViewDidTapQuestionBtn;
@end

@interface TPOSTransactionNormalOptionView : UIView
@property (nonatomic, weak) id<TPOSTransactionNormalOptionViewDelegate> delegate;
@property (nonatomic, assign) CGFloat minerFee;
@end
