//
//  TPOSTokenModel.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/12.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@class TPOSBlockChainModel;

@interface TPOSTokenModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *blockchain_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) long long decimal;
@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat price_usd;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *bl_symbol;
@property (nonatomic, assign) NSInteger token_type; //0表示平台里的原生币，例如eth, 1表示是平台的代币
@property (nonatomic, assign) NSInteger added; //是否已经添加, 0表示没添加， 1表示添加

@property (nonatomic, assign) CGFloat asset; //价值

// /v1/all_token/list
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) TPOSBlockChainModel *blockchain;

@end
