//
//  YCFrameAnimator.h
//  MultipleScorll
//
//  Created by xiaoyuan on 2016/12/17.
//  Copyright © 2016年 com.xunlei. All rights reserved.
//

#import <UIKit/UIKit.h>


//毫秒
typedef int MilliTime;

@interface UIImageView(YCFrameAnimator)

@property (nonatomic, strong, readonly) dispatch_queue_t _Nonnull queue;

- (UIImageView *_Nonnull)makeKeyFrameWithDuration:(MilliTime)duration content: (UIImage * _Nonnull)conetent complement:(void (^ _Nullable)(void))complement;

- (void)makeKeyFrameWithImages:(NSArray<UIImage *> *_Nonnull)images repeats:(BOOL)repeats time:(MilliTime (^ _Nonnull)(int index,UIImage *_Nonnull image))time complement:(BOOL (^ _Nonnull)(int index))complement;

/**
 *  @param imagePaths 要展示的图片列表绝对路径地址
 *  @param time 要展示的每帧图片的时长控制
 *  @param complement 每帧结束后的回调，返回值为YES直接继续播放，NO终止播放
 *  该方法是逐帧加载图片，且每帧在下帧展示前load在内存，提高了每帧播放时长的精度，也不用再考虑帧动画图片的内存过大问题。
 */
- (void)makeKeyFrameWithContentsOfFiles:(NSArray<NSString *> *_Nonnull)imagePaths time:(MilliTime (^ _Nonnull)(int index,UIImage *_Nonnull image))time complement:(BOOL (^ _Nonnull)(int index))complement;

@end
