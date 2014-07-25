//
//  GZRateViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-10.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZRateViewController.h"
#import <AVOSCloud.h>
#import <JDStatusBarNotification.h>
#import <RNBlurModalView.h>

@interface GZRateViewController ()<RatingViewDelegate>

@end

@implementation GZRateViewController
@synthesize content, name, rate, starView;

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
    rate = 4;
    content.layer.borderWidth = 1.;
    content.layer.borderColor = [UIColor colorWithRed:220./255. green:220./255. blue:220./255. alpha:1.].CGColor;
    content.layer.cornerRadius = 5.;
    name.layer.borderColor = [UIColor colorWithRed:220./255. green:220./255. blue:220./255. alpha:1.].CGColor;
    name.layer.borderWidth = 1.;
    name.layer.cornerRadius =  3.;
    
    
    
    
    starView = [[RatingView alloc] initWithFrame:CGRectMake(75, 54, 100, 15)];
    [starView setImagesDeselected:@"r0" partlySelected:@"r1" fullSelected:@"r2" andDelegate:self];
	[starView displayRating:4.];
    
    
    
    [self.view addSubview:starView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ratingChanged:(float)newRating {
    rate = (NSUInteger)newRating;
//    NSLog(@"%f", newRating);
//	ratingLabel.text = [NSString stringWithFormat:@"Rating is: %1.1f", newRating];
}

- (void)hideTheKeyboard
{
    CGFloat height = [UIScreen mainScreen ].bounds.size.height;
    NSTimeInterval animationDuration = .3f;
    CGRect frame = self.view.frame;
    frame.origin.y = (height - self.view.frame.size.height) / 2;
    //    frame.size. height -=70;
    //self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat height = [UIScreen mainScreen ].bounds.size.height;
    NSTimeInterval animationDuration = .3f;
    CGRect frame = self.view.frame;
    frame.origin.y = (height - self.view.frame.size.height) / 2 - 70;
    //    frame.size.height +=70;
    //self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat height = [UIScreen mainScreen ].bounds.size.height;
    NSTimeInterval animationDuration = .3f;
    CGRect frame = self.view.frame;
    frame.origin.y = (height - self.view.frame.size.height) / 2 - 70;

    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideTheKeyboard];
    [textField resignFirstResponder];
    return YES;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPress:(UIButton *)sender
{
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    NSString *str = content.text;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    
    NSDictionary *parameters = @{@"courseName": _courseName, @"courseID": _courseID, @"stuID": [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], @"name": name.text, @"rate": [NSNumber numberWithInt:rate], @"content": content.text};
    NSString *bgName;
    
    if (self.comment == nil) {
        bgName = @"courseComment";
    }else {
        bgName = @"courseCommentModify";
    }
    
    [AVCloud callFunctionInBackground:bgName withParameters:parameters block:^(id object, NSError *error) {
        if (error == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCourse" object:nil];
            [self showNotification:@"success" andMessage:@"评价成功！ :)"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil];
        }else {
            NSLog(@"%@", error);
            [self showNotification:@"error" andMessage:@"网络错误! :("];
        }
    }];
    
    /*
    AVQuery *query = [AVQuery queryWithClassName:@"course"];
    [query whereKey:@"courseID" equalTo:self.courseID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if ([objects count] == 0) {
                AVObject *course = [AVObject objectWithClassName:@"course"];
                [course setObject:self.courseName forKey:@"courseName"];
                [course setObject:self.courseID forKey:@"courseID"];
                [course setObject:[NSNumber numberWithInt:1] forKey:@"vote"];
                [course setObject:[NSNumber numberWithInt:1] forKey:@"comment"];
                [course saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        NSNumber *num = [NSNumber numberWithInteger:rate];
                        AVObject *obj = [AVObject objectWithClassName:@"courseComment"];
                        [obj setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"stuID"];
                        [obj setObject:num forKey:@"rate"];
                        [obj setObject:content.text forKey:@"content"];
                        [obj setObject:name.text forKey:@"stuName"];
                        [obj setObject:self.courseName forKey:@"courseName"];
                        [obj setObject:self.courseID forKey:@"courseID"];
                        
                        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (error == nil) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCourse" object:nil];
                                [self showNotification:@"success" andMessage:@"评价成功！ :)"];
                                _btn.enabled = NO;
                            }else {
                                
                            }
                        }];
                    }else {
                        [self showNotification:@"error" andMessage:@"连接失败。 :("];
                    }
                }];
                
            }else {
                AVObject *course = [objects firstObject];
                NSNumber *vote = [course objectForKey:@"vote"];
                NSNumber *comment = [course objectForKey:@"comment"];
                [course setObject:[NSNumber numberWithInt:[vote intValue] + 1] forKey:@"vote"];
                [course setObject:[NSNumber numberWithInt:[comment intValue] + 1] forKey:@"comment"];
                [course saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSNumber *num = [NSNumber numberWithInteger:rate];
                        AVObject *obj = [AVObject objectWithClassName:@"courseComment"];
                        [obj setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"stuID"];
                        [obj setObject:num forKey:@"rate"];
                        [obj setObject:content.text forKey:@"content"];
                        [obj setObject:name.text forKey:@"stuName"];
                        [obj setObject:self.courseName forKey:@"courseName"];
                        [obj setObject:self.courseID forKey:@"courseID"];
                        
                        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (error == nil) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCourse" object:nil];
                                [self showNotification:@"success" andMessage:@"评价成功！ :)"];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil];
                                _btn.enabled = NO;
                            }else {
                                
                            }
                        }];
                    }else {
                        [self showNotification:@"error" andMessage:@"连接失败。 :("];
                    }
                }];
            }
            
            
            
        }else {
            [self showNotification:@"error" andMessage:@"连接失败。 :("];
        }
    }];
     */
    
    
    
}

- (IBAction)bgTouchDown:(id)sender
{
    [self hideTheKeyboard];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
