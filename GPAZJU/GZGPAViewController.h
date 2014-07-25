//
//  GZGPAViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-28.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ASINetworkQueue.h>
#import <ViewPagerController.h>

@interface GZGPAViewController : ViewPagerController

@property (strong) ASINetworkQueue  *queue;
- (IBAction)refreshButton:(UIButton *)sender;
- (void)resignViewController;
@end
