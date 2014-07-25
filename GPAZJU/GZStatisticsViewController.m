//
//  GZStatisticsViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-26.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZStatisticsViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:36./255. green:70./255. blue:105./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:19./255. green:133./255. blue:254./255. alpha:1.]


@interface GZStatisticsViewController ()

@end

@implementation GZStatisticsViewController
@synthesize J, H, I, L, K, M, S, X, WK, LK, total;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
    J.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"J"]];
    H.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"H"]];
    I.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"I"]];
    L.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"L"]];
    K.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"K"]];
    M.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"M"]];
    S.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"S"]];
    X.text = [NSString stringWithFormat:@"%.1lf", [ns doubleForKey:@"X"]];
    WK.text = [NSString stringWithFormat:@"%.1lf", [J.text doubleValue] + [H.text doubleValue] + [I.text doubleValue] + [L.text doubleValue]];
    LK.text = [NSString stringWithFormat:@"%.1lf", [K.text doubleValue] + [M.text doubleValue]];
    total.text = [NSString stringWithFormat:@"%.1lf", [WK.text doubleValue] + [LK.text doubleValue] + [S.text doubleValue] + [X.text doubleValue]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
