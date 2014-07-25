//
//  GZRateViewController.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-10.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud.h>
#import "RatingView.h"

@interface GZRateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (nonatomic, retain) NSString *courseName;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, retain) NSString *courseID;

@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, retain) RatingView *starView;

@property (nonatomic, retain) AVObject *comment;

- (IBAction)btnPress:(UIButton *)sender;
- (IBAction)bgTouchDown:(id)sender;

@end
