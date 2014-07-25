//
//  GZFeedbackViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-5.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZFeedbackViewController.h"
#import <JDStatusBarNotification.h>
#import <AVOSCloud/AVOSCloud.h>

@interface GZFeedbackViewController ()

@end

@implementation GZFeedbackViewController
@synthesize feedbackField, submitButton;

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
    AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
    [agent showConversations:self title:@"feedback" contact:@"test@avoscloud.com"];
    [feedbackField setDelegate:self];
    feedbackField.layer.borderColor = [UIColor grayColor].CGColor;
    feedbackField.layer.borderWidth = 1.5;
    submitButton.enabled = NO;
    [submitButton setBackgroundColor:[UIColor grayColor]];
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
//                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
//    tapRecognizer.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapRecognizer];
    
	// Do any additional setup after loading the view.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text length] >= 10) {
            [textView resignFirstResponder];
            [self submitPress:submitButton];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([feedbackField.text length]<=10) {
        [submitButton setBackgroundColor:[UIColor grayColor]];
        submitButton.enabled = NO;
    }else{
        [submitButton setBackgroundColor:[UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]];
        submitButton.enabled = YES;
    }
}

- (void)handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [feedbackField resignFirstResponder];
    sender.enabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPress:(UIButton *)sender
{
    [self showNotification:@"process" andMessage:@"提交中……"];
    sender.enabled = NO;
    AVObject *bug = [AVObject objectWithClassName:@"bugFeedback"];
    [bug setObject:feedbackField.text forKey:@"content"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length] != 0) {
        [bug setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] forKey:@"deviceToken"];
    }
    [bug saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            sender.enabled = YES;
            [self showNotification:@"success" andMessage:@"提交成功啦，非常感谢你的反馈！"];
        }else{
            sender.enabled = YES;
            [self showNotification:@"error" andMessage:@"网络好像出了问题？"];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [feedbackField resignFirstResponder];
}

@end
