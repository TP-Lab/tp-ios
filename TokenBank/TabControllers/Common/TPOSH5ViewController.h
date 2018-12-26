//
//  TPOSH5ViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 11/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

typedef NS_ENUM(NSInteger, kH5ViewType) {
    kH5ViewTypeTerms,       //服务协议
    kH5ViewTypeHelp,        //帮助页面
    kH5ViewTypePrivacy,     //隐私
    kH5ViewTypeRelease      //版本
};

@interface TPOSH5ViewController : TPOSBaseViewController

//页面类型
@property (nonatomic, assign) kH5ViewType viewType;

/**
 *  标题名称
 */
@property (nonatomic, copy) NSString *titleString;
/**
 *  加载的html
 */
@property (nonatomic, copy) NSString *htmlString;
/**
 *  加载本地的html时的baseurl
 */
@property (nonatomic, strong) NSURL *basePathUrl;
/**
 *  加载的html
 */
@property (nonatomic, strong) NSData *htmlData;
/**
 *  加载的url 直接加载传入url
 */
@property (nonatomic, copy) NSString *urlString;
/**
 *  设置关闭按钮，默认是YES
 */
@property (nonatomic, assign) BOOL showCloseButton;

@end
