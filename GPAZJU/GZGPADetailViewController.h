//
//  GZGPADetailViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-3.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZGPADetailViewController : UIViewController
- (IBAction)shareButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *couseNumber;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseGrade;
@property (weak, nonatomic) IBOutlet UILabel *courseCredit;
@property (weak, nonatomic) IBOutlet UILabel *courseGPA;
- (IBAction)ratePress:(id)sender;

@end
