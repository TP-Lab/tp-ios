//
//  TPOSCommonInfoManager.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/31.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSCommonInfoManager.h"
#import "TPOSApiClient.h"
#import "TPOSMacro.h"
#import "NSObject+TPOS.h"
#import "TPOSBlockChainModel.h"
#import "TPOSRecommendGasModel.h"

@interface TPOSCommonInfoManager()
@property (nonatomic, strong) NSArray *allChains;
@end

@implementation TPOSCommonInfoManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TPOSCommonInfoManager *commonInfoManager;
    dispatch_once(&onceToken, ^{
        commonInfoManager = [[TPOSCommonInfoManager alloc] init];
    });
    return commonInfoManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotification) name:kLocalizedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)languageChangeNotification {
    [self storeAllBlockchainInfos];
}

- (void)getAllBlockChainInfoWithSuccess:(void (^)(NSArray<TPOSBlockChainModel *> *blockChains))success fail:(void (^)(NSError *error))fail {
    if (success) {
       NSMutableArray *array = [NSMutableArray array];
        TPOSBlockChainModel *model = [TPOSBlockChainModel new];
        model.hid = swtcChain;
        model.desc = @"井通链体系";
        model.title = @"井通";
        model.status = @"0";
        model.default_token = @"swt";
        model.icon_url = @"http://state.jingtum.com/favicon.ico";
        model.create_time = @"2018-12-13T22:11:20Z";
        [array addObject: model];
        success(array);
    }
}

- (void)storeAllBlockchainInfos {
    
    __weak typeof(self) weakSelf = self;
    [self getAllBlockChainInfoWithSuccess:^(NSArray<TPOSBlockChainModel *> *blockChains) {
        weakSelf.allChains = blockChains;
    } fail:nil];
}

- (void)storeAllBlockchainInfos:(NSArray<TPOSBlockChainModel *> *)blockChains {
    self.allChains = blockChains;
}

- (NSArray<TPOSBlockChainModel *> *)allBlockchains {
    return self.allChains;
}

@end
