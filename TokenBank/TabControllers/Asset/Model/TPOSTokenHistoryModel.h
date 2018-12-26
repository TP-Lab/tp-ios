//
//  TPOSTokenHistoryModel.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/28.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@interface TPOSTokenHistoryModel : NSObject

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) NSInteger timestamp;

@property (nonatomic, copy) NSString *timeToShow;
@property (nonatomic, copy) NSString *valueToShow;

@end
