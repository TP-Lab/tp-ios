//
//  TPOSDataBaseManager.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FMDB;

@interface TPOSDataBaseManager : NSObject

@property (nonatomic, strong, readonly) FMDatabaseQueue *dataBaseQueue;

+ (instancetype)shareInstance;

@end
