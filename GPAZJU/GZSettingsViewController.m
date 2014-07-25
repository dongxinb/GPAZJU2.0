//
//  GZSettingsViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-25.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZSettingsViewController.h"
#import <LFGlassView.h>
#import <QuartzCore/QuartzCore.h>
#import <JDStatusBarNotification.h>
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <TFHpple.h>
#import <SSKeychain.h>
#import "UIButton+Bootstrap.h"
#import <AVOSCloud/AVOSCloud.h>
#import "GZGPAViewController.h"

//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:19./255. green:133./255. blue:254./255. alpha:1.]
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:52./255. green:152./255. blue:219./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:36./255. green:70./255. blue:105./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:75./255. green:186./255. blue:228./255. alpha:1.]
#define LOGIN_VIEW_HEIGHT 188
#define LOGIN_SITE_STRING @"http://jwbinfosys.zju.edu.cn/default2.aspx"
#define GET_NAME_STRING @"http://jwbinfosys.zju.edu.cn/xs_kcth.aspx"
#define GB2312_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

@interface GZSettingsViewController ()

@end

@implementation GZSettingsViewController
@synthesize profileBtn;
bool didLogin;//是否登录

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
    
    [_pushSet defaultStyle];
//    [_pushSet setBackgroundColor:[UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1]];
    [_clearSet defaultStyle];
//    [_clearSet setBackgroundColor:[UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:0.8]];
    [_bugSet defaultStyle];
//    [_bugSet setBackgroundColor:[UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:0.6]];
    
    [_aboutSet defaultStyle];
    [_supportSet defaultStyle];
//    [_supportSet setBackgroundColor:[UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:0.8]];
    [_judgeSet defaultStyle];
//    [_judgeSet setBackgroundColor:[UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:0.6]];

    
    
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.password.delegate = self;
    self.username.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView= NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    didLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"];
    self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.xuehao.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.name.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    self.loginView.frame = CGRectMake(84, 64 - LOGIN_VIEW_HEIGHT, 236, 0);
    self.loginView.hidden = YES;
    self.signInView.alpha = 0.;
    self.signInView.hidden = YES;
    
    self.signOutView.alpha = 0.;
    self.signOutView.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilePress:) name:@"login" object:nil];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO) {
        [self profilePress:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clearPress:(UIButton *)sender
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        [self showNotification:@"error" andMessage:@"请你先注销账户，然后再执行清除数据。"];
    }else {
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showNotification:@"success" andMessage:@"清除数据成功。"];
    }
    
}

- (IBAction)signInButton:(UIButton *)sender
{
    sender.enabled = NO;
    
    NSURL *url = [NSURL URLWithString:LOGIN_SITE_STRING];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    //requestForm.useCookiePersistence = NO;
    [requestForm setPostValue:@"Button1" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"" forKey:@"__EVENTARGUMENT"];
    [requestForm setPostValue:@"dDwxNTc0MzA5MTU4Ozs+RGE82+DpWCQpVjFtEpHZ1UJYg8w=" forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:self.username.text forKey:@"TextBox1"];
    [requestForm setPostValue:self.password.text forKey:@"TextBox2"];
    [requestForm setPostValue:@"学生" forKey:@"RadioButtonList1"];
    [requestForm setPostValue:@"submit" forKey:@"_eventId"];
    [requestForm setPostValue:@"" forKey:@"Text1"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(signInFinished:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    //[requestForm setResponseEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    //[requestForm setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    //NSLog(@"%@", requestForm.requestHeaders);
    [requestForm startAsynchronous];
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)signInFinished:(ASIFormDataRequest *)requestForm
{
//    NSString *responseString = [requestForm responseString];
    NSString *responseString = [[NSString alloc] initWithData:[requestForm responseData] encoding:GB2312_ENCODING];
    //NSLog(@"%@", responseString);
    if ([responseString length] == 0) {
        [self showNotification:@"error" andMessage:@"教务网出问题了？ :("];
        UIButton *button = (UIButton *)[self.view viewWithTag:3];
        button.enabled = YES;
        return;
    }
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
        
        //NSMutableArray *temp = [ASIFormDataRequest sessionCookies];
        //[ASIFormDataRequest setSessionCookies:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?xh=%@", GET_NAME_STRING, self.username.text]];
        //NSLog(@"%@", url);
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];

        [request setDefaultResponseEncoding:kCFStringEncodingUTF8];
        [request setResponseEncoding:kCFStringEncodingUTF8];
        //[request setUseCookiePersistence:NO];
        //[request setRequestCookies:[ASIFormDataRequest sessionCookies]];
        [request setDidFinishSelector:@selector(getNameFinished:)];
        [request setDidFailSelector:@selector(requestError:)];
        [request setDelegate:self];
        [request startAsynchronous];
    }else if (range7.location != NSNotFound){
        [self showNotification:@"error" andMessage:@"ZJUWLAN还没登录呢! :("];
    }else {
        [self showNotification:@"error" andMessage:@"我也不知道哪里出错了... :("];
    }
    if (range6.location == NSNotFound) {
        UIButton *button = (UIButton *)[self.view viewWithTag:3];
        button.enabled = YES;
    }
}

