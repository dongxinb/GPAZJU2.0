//
//  GZZJUWLANViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-12.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZZJUWLANViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <ASIFormDataRequest.h>
#import <ASIHTTPRequest.h>
#import <JDStatusBarNotification.h>

@interface GZZJUWLANViewController ()<UIAlertViewDelegate>

@end

@implementation GZZJUWLANViewController
@synthesize wifiName, wifiPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    wifiName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiUsername"];
    wifiPassword.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifiPassword"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)closePress:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPress:(UIButton *)sender
{
    if ([[self getWifiSSID]isEqualToString:@"ZJUWLAN"]) {
        if ([self isConnectionAvailable] == FALSE) {
            if ([wifiName.text length] == 0) {
                [self showNotification:@"error" andMessage:@"请输入用户名"];
            }else if ([wifiPassword.text length] == 0) {
                [self showNotification:@"error" andMessage:@"请输入密码"];
            }else {
                NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/cgi-bin/srun_portal"];
                ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
                [requestForm setPostValue:wifiName.text forKey:@"username"];
                [requestForm setPostValue:wifiPassword.text forKey:@"password"];
                [requestForm setPostValue:@"2" forKey:@"type"];
                [requestForm setPostValue:@"login" forKey:@"action"];
                [requestForm setPostValue:@"1" forKey:@"local_auth"];
                [requestForm setPostValue:@"1" forKey:@"is_ldap"];
                [requestForm setPostValue:@"5" forKey:@"ac_id"];
                [requestForm setDelegate:self];
                [requestForm setDidFinishSelector:@selector(wifiLoginSuccess:)];
                [requestForm setDidFailSelector:@selector(requestError:)];
                [requestForm startAsynchronous];
                //[requestForm setDidFailSelector:@selector(requestError:)];
            }
            
            
        } else {
            [self showNotification:@"success" andMessage:@"已可以访问网络. :)"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else {
        [self showNotification:@"error" andMessage:@"未连接至ZJUWLAN"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)wifiLoginSuccess:(ASIFormDataRequest *)requestForm
{
    NSLog(@"%@",requestForm.responseString);
    if ([requestForm.responseString isEqualToString:@"online_num_error"]) {
        NSLog(@"已在线");
        [[NSUserDefaults standardUserDefaults]setObject:wifiName.text forKey:@"wifiUsername"];
        [[NSUserDefaults standardUserDefaults]setObject:wifiPassword.text forKey:@"wifiPassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self isOnline];
        return;
    }
    if ([requestForm.responseString isEqualToString:@"password_error"]) {
        NSLog(@"密码错误！");
        [self showNotification:@"error" andMessage:@"账号或者密码错了吧？"];
        return;
    }
    NSRange range = [requestForm.responseString rangeOfString:@"login_ok"];
    if (range.location != NSNotFound) {
        NSLog(@"登录成功！");
        [[NSUserDefaults standardUserDefaults]setObject:wifiName.text forKey:@"wifiUsername"];
        [[NSUserDefaults standardUserDefaults]setObject:wifiPassword.text forKey:@"wifiPassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self showNotification:@"success" andMessage:@"登录成功啦！:)"];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    range = [requestForm.responseString rangeOfString:@"ip"];
    if (range.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"IP异常，请断开WI-FI后重新连接。 :("];
        return;
    }
}

- (void)isOnline
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ZJUWLAN" message:@"您的账号已在线，是否无情地将其踢下线？" delegate:self cancelButtonTitle:@"不要" otherButtonTitles:@"要", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/rad_online.php"];
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [requestForm setPostValue:wifiName.text forKey:@"username"];
        [requestForm setPostValue:wifiPassword.text forKey:@"password"];
        [requestForm setPostValue:@"auto_dm" forKey:@"action"];
        [requestForm setDelegate:self];
        [requestForm setDidFinishSelector:@selector(reLogin:)];
        [requestForm setDidFailSelector:@selector(requestError:)];
        [requestForm startAsynchronous];
    }
}

- (void)reLogin: (ASIFormDataRequest *)response
{
    NSLog(@"reLogin");
    NSString *urlString = [NSString stringWithFormat:@"https://net.zju.edu.cn/cgi-bin/srun_portal"];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:wifiName.text forKey:@"username"];
    [requestForm setPostValue:wifiPassword.text forKey:@"password"];
    [requestForm setPostValue:@"2" forKey:@"type"];
    [requestForm setPostValue:@"login" forKey:@"action"];
    [requestForm setPostValue:@"1" forKey:@"local_auth"];
    [requestForm setPostValue:@"1" forKey:@"is_ldap"];
    [requestForm setPostValue:@"5" forKey:@"ac_id"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(reLoginAlertSuccess:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)reLoginAlertSuccess:(ASIFormDataRequest *)requestForm
{
    //NSLog(@"reLoginAlertSuccess");
    //NSLog(@"1212%@",requestForm.responseString);
    NSRange range = [requestForm.responseString rangeOfString:@"login_ok"];
    NSRange range2 = [requestForm.responseString rangeOfString:@"ip"];
    if (range.location != NSNotFound) {
        [self showNotification:@"success" andMessage:@"登录成功啦！:)"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (range2.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"IP异常，请断开WI-FI后重新连接。"];
    }else{
        [self showNotification:@"error" andMessage:@"未知错误. :("];
    }
    
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
//    [self alertShow:@"网络连接错误! BAD"];
    [self showNotification:@"error" andMessage:@"网络连接错误! :("];
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
    [request setTimeOutSeconds:1.];
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

- (void)showNotification:(NSString *)para andMessage:(NSString *)message
{
    if ([para isEqualToString:@"warning"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:1.5 styleName:JDStatusBarStyleWarning];
    }else if ([para isEqualToString:@"error"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:2. styleName:JDStatusBarStyleError];
    }else if ([para isEqualToString:@"success"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
    }else if ([para isEqualToString:@"normal"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:2. styleName:JDStatusBarStyleDefault];
    }else if ([para isEqualToString:@"process"]) {
        [JDStatusBarNotification showWithStatus:message styleName:JDStatusBarStyleDefault];
    }
}

@end
