//
//  MJRefreshGifHeader+TPOS.m
//  TokenBank
//
//  Created by MarcusWoo on 12/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "MJRefreshGifHeader+TPOS.h"
#import <objc/runtime.h>

static NSString *colorTypeKey = @"colorTypeKey";

@implementation MJRefreshGifHeader_TPOS

- (void)endRefreshing {
    [self resetIdleStateImages:@(NO)];
    [super endRefreshing];
    [self performSelector:@selector(resetIdleStateImages:) withObject:@(YES) afterDelay:0.5f];
}

- (void)resetIdleStateImages:(NSNumber *)isStart {
    
    NSString *colorString = self.colorType == MJLoadingGifColorTypeGray ? @"gray" : @"colorful";
    NSString *pull = [NSString stringWithFormat:@"icon_loading_pull_%@",colorString];
    NSString *end = [NSString stringWithFormat:@"icon_loading_%@_end",colorString];
    
    [self setImages:@[[UIImage imageNamed:isStart.boolValue?pull:end]] forState:MJRefreshStateIdle];
}

- (MJLoadingGifColorType)colorType {
    return [objc_getAssociatedObject(self, &colorTypeKey) intValue];
}

- (void)setColorType:(MJLoadingGifColorType)colorType {
    objc_setAssociatedObject(self, &colorTypeKey, @(colorType), OBJC_ASSOCIATION_RETAIN);
}

@end
