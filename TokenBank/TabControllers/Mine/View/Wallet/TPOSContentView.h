//
//  TPOSContentView.h
//  DemoView
//
//  Created by yf on 08/02/2018.
//  Copyright © 2018 TokenBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSContentView;

typedef enum : NSUInteger {
    PrivateKeyShowMode,
    PrivateKeyConfirmMode,
} PrivateViewMode;

@protocol ContentViewDelegate <NSObject>

- (void)didClickConfirmPrivateKeyButton:(TPOSContentView *)selfView andPrivateKeyButton:(UIButton *)button;

- (void)didClickContentPrivateKeyButton:(TPOSContentView *)selfView andPrivateKeyButton:(UIButton *)button;

@end

@interface TPOSContentView : UIView

@property (nonatomic, strong) NSArray *wordArray;

@property (nonatomic, assign) PrivateViewMode viewMode;

@property (nonatomic, weak) id<ContentViewDelegate>delegate;

- (CGFloat)createPrivateKeyButtonsWithArray:(NSArray *)privateKeyWord;

- (void)resetAllProperty;

@end
