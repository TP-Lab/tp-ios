//
//  TPOSDiscoveryDao.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/8.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSDiscoveryDao.h"
#import "TPOSDiscoveryBanner.h"
#import "TPOSApplicationModel.h"
#import "TPOSArticleModel.h"
#import "TPOSMacro.h"

@implementation TPOSDiscoveryDao

- (instancetype)init {
    if (self = [super init]) {
        [self createTableIfNeed];
    }
    return self;
}

- (void)saveBanners:(NSArray<TPOSDiscoveryBanner *> *)banners {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"delete from dis_banner where 1 = 1;"];
        [banners enumerateObjectsUsingBlock:^(TPOSDiscoveryBanner * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL r = [db executeUpdate:@"insert into dis_banner(bid,info)VALUES(?,?);",obj.bid,[obj mj_JSONString]];
            TPOSLog(@"ffffff-----%@",r?@"s":@"f");
        }];
    }];
}

- (void)saveApplications:(NSArray<TPOSApplicationModel *> *)applications {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"delete from dis_app where 1 = 1;"];
        [applications enumerateObjectsUsingBlock:^(TPOSApplicationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [db executeUpdate:@"insert into dis_app(bid,info)VALUES(?,?);",obj.bid,[obj mj_JSONString]];
        }];
    }];
}

- (void)saveArticleModels:(NSArray<TPOSArticleModel *> *)articleModels {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"delete from table_article where 1 = 1;"];
        [articleModels enumerateObjectsUsingBlock:^(TPOSArticleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [db executeUpdate:@"insert into table_article(bid,info)VALUES(?,?);",obj.bid,[obj mj_JSONString]];
        }];
    }];
}

- (void)findAllBannersWithComplement:(void (^)(NSArray<TPOSDiscoveryBanner *> *banners))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *banners = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"select * from dis_banner;"];
        while (resultSet.next) {
            TPOSDiscoveryBanner *banner = [TPOSDiscoveryBanner mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
            if (banner) {
                [banners addObject:banner];
            }
        }
        if (complement) {
            complement(banners);
        }
    }];
}

- (void)findAllApplicationsWithComplement:(void (^)(NSArray<TPOSApplicationModel *> *applicationModels))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *applicationModels = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"select * from dis_app;"];
        while (resultSet.next) {
            TPOSApplicationModel *applicationModel = [TPOSApplicationModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
            if (applicationModel) {
                [applicationModels addObject:applicationModel];
            }
        }
        if (complement) {
            complement(applicationModels);
        }
    }];
}

- (void)findAllArticleModelsWithComplement:(void (^)(NSArray<TPOSArticleModel *> *articleModels))complement {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *articleModels = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"select * from table_article;"];
        while (resultSet.next) {
            TPOSArticleModel *articleModel = [TPOSArticleModel mj_objectWithKeyValues:[resultSet stringForColumn:@"info"]];
            if (articleModel) {
                [articleModels addObject:articleModel];
            }
        }
        if (complement) {
            complement(articleModels);
        }
    }];
}

- (void)createTableIfNeed {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"create table if not exists dis_banner (id integer primary key autoincrement,bid text,info text);";
        [db executeStatements:sql];
    }];
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"create table if not exists dis_app (id integer primary key autoincrement, bid text,info text);";
        [db executeStatements:sql];
    }];
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"create table if not exists table_article (id integer primary key autoincrement,bid text,info text);";
        [db executeStatements:sql];
    }];
}

@end
