//
//  TPOSWalletDao.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSWalletDao.h"
#import "TPOSWalletModel.h"


@implementation TPOSWalletDao

- (instancetype)init {
    if (self = [super init]) {
        [self createTableIfNeed];
    }
    return self;
}

- (void)addWalletWithWalletModel:(TPOSWalletModel *)walletModel complement:(void (^)(BOOL success))complement {
    
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL *rollback) {
        
        BOOL updateCurrentWalletResult;
        BOOL addWalletResult;
        @try {
            FMResultSet *resultSet = [db executeQuery:@"select walletId from table_current_wallet"];
            NSString *sql;
            if (resultSet.next) {
                sql = @"update table_current_wallet set walletId = ?;";
            } else {
                sql = @"insert into table_current_wallet(walletId)VALUES(?);";
            }
            addWalletResult = [db executeUpdate:@"insert into table_wallet(address,walletId,info)VALUES(?,?,?);",walletModel.address,walletModel.walletId,[walletModel mj_JSONString]];
            updateCurrentWalletResult = [db executeUpdate:sql,walletModel.walletId];
            if (addWalletResult && updateCurrentWalletResult) {
                *rollback = NO;
            } else {
                *rollback = YES;
            }
        } @catch (NSException *exception) {
            *rollback = NO;
            [db rollback];
        } @finally {
            if(!*rollback) {
                [db commit];
            }
            [db close];
            if(complement) {
                complement(updateCurrentWalletResult && addWalletResult);
            }
        }
    }];
}

- (void)updateWalletWithWalletModel:(TPOSWalletModel *)walletModel complement:(void (^)(BOOL success))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"update table_wallet set address = ?,info = ? where walletId = ?;",walletModel.address,[walletModel mj_JSONString],walletModel.walletId];
        if (complement) {
            complement(result);
        }
    }];
}

- (void)deleteWalletWithAddress:(NSString *)address complement:(void (^)(BOOL success))complement {
    
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL *rollback) {
        BOOL deleteResult;
        BOOL updateResult;
        @try {
            deleteResult = [db executeUpdate:@"delete from table_wallet where address = ?;",address];
            if (deleteResult) {
                FMResultSet *resultSet = [db executeQuery:@"select * from table_wallet order by id desc limit 1;"];
                if (resultSet.next) {
                    NSString *walletId = [resultSet stringForColumn:@"walletId"];
                    updateResult = [db executeUpdate:@"update table_current_wallet set walletId = ?;", walletId];
                } else {
                    updateResult = [db executeUpdate:@"delete from table_current_wallet;"];
                }
                if (deleteResult && updateResult) {
                    *rollback = NO;
                } else {
                    *rollback = YES;
                }
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
            [db rollback];
        }
        @finally {
            if (!*rollback) {
                [db commit];
            }
            [db close];
            if (complement) {
                complement(updateResult && deleteResult);
            }
        }
    }];
}

-(void)findAllWithComplement:(void (^)(NSArray<TPOSWalletModel *> *walletModels))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *walletModels = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"select * from table_wallet;"];
        while (resultSet.next) {
            TPOSWalletModel *walletModel = [TPOSWalletModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
            [walletModels addObject:walletModel];
        }
        if (complement) {
            complement(walletModels);
        }
    }];
}

- (void)findWalletWithWalletId:(NSString *)walletId complement:(void (^)(TPOSWalletModel *walletModel))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:@"select * from table_wallet where walletId = ?;", walletId];
        TPOSWalletModel *walletModel;
        if (resultSet.next) {
            walletModel = [TPOSWalletModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
        }
        if (complement) {
            complement(walletModel);
        }
    }];
}

- (void)findCurrentWallet:(void (^)(TPOSWalletModel *walletModel))complement{
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db){
        FMResultSet *resultSet = [db executeQuery:@"select table_wallet.info from table_wallet, table_current_wallet where table_wallet.walletId = table_current_wallet.walletId;"];
        TPOSWalletModel *walletModel;
        if (resultSet.next) {
            walletModel = [TPOSWalletModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
        } else {
            FMResultSet *result = [db executeQuery:@"select * from table_wallet order by id desc limit 1;"];
            if (result.next) {
                walletModel = [TPOSWalletModel mj_objectWithKeyValues:[result stringForColumn:@"info"]];
            }
        }
        if (complement) {
            complement(walletModel);
        }
    }];
}

- (void) updateCurrentWalletID:(NSString *)walletId complement:(void (^)(BOOL success))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"update table_current_wallet set walletId = ?;", walletId];
        if (complement) {
            complement(result);
        }
    }];
}

- (void)createTableIfNeed {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"create table if not exists table_wallet (id integer primary key autoincrement, address text,walletId text,info text);";
        NSString *currentWalletSql = @"create table if not exists table_current_wallet (id integer primary key autoincrement, walletId text);";
        [db executeStatements:sql];
        [db executeStatements:currentWalletSql];
    }];
}

@end
