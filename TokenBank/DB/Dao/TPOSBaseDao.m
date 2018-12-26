//
//  TPOSBaseDao.m
//  TokenBank
//
//  Created by MarcusWoo on 21/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseDao.h"

@interface TPOSBaseDao()
@end

@implementation TPOSBaseDao

- (instancetype)init {
    if (self = [super init]) {
        _dataBaseQueue = [TPOSDataBaseManager shareInstance].dataBaseQueue;
    }
    return self;
}

@end
