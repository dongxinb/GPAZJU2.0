//
//  GZExamDetailViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-3.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZExamDetailViewController.h"
#import <ASIFormDataRequest.h>
#import <ASIHTTPRequest.h>
#import <SSKeychain.h>
#import <JDStatusBarNotification.h>
#import "GZRateViewController.h"
#import <RNBlurModalView.h>
#import "GZEvaluationDetailViewController.h"


#define GB2312_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
#define LOGIN_SITE_STRING @"http://jwbinfosys.zju.edu.cn/default2.aspx"

@interface GZExamDetailViewController ()

@end

@implementation GZExamDetailViewController

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

- (IBAction)ratePress:(id)sender
{
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    NSDictionary *parameters = @{@"courseName": _courseName.text, @"courseID":[_courseNumber.text substringWithRange:NSMakeRange(14, 8)]};
    [AVCloud callFunctionInBackground:@"course" withParameters:parameters block:^(id object, NSError *error) {
        if (error == nil) {
            GZEvaluationDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
            vc.courseName = _courseName.text;
            vc.courseID = [_courseNumber.text substringWithRange:NSMakeRange(14, 8)];
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


- (IBAction)checkSubmission:(UIButton *)sender
{
    [self loginFirst];
}

- (void)loginFirst
{
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [SSKeychain passwordForService:@"com.dongxinbao.GPAZJU" account:xuehao];
    NSURL *url = [NSURL URLWithString:LOGIN_SITE_STRING];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    //requestForm.useCookiePersistence = NO;
    [requestForm setPostValue:@"Button1" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"" forKey:@"__EVENTARGUMENT"];
    [requestForm setPostValue:@"dDwxNTc0MzA5MTU4Ozs+RGE82+DpWCQpVjFtEpHZ1UJYg8w=" forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:xuehao forKey:@"TextBox1"];
    [requestForm setPostValue:password forKey:@"TextBox2"];
    [requestForm setPostValue:@"学生" forKey:@"RadioButtonList1"];
    [requestForm setPostValue:@"submit" forKey:@"_eventId"];
    [requestForm setPostValue:@"" forKey:@"Text1"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(loginFinished:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm setDefaultResponseEncoding:GB2312_ENCODING];
    [requestForm startAsynchronous];
    
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
}

- (void)loginFinished:(ASIFormDataRequest *)requestForm
{
    NSString *responseString = [requestForm responseString];
    //NSLog(@"%@", responseString);
    NSRange range1 = [responseString rangeOfString:@"用户名不存在"];
    NSRange range2 = [responseString rangeOfString:@"密码错误"];
    NSRange range3 = [responseString rangeOfString:@"控制学号访问"];
    NSRange range4 = [responseString rangeOfString:@"学籍"];
    NSRange range5 = [responseString rangeOfString:@"欠费"];
    NSRange range6 = [responseString rangeOfString:@"个人信息"];
    NSRange range7 = [responseString rangeOfString:@"mobile.html"];
    if (range1.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"学号不存在啊! :("];
    }else if (range2.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"密码错了，快检查一下密码! :("];
    }else if (range3.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"学校正控制学号访问呢,等一下吧! :("];
    }else if (range4.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"学籍状态不正确，快去检查一下! :("];
    }else if (range5.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"你是不是欠费了? :("];
    }else if (range6.location != NSNotFound) {
        NSLog(@"Login Success!");
        //        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        //        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"statistics"];
        [self checkUpdate];
    }else if (range7.location != NSNotFound){
        [self showNotification:@"error" andMessage:@"ZJUWLAN还没登录呢! :("];
    }else {
        [self showNotification:@"error" andMessage:@"我也不知道哪里出错了... :("];
    }
}

- (void)checkUpdate
{
    NSString *temp = [self.courseNumber.text substringWithRange:NSMakeRange(0, 22)];
    NSString *stuID = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xsxjs.aspx?xkkh=T%@%@", temp, stuID]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(checkUpdateFinished:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDefaultResponseEncoding:GB2312_ENCODING];
    [request startAsynchronous];
}

- (void)checkUpdateFinished:(ASIHTTPRequest *)request
{
    NSString *result = [request responseString];
    NSRange range = [result rangeOfString:@"checked=\"checked"];
    if (range.location != NSNotFound) {
        [self showNotification:@"normal" andMessage:@"老师还没有提交成绩呢～"];
        self.submissionCheckResult.text = @"未提交…";
    }else {
        [self showNotification:@"success" andMessage:@"老师已经提交成绩啦，三天之内你应该能看到噢～"];
        self.submissionCheckResult.text = @"已提交!";
    }
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
    NSLog(@"%@", [requestForm error]);
    [self showNotification:@"error" andMessage:@"连接网络失败! :("];
    //[examQueue cancelAllOperations];
    //    [self setIndexOfExam];
    //    [self setActiveContentIndex:0];
    //    [self setActiveTabIndex:0];
}

@end
