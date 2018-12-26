//
//  TPOSContext.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSContext.h"
#import "TPOSMacro.h"
#import "TPOSWalletDao.h"
#import "TPOSWalletModel.h"

@implementation TPOSContext

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TPOSContext *context;
    dispatch_once(&onceToken, ^{
        context = [[TPOSContext alloc] init];
        [[TPOSWalletDao new] findCurrentWallet:^(TPOSWalletModel *walletModel) {
            context.currentWallet = walletModel;
        }];
    });
    return context;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [self registerNotifications];
    }
    return self;
}
-(void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editWallet:) name:kEditWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatWallet:) name:kCreateWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteWallet:) name:kDeleteWalletNotification object:nil];
}

- (void)editWallet:(NSNotification *)note {
    if ([note.object isKindOfClass:TPOSWalletModel.class]) {
        _currentWallet = note.object;
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:_currentWallet];
    }
}

- (void)creatWallet:(NSNotification *)note {
    if ([note.object isKindOfClass:TPOSWalletModel.class]) {
        _currentWallet = note.object;
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:_currentWallet];
    }
}

- (void)deleteWallet:(NSNotification *)note {
    if ([note.object isKindOfClass:TPOSWalletModel.class]) {
        [[TPOSWalletDao new] findCurrentWallet:^(TPOSWalletModel *walletModel) {
            _currentWallet = walletModel;
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:_currentWallet];
    }
}

- (void)setCurrentWallet:(TPOSWalletModel *)currentWallet {
    if ([currentWallet isKindOfClass:TPOSWalletModel.class]) {
        _currentWallet = currentWallet;
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:_currentWallet];
    }
}

@end
