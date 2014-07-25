//
//  GZPushViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-5.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZPushViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <JDStatusBarNotification.h>
#import <SSKeychain.h>

@interface GZPushViewController ()

@end

@implementation GZPushViewController
@synthesize pushStatus;

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
    [pushStatus addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO) {
        pushStatus.enabled = NO;
    }
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [pushStatus setEnabled:NO];
    [self showNotification:@"process" andMessage:@"正在检测推送状态"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO) {
        [self showNotification:@"error" andMessage:@"您还没有登录，请登录"];
        return ;
    }
    if ([deviceToken length] == 0) {
        [self showNotification:@"error" andMessage:@"您没有允许推送，请在设置->通知中心里允许GPA.ZJU推送。"];
    }else {
        AVQuery *query = [AVQuery queryWithClassName:@"studentPush"];
        [query whereKey:@"deviceToken" equalTo:deviceToken];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [self showNotification:@"success" andMessage:@"推送状态检测成功."];
                [pushStatus setEnabled:YES];
                if ([objects count] == 0) {
                    pushStatus.on = NO;
                }else {
                    pushStatus.on = YES;
                }
            }else {
                // Log details of the failure
                [self showNotification:@"error" andMessage:@"网络连接失败."];
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
}

- (void)switchChanged:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    //[mySwitch setOn:mySwitch.isOn animated:YES];
    
    
    [self showNotification:@"process" andMessage:@"正在设置中……"];
    if (mySwitch.isOn) {
        AVObject *stu = [AVObject objectWithClassName:@"studentPush"];
        NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [SSKeychain passwordForService:@"com.dongxinbao.GPAZJU" account:xuehao];
        [stu setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] forKey:@"deviceToken"];
        [stu setObject:password forKey:@"password"];
        [stu setObject:xuehao forKey:@"stuID"];
        [stu saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self showNotification:@"success" andMessage:@"推送开启成功!"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Push"];
                [mySwitch setOn:YES animated:YES];
            }else{
                [self showNotification:@"error" andMessage:@"推送开启失败，请检查网络设置."];
                [mySwitch setOn:NO animated:YES];
            }
        }];
    }else {
        AVQuery *query=[AVQuery queryWithClassName:@"studentPush"];
        [query whereKey:@"deviceToken" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //[object deleteInBackground];
                for (AVObject *object in objects) {
                    [object deleteEventually];
                }
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Push"];
                [mySwitch setOn:NO animated:YES];
                [self showNotification:@"warning" andMessage:@"推送关闭成功!"];
            } else {
                [self showNotification:@"error" andMessage:@"推送关闭失败，请检查网络设置."];
                [mySwitch setOn:YES animated:YES];
            }
        }];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
