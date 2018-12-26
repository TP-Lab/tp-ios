//
//  TPOSShareView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/28.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"

typedef NS_ENUM(NSInteger,TPOSShareType){
    TPOSShareTypeWechatSession = 1, //微信好友
    TPOSShareTypeWechatTimeline,   //朋友圈
    TPOSShareTypeQQSession,   //QQ好友
};

@interface TPOSShareMenuView : TPOSAlertView

+ (void)showInView:(UIView *)view complement:(void (^)(TPOSShareType))complement;

@end
