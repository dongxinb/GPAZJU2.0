//
//  GZMyTableViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-28.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZMyTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) int gradeYear;
@property (nonatomic, retain) NSMutableArray *season;

- (void)buildArrayOfGradeYear:(int)year;

@end
