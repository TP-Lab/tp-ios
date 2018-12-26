//
//  TPOSDataBaseManager.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSDataBaseManager.h"
#import "UIDevice+Utility.h"

@interface TPOSDataBaseManager()

@property (nonatomic, copy) NSString *dbFilePath;

@end

@implementation TPOSDataBaseManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TPOSDataBaseManager *dataBaseManager;
    dispatch_once(&onceToken, ^{
        dataBaseManager = [[TPOSDataBaseManager alloc] init];
    });
    return dataBaseManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _initDB];
    }
    return self;
}

- (void)_initDB {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    _dbFilePath = [documentsPath stringByAppendingPathComponent:@"test.sqlite"];
}

- (FMDatabaseQueue *)dataBaseQueue {
    return [FMDatabaseQueue databaseQueueWithPath:_dbFilePath];
}

@end
