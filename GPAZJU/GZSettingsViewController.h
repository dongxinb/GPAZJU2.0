//
//  GZSettingsViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-25.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LFGlassView.h>
@interface GZSettingsViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LFGlassView *loginView;
@property (weak, nonatomic) IBOutlet UIView *signInView;
@property (weak, nonatomic) IBOutlet UIView *signOutView;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *xuehao;
@property (weak, nonatomic) IBOutlet UIButton *temp1;
@property (weak, nonatomic) IBOutlet UIButton *label1;

@property (weak, nonatomic) IBOutlet UIButton *pushSet;
@property (weak, nonatomic) IBOutlet UIButton *clearSet;
@property (weak, nonatomic) IBOutlet UIButton *bugSet;
@property (weak, nonatomic) IBOutlet UIButton *supportSet;
@property (weak, nonatomic) IBOutlet UIButton *judgeSet;
@property (weak, nonatomic) IBOutlet UIButton *aboutSet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileBtn;

- (IBAction)clearPress:(UIButton *)sender;

- (IBAction)signInButton:(UIButton *)sender;
- (IBAction)profilePress:(UIButton *)sender;
- (IBAction)signOutButton:(UIButton *)sender;
- (IBAction)judgePress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
- (IBAction)feedbackButton:(id)sender;

@end
