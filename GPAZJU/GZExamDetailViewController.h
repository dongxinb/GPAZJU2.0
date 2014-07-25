//
//  GZExamDetailViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-3.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZExamDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *courseNumber;
@property (weak, nonatomic) IBOutlet UILabel *courseCredit;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseDate;
@property (weak, nonatomic) IBOutlet UILabel *courseLocation;
@property (weak, nonatomic) IBOutlet UILabel *courseSeat;
@property (weak, nonatomic) IBOutlet UILabel *submissionCheckResult;
- (IBAction)ratePress:(id)sender;


- (IBAction)checkSubmission:(UIButton *)sender;

@end
