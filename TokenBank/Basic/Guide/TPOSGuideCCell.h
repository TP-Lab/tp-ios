//
//  TPOSGuideCCell.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOSGuideModel: NSObject

@property (nonatomic, copy) NSString *normalImageName;
@property (nonatomic, copy) NSString *endImageName;
@property (nonatomic, copy) NSString *giftImageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@end

@interface TPOSGuideCCell : UICollectionViewCell

- (void)updateWithGuideModel:(TPOSGuideModel *)guideModel;

- (void)startPlayGif;
-(void)stopPlayGif;

@end
