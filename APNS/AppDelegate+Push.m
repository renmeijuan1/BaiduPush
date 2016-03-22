//
//  AppDelegate+Push.m
//  APNS
//
//  Created by xwy on 16/3/22.
//  Copyright © 2016年 MJ. All rights reserved.
//

#import "AppDelegate+Push.h"
#import "BPush.h"
#import "LNNotificationsUI.h"
#import <AudioToolbox/AudioToolbox.h>

static NSString * const BAIDU_KEY = @"UiC80VVGb6lfXBnm16zjvAzy";
static NSString * const SECRET_KEY = @"yaDZTNmGWx7Oi3DYdcMMh2sQnWvNnYCr";
#define kLNNotification                     @"kLNNotificationPush"
#define MessageNotification                 @"MessageNotification"

@implementation AppDelegate (Push)

- (void)baiduPush{
    
    NSLog(@"推送");
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

-(void)pushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    NSLog(@"推送设置");
#if DEBUG
    [BPush registerChannel:launchOptions apiKey:BAIDU_KEY pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
#else
    [BPush registerChannel:launchOptions apiKey:BAIDU_KEY pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
#endif
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    
    //给推送设置声音
    AudioServicesPlaySystemSound(1007);
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        
        //        //模拟系统通知
        //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        
        [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:kLNNotification name:@"Leo" icon:[UIImage imageNamed:@"Logo"]];
        LNNotification * notification = [LNNotification notificationWithMessage:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        notification.title = @"消息提示";
        [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:kLNNotification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageNotification object:nil];
    }
    
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {}];
}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"PUSH = %@",userInfo);
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        
    }
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

@end
