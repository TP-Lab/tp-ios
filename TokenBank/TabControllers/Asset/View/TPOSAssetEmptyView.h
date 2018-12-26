//
//  TPOSAssetEmptyView.h
//  TokenBank
//
//  Created by MarcusWoo on 12/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPOSAssetEmptyViewDelegate<NSObject>
- (void)TPOSAssetEmptyViewDidTapAddAssetButton;
@end

@interface TPOSAssetEmptyView : UIView

@property (nonatomic, weak) id<TPOSAssetEmptyViewDelegate> delegate;

+ (instancetype)emptyViewWithDelegate:(id<TPOSAssetEmptyViewDelegate>)delegateObj;

- (void)changeLanguage;

@end
