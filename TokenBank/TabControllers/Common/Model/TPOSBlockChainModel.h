//
//  TPOSBlockChainModel.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/31.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

//{"hid":1,"title":"以太坊","desc":"以太坊体系","default_token":"eth","url":"https://ethereum.org/","status":0,"create_time":"2018-01-08T22:11:20Z"}

@interface TPOSBlockChainModel : NSObject

@property (nonatomic, copy) NSString *hid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *default_token;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *create_time;

@end
