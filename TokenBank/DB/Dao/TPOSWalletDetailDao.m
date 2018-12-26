//
//  TPOSWalletDetailDao.m
//  TokenBank
//
//  Created by MarcusWoo on 21/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSWalletDetailDao.h"
#import "TPOSTokenModel.h"

@implementation TPOSWalletDetailDao

- (instancetype)init {
    if (self = [super init]) {
        [self createTableIfNeed];
    }
    return self;
}

- (void)addWalletDetailWithModel:(TPOSTokenModel *)detailModel
                      completion:(void (^)(BOOL success))completion {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"insert into table_awalletDetail(address,info)VALUES(?,?);",detailModel.address,[detailModel mj_JSONString]];
        if (completion) {
            completion(result);
        }
    }];
}

- (void)addWalletDetailInDB:(FMDatabase *)db
                  withModel:(TPOSTokenModel *)detailModel
                 completion:(void (^)(BOOL success))completion {
    BOOL result = [db executeUpdate:@"insert into table_awalletDetail(address,info)VALUES(?,?);",detailModel.address,[detailModel mj_JSONString]];
    if (completion) {
        completion(result);
    }
}

- (void)updateWalletDetailWithModel:(TPOSTokenModel *)detailModel
                         completion:(void (^)(BOOL success))completion {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"update table_awalletDetail set info = ? where address = ?;",[detailModel mj_JSONString],detailModel.address];
        if (completion) {
            completion(result);
        }
    }];
}

- (void)updateWalletDetailInDB:(FMDatabase *)db
                     withModel:(TPOSTokenModel *)detailModel
                    completion:(void (^)(BOOL success))completion {
    BOOL result = [db executeUpdate:@"update table_awalletDetail set info = ? where address = ?;",[detailModel mj_JSONString],detailModel.hid];
    if (completion) {
        completion(result);
    }
}

- (void)deleteWalletWithAddress:(NSString *)address completion:(void (^)(BOOL success))completion {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"delete from table_awalletDetail where address = ?;",address];
        if (completion) {
            completion(result);
        }
    }];
}

- (void)removeAllWithCompletion:(void (^)(BOOL success, FMDatabase * db))completion {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"delete from table_awalletDetail where 1 = 1;"];
        if (completion) {
            completion(result,db);
        }
    }];
}

- (void)findAllWithCompletion:(void (^)(NSArray<TPOSTokenModel *> *detailModels))completion {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *detailModels = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"select * from table_awalletDetail;"];
        while (resultSet.next) {
            TPOSTokenModel *detailModel = [TPOSTokenModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
            if (detailModel) {
                [detailModels addObject:detailModel];
            }
        }
        if (completion) {
            completion(detailModels);
        }
    }];
}

- (void)findWalletDetailWithAddress:(NSString *)address
                          completion:(void (^)(NSArray<TPOSTokenModel *> *detailModels, FMDatabase * db))completion {
    
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:@"select * from table_awalletDetail where address = ?;", address];
        
        NSMutableArray *arr = [NSMutableArray array];
        while (resultSet.next) {
            TPOSTokenModel *detailModel = [TPOSTokenModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
            if (detailModel) {
                [arr addObject:detailModel];
            }
        }
        if (completion) {
            completion(arr, db);
        }
    }];
}

- (void)createTableIfNeed {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"create table if not exists table_awalletDetail (id integer primary key autoincrement, address text, info text);";
        [db executeStatements:sql];
    }];
}

@end
