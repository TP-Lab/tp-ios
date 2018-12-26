//
//  MJRefreshGifHeader+TPOS.h
//  TokenBank
//
//  Created by MarcusWoo on 12/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MJRefresh;

typedef NS_ENUM(NSInteger, MJLoadingGifColorType) {
    MJLoadingGifColorTypeGray = 0, //浅色
    MJLoadingGifColorTypeColorful = 1, //深色
};

@interface MJRefreshGifHeader_TPOS : MJRefreshGifHeader

@property (nonatomic, assign) MJLoadingGifColorType colorType;

@end
