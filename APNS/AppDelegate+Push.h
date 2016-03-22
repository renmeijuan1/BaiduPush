//
//  AppDelegate+Push.h
//  APNS
//
//  Created by xwy on 16/3/22.
//  Copyright © 2016年 MJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Push)

- (void)baiduPush;
- (void)pushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
