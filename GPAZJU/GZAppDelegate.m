//
//  GZAppDelegate.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-25.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "GZGPAViewController.h"
#import <ASIHTTPRequest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "GZZJUWLANViewController.h"
#import <Appirater.h>

@implementation GZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [AVOSCloud setApplicationId:@""
                      clientKey:@""];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVAnalytics setCrashReportEnabled:YES];

    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            //[currentInstallation saveEventually];
            [currentInstallation saveInBackground];
        }
        //[self handleRemoteNotification:application userInfo:userInfo];
    }
    
    [Appirater setAppId:@"717203939"];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];

    
    
//    NSArray *platforms = [NSArray arrayWithObjects:kBD_SOCIAL_SHARE_PLATFORM_SINAWEIBO,kBD_SOCIAL_SHARE_PLATFORM_QQWEIBO,kBD_SOCIAL_SHARE_PLATFORM_QQZONE,kBD_SOCIAL_SHARE_PLATFORM_RENREN,
//                          kBD_SOCIAL_SHARE_PLATFORM_EMAIL,
//                          kBD_SOCIAL_SHARE_PLATFORM_SMS,nil];
//    //初始化社交组件,supportPlatform 参数可以是 nil,代表支持所有平台
//    [BDSocialShareSDK registerApiKey:@"LpoKncF7h7I4RLyyOKfHx2U4" andSupportPlatforms:platforms];
    
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    [[NSUserDefaults standardUserDefaults]setObject:currentInstallation.deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%@", currentInstallation.deviceToken);
    
}

//Receive a push while app is running.
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [AVPush handlePush:userInfo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    NSString *str = [self getWifiSSID];
    if ([str isEqualToString:@"ZJUWLAN"])
        if ([self isConnectionAvailable] == NO) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GZZJUWLANViewController *vc = [sb instantiateViewControllerWithIdentifier:@"zjuwlan"];
//            vc.wifiName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifiUsername"];
//            vc.wifiPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifiPassword"];
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if(viewController.tabBarItem.tag == 1){
//        viewController = [[GZGPAViewController alloc] init];
//        //UINavigationController *navigationctr = (UINavigationController *)viewController;
////        SecondViewController *secvc = (SecondViewController *)navigationctr.;
////        [secvc setDataSource];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)getWifiSSID
{
    NSString *ssid = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];
        }
    }
    NSLog(@"%@",ssid);
    return ssid;
}

- (BOOL) isConnectionAvailable
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:0.5];
    [request startSynchronous];
    NSError *error = [request error];
    if (error) {
        return FALSE;
    }
    if ([request.responseString rangeOfString:@"baike"].location != NSNotFound) {
        return TRUE;
    }
    return FALSE;
}

@end
