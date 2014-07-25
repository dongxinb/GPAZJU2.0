//
//  GZZJUWLANViewController.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-12.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZZJUWLANViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *wifiName;
@property (weak, nonatomic) IBOutlet UITextField *wifiPassword;
@property (weak, nonatomic) IBOutlet UIButton *closeVC;
- (IBAction)closePress:(UIButton *)sender;

- (IBAction)btnPress:(UIButton *)sender;
@end