- (void)getNameFinished:(ASIHTTPRequest *)request
{
    [self showNotification:@"success" andMessage:@"登录成功啦! :)"];
    didLogin = YES;
    self.xuehao.text = self.username.text;
//    NSData *data = [request responseData];
//    NSLog(@"%@", [request responseString]);
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    NSLog(@"%@", temp);
    NSRange range1 = [temp rangeOfString:@"xm\">"];
    NSString *name = @"";
    if (range1.location != NSNotFound) {
        temp = [temp substringFromIndex:range1.location + range1.length];
        range1 = [temp rangeOfString:@"</span>"];
        if (range1.location != NSNotFound)
            name = [temp substringToIndex:range1.location];
    }
//    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
//    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
//    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
//    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
//    NSArray *elements = [parser searchWithXPathQuery:@"//span[@id='lblxm']"];
//    
//    TFHppleElement *nameObject = [elements objectAtIndex:0];

//    NSString *name = [[nameObject firstChild] content];
//    NSString *name = @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
    self.name.text = name;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didLogin"];
    didLogin = YES;
    [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //save the password in the keyChain
    [SSKeychain setPassword:self.password.text forService:@"com.dongxinbao.GPAZJU" account:self.username.text];

    //enabel the signInButton
    UIButton *button = (UIButton *)[self.view viewWithTag:3];
    button.enabled = YES;
    
    //change the signInView into signOutView
    self.signOutView.hidden = NO;
    [UIView animateWithDuration:0.7 animations:^{
        self.signOutView.alpha = 1.;
        self.signInView.alpha = 0.;
    } completion:^(BOOL finished) {
        self.signInView.hidden = YES;
        //            self.signOutView.hidden = NO;
        //            [UIView animateWithDuration:0.2 animations:^{
        //                self.signOutView.alpha = 1.;
        //            }];
    }];
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
    NSLog(@"%@", requestForm.error);
    [self showNotification:@"error" andMessage:@"连接网络失败! :("];
    UIButton *button = (UIButton *)[self.view viewWithTag:3];
    button.enabled = YES;
    button = (UIButton *)[self.view viewWithTag:4];
    button.enabled = YES;
}


- (IBAction)signOutButton:(UIButton *)sender
{
    sender.enabled = NO;
    [self showNotification:@"process" andMessage:@"正在注销…… :("];

    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *wifiName = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifiUsername"];
    NSString *wifiPass = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifiPassword"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Push"]) {
        AVQuery *query = [AVQuery queryWithClassName:@"studentPush"];
        [query whereKey:@"deviceToken" equalTo:deviceToken];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count] == 0) {
                    [ASIFormDataRequest setSessionCookies:nil];
                    self.signInView.hidden = NO;
                    [UIView animateWithDuration:0.7 animations:^{
                        self.signOutView.alpha = 0.;
                        self.signInView.alpha = 1.;
                    } completion:^(BOOL finished) {
                        self.signOutView.hidden = YES;
                    }];
                    didLogin = NO;
                    sender.enabled = YES;
                    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                    [[NSUserDefaults standardUserDefaults] setObject:self.xuehao.text forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:wifiName forKey:@"wifiUsername"];
                    [[NSUserDefaults standardUserDefaults] setObject:wifiPass forKey:@"wifiPassword"];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self showNotification:@"normal" andMessage:@"不开心的注销了…… :("];
                    [SSKeychain deletePasswordForService:@"com.dongxinbao.GPAZJU" account:self.xuehao.text];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"resignViewController" object:self];
                    


                }else {
                    [[objects firstObject] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            [ASIFormDataRequest setSessionCookies:nil];
                            self.signInView.hidden = NO;
                            [UIView animateWithDuration:0.7 animations:^{
                                self.signOutView.alpha = 0.;
                                self.signInView.alpha = 1.;
                            } completion:^(BOOL finished) {
                                self.signOutView.hidden = YES;
                            }];
                            didLogin = NO;
                            sender.enabled = YES;
                            [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                            [[NSUserDefaults standardUserDefaults] setObject:self.xuehao.text forKey:@"username"];
                            [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:wifiName forKey:@"wifiUsername"];
                            [[NSUserDefaults standardUserDefaults] setObject:wifiPass forKey:@"wifiPassword"];
                            
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didLogin"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self showNotification:@"normal" andMessage:@"不开心的注销了…… :("];
                            [SSKeychain deletePasswordForService:@"com.dongxinbao.GPAZJU" account:self.xuehao.text];

                            [[NSNotificationCenter defaultCenter] postNotificationName:@"resignViewController" object:self];
                        }else {
                            [self showNotification:@"error" andMessage:@"注销失败，请检查网络设置… :("];
                            sender.enabled = YES;
                        }
                    }];
                }
            }else {
                // Log details of the failure
                [self showNotification:@"error" andMessage:@"注销失败，请检查网络设置… :("];
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                sender.enabled = YES;
            }
        }];
        //handle push.
        //remember set sender.enabled = YES
    }else {
        [ASIFormDataRequest setSessionCookies:nil];
        self.signInView.hidden = NO;
        [UIView animateWithDuration:0.7 animations:^{
            self.signOutView.alpha = 0.;
            self.signInView.alpha = 1.;
        } completion:^(BOOL finished) {
            self.signOutView.hidden = YES;
        }];
        didLogin = NO;
        sender.enabled = YES;
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] setObject:self.xuehao.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
        
        [[NSUserDefaults standardUserDefaults] setObject:wifiName forKey:@"wifiUsername"];
        [[NSUserDefaults standardUserDefaults] setObject:wifiPass forKey:@"wifiPassword"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showNotification:@"normal" andMessage:@"不开心的注销了…… :("];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resignViewController" object:self];
        //NSLog(@"%@", [SSKeychain passwordForService:@"com.dongxinbao.GPAZJU" account:self.xuehao.text]);
        [SSKeychain deletePasswordForService:@"com.dongxinbao.GPAZJU" account:self.xuehao.text];
    }
    
}

