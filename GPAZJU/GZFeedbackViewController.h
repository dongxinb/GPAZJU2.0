//
//  GZFeedbackViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-5.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZFeedbackViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitPress:(UIButton *)sender;

@end
