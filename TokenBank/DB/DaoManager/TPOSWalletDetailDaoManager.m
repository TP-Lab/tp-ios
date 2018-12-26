//
//  TPOSWalletDetailDaoManager.m
//  TokenBank
//
//  Created by MarcusWoo on 21/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSWalletDetailDaoManager.h"
#import "TPOSWalletDetailDao.h"
#import "TPOSTokenModel.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSWalletDetailDaoManager()
@property (nonatomic, strong) TPOSWalletDetailDao *detailDao;
@end

@implementation TPOSWalletDetailDaoManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TPOSWalletDetailDaoManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[TPOSWalletDetailDaoManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.detailDao = [[TPOSWalletDetailDao alloc] init];
    }
    return self;
}

- (void)updateWalletDetailModels:(NSArray<TPOSTokenModel *> *)detailModels {
    
    __weak typeof(self) weakSelf = self;
    [self.detailDao removeAllWithCompletion:^(BOOL success, FMDatabase * db) {
        for (TPOSTokenModel *model in detailModels) {
            [weakSelf.detailDao addWalletDetailInDB:db withModel:model completion:nil];
        }
    }];
}

- (void)deleteWalletDetailModels:(NSArray<TPOSTokenModel *> *)detailModels {
    
    for (TPOSTokenModel *detailModel in detailModels) {
        [self.detailDao deleteWalletWithAddress:detailModel.address completion:^(BOOL success) {
            if (!success) {
                TPOSLog([[TPOSLocalizedHelper standardHelper] stringWithKey:@"delete_fail"]);
            }
        }];
    }
}

- (void)findWalletDetailWithAddress:(NSString *)address
                          completion:(void (^)(NSArray<TPOSTokenModel *> *detailModels))completion {
    if (!address || address.length == 0) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    [self.detailDao findWalletDetailWithAddress:address completion:^(NSArray<TPOSTokenModel *> *detailModels, FMDatabase *db) {
        if (completion) {
            completion(detailModels);
        }
    }];
}

- (void)findAllWithCompletion:(void (^)(NSArray<TPOSTokenModel *> *detailModels))completion {
    [self.detailDao findAllWithCompletion:^(NSArray<TPOSTokenModel *> *detailModels) {
        if (completion) {
            completion(detailModels);
        }
    }];
}

@end
