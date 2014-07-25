//
//  GZGPADetailViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-3.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZGPADetailViewController.h"
#import "GZRateViewController.h"
#import <RNBlurModalView.h>
#import <AVOSCloud.h>
#import <JDStatusBarNotification.h>
#import "GZEvaluationDetailViewController.h"
//#import <BaiduSocialShare/BDSocialShareSDK.h>

@interface GZGPADetailViewController ()

@end

@implementation GZGPADetailViewController
@synthesize courseName, courseGPA;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)shareButton:(id)sender
{
    NSString *title = @"title";
    NSString *message = [NSString stringWithFormat:@"我在 %@ 课程中拿了 %@ 的绩点……", courseName.text, courseGPA.text];
    NSString *url = @"http://jwbinfosys.zju.edu.cn/default2.aspx";
    BDSocialShareContent *content = [BDSocialShareContent shareContentWithDescription:message url:url title:title];


    [BDSocialShareSDK showShareMenuWithShareContent:content menuStyle:BD_SOCIAL_SHARE_MENU_THEME_STYLE supportedInterfaceOrientations:UIInterfaceOrientationMaskAllButUpsideDown result:^(BD_SOCIAL_RESULT requestResult, NSString *platformType, id response, NSError *error) {
        if (requestResult == BD_SOCIAL_SUCCESS) {
            //分享成功的处理
        } else if (requestResult == BD_SOCIAL_CANCEL){
            //用户取消分享的处理
        } else if (requestResult == BD_SOCIAL_FAIL){
            //分享发生错误的处理
        }
    }];
    // start to share
}*/
- (IBAction)ratePress:(id)sender
{
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    NSDictionary *parameters = @{@"courseName": courseName.text, @"courseID":[_couseNumber.text substringWithRange:NSMakeRange(14, 8)]};
    [AVCloud callFunctionInBackground:@"course" withParameters:parameters block:^(id object, NSError *error) {
        if (error == nil) {
            GZEvaluationDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
            vc.courseName = courseName.text;
            vc.courseID = [_couseNumber.text substringWithRange:NSMakeRange(14, 8)];
            vc.title = @"详情";
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self showNotification:@"error" andMessage:@"连接错误."];
        }
    }];
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
