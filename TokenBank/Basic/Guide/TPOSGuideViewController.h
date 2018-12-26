//
//  TPOSGuideViewController.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOSGuideViewController : UICollectionViewController

@property (nonatomic, copy) void (^enterButtonAction)(void);

@end
