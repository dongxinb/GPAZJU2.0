//
//  GZExamViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ViewPagerController.h>

@interface GZExamViewController : ViewPagerController<ViewPagerDelegate, ViewPagerDataSource>

- (IBAction)resfreshButton:(UIButton *)sender;

@end
