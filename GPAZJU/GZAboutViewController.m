//
//  GZAboutViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-5.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZAboutViewController.h"

@interface GZAboutViewController ()

@end

@implementation GZAboutViewController
@synthesize imageView;

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
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 20.;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
