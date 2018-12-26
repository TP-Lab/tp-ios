//
//  TPOSDiscoveryDao.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/8.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSBaseDao.h"

@class TPOSDiscoveryBanner;
@class TPOSApplicationModel;
@class TPOSArticleModel;

@interface TPOSDiscoveryDao : TPOSBaseDao

- (void)saveBanners:(NSArray<TPOSDiscoveryBanner *> *)banners;

- (void)saveApplications:(NSArray<TPOSApplicationModel *> *)applications;

- (void)saveArticleModels:(NSArray<TPOSArticleModel *> *)articleModels;

- (void)findAllBannersWithComplement:(void (^)(NSArray<TPOSDiscoveryBanner *> *banners))complement;

- (void)findAllApplicationsWithComplement:(void (^)(NSArray<TPOSApplicationModel *> *applicationModels))complement;

- (void)findAllArticleModelsWithComplement:(void (^)(NSArray<TPOSArticleModel *> *articleModels))complement;

@end
