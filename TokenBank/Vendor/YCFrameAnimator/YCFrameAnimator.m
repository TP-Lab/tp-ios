//
//  YCFrameAnimator.m
//  MultipleScorll
//
//  Created by xiaoyuan on 2016/12/17.
//  Copyright © 2016年 com.xunlei. All rights reserved.
//

#import "YCFrameAnimator.h"
#import <objc/runtime.h>
#import <sys/time.h>

@import Darwin.POSIX.sys.time;

static NSString *const queueKey = @"queueKey";
static NSString *const nexImageKey = @"nexImageKey";
static BOOL isCurrentQueue(dispatch_queue_t queue) {
    const char *lable = dispatch_queue_get_label(queue);
    NSString *lableStr = [NSString stringWithUTF8String:lable];
    return [@"com.animation.FrameAnimator" isEqualToString:lableStr];
}

static void dispatch_safe_async(dispatch_queue_t queue, dispatch_block_t block) {
    if (isCurrentQueue(queue)) {
        block();
    } else {
        dispatch_async(queue, block);
    }
}

@interface UIImageView()

//提前把下一张要展示的图片在内存里边load提高每帧的时间精度
@property (nonatomic, strong) UIImage *nextImage;

@end

@implementation UIImageView(YCFrameAnimator)

- (UIImageView *)makeKeyFrameWithDuration:(MilliTime)duration content:(UIImage *)conetent complement:(void (^)(void))complement {
    __weak typeof(self) weakSelf = self;
    dispatch_safe_async(self.queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            self.image = conetent;
        });
        struct timeval timeout = {0, duration*1000};
        select(0, NULL, NULL, NULL, &timeout);
        if (complement) complement();
    });
    return self;
}

- (UIImageView *)makeKeyFrameWithDuration:(MilliTime)duration nextContentFile:(NSString *)nextFileString complement:(void (^)(void))complement {
    __weak typeof(self) weakSelf = self;
    dispatch_safe_async(self.queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            self.image = self.nextImage;
            self.nextImage = [UIImage imageWithContentsOfFile:nextFileString];
        });
        int second = duration / 1000;  //s
        int mSencond = duration - (second * 1000);  //ms
        struct timeval timeout = {(int)second, (int)mSencond*1000};  //{s,us}
        select(0, NULL, NULL, NULL, &timeout);
        if (complement) complement();
    });
    return self;
}

- (UIImageView *)makeKeyFrameWithDuration:(MilliTime)duration content:(UIImage *)conetent {
    return [self makeKeyFrameWithDuration:duration content:conetent complement:nil];
}

- (void)makeKeyFrameWithImages:(NSArray<UIImage *> *_Nonnull)images repeats:(BOOL)repeats time:(MilliTime (^ _Nonnull)(int index,UIImage *_Nonnull image))time complement:(BOOL (^ _Nonnull)(int index))complement {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(self.queue, ^{
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!weakSelf) {
                *stop = YES;
                return;
            }
            __strong typeof(weakSelf) self = weakSelf;
            [self makeKeyFrameWithDuration:time((int)idx, obj) content:obj complement:^{
                BOOL continueNext = complement((int)idx);
                if (!continueNext) *stop = YES;
                return;
            }];
            if (idx == images.count - 1 && repeats) {
                [self makeKeyFrameWithImages:images repeats:repeats time:time complement:complement];
            }
        }];
    });
}

- (void)makeKeyFrameWithContentsOfFiles:(NSArray<NSString *> *_Nonnull)imagePaths time:(MilliTime (^ _Nonnull)(int index,UIImage *_Nonnull image))time complement:(BOOL (^ _Nonnull)(int index))complement {
    __weak typeof(self) weakSelf = self;
    self.nextImage = [UIImage imageWithContentsOfFile:imagePaths.firstObject];
//    if (!self.nextImage) return;
    NSInteger count = imagePaths.count;
    dispatch_async(self.queue, ^{
        __block NSString *nextFile = nil;
        [imagePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) self = weakSelf;
            if (idx+1 < count) {
                nextFile = imagePaths[idx + 1];
            } else {
                nextFile = nil;
            }
            [self makeKeyFrameWithDuration:time((int)idx, self.nextImage) nextContentFile:nextFile complement:^{
                BOOL continueNext = complement((int)idx);
                if (!continueNext) *stop = YES;
            }];
        }];
    });
}

- (dispatch_queue_t)queue {
    dispatch_queue_t queue = objc_getAssociatedObject(self, &queueKey);
    if (!queue) {
        objc_setAssociatedObject(self, &queueKey, dispatch_queue_create("com.animation.FrameAnimator", NULL), OBJC_ASSOCIATION_RETAIN);
        queue = objc_getAssociatedObject(self, &queueKey);
    }
    return queue;
}

- (UIImage *)nextImage {
    return objc_getAssociatedObject(self, &nexImageKey);
}

- (void)setNextImage:(UIImage *)nextImage {
    objc_setAssociatedObject(self, &nexImageKey, nextImage, OBJC_ASSOCIATION_RETAIN);
}

@end
