//
//  AppDelegate.h
//  TokenBank
//
//  Created by MarcusWoo on 31/12/2017.
//  Copyright © 2017 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSTabBarController;
//@class TPOSBackupAlert;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TPOSTabBarController *tabbarController;
//@property (nonatomic, weak) TPOSBackupAlert *backupAlert;

@end