- (IBAction)judgePress:(UIButton *)sender
{
    //connect the comment page.
    NSString*str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id717203939"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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

- (IBAction)profilePress:(UIButton *)sender
{
    profileBtn.enabled = NO;
    BOOL didLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"];
    BOOL open = self.loginView.frame.origin.y > 0;
    UIView *tempView = didLogin? self.signOutView: self.signInView;
    if (!open) {
        self.loginView.hidden = NO;
        if ([self.password.text length] < 6) {
            ((UIButton *)([self.view viewWithTag:3])).enabled = NO;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.loginView.frame = CGRectMake(84, 64, 236, LOGIN_VIEW_HEIGHT);
            
        } completion:^(BOOL finished) {
            tempView.hidden = NO;
            [UIView animateWithDuration:0.1 animations:^{
                tempView.alpha = 1.;
            } completion:^(BOOL finished) {
                //something
                profileBtn.enabled = YES;
            }];
        }];
    }else {
        [UIView animateWithDuration:0.1 animations:^{
            tempView.alpha = 0.;
        } completion:^(BOOL finished) {
            tempView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.loginView.frame = CGRectMake(84, 0 - LOGIN_VIEW_HEIGHT, 236, 0);
            }];
            self.loginView.hidden = YES;
            profileBtn.enabled = YES;
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int pLength, uLength, backspace;
    backspace = [string length] == 0? 0: 1;
    if (textField.tag==1) {
        uLength = (int)range.location + backspace;
        pLength = (int)[self.password.text length];
        if (range.location >= 10)
            return NO;
    }
    if (textField.tag==2) {
        uLength = (int)[self.username.text length];
        pLength = (int)range.location + backspace;
        if (range.location >= 20)
            return NO;
    }
    if (pLength < 6 || uLength != 10) {
        ((UIButton *)[self.view viewWithTag:3]).enabled = NO;
        //((UIButton *)[self.view viewWithTag:3]).backgroundColor = [UIColor grayColor];
    }else{
        ((UIButton *)[self.view viewWithTag:3]).enabled = YES;
    }
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIButton *button = (UIButton *)[self.view viewWithTag:3];
    if (button.enabled == YES) {
        [self signInButton:nil];
        [textField resignFirstResponder];
    }else {
        return NO;
    }
    
    return YES;
}

- (void)handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
//    //点击其他收回登录框。
//    BOOL open = self.loginView.frame.origin.y > 0;
//    if (open) {
//        UITouch *touch = [touches anyObject];
//        CGPoint currentLocation = [touch locationInView:self.view];
//        if (!((currentLocation.x > self.loginView.frame.origin.x) && (currentLocation.x < self.loginView.frame.origin.x + self.loginView.frame.size.width) && (currentLocation.y > self.loginView.frame.origin.y) && (currentLocation.y < self.loginView.frame.origin.y + self.loginView.frame.size.height))) {
//            [self profilePress:nil];
//        }
//    }
}



- (IBAction)feedbackButton:(id)sender
{
    AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [agent showConversations:self title:@"feedback" contact:[NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"name"]]];

}
@end
