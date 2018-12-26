//
//  TPOSRecommendGasModel.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@interface TPOSRecommendGasModel : NSObject

@property (nonatomic, assign) CGFloat min_gas;
@property (nonatomic, assign) CGFloat recommend_gas;
@property (nonatomic, assign) CGFloat max_gas;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, assign) CGFloat gas_price;

@end
