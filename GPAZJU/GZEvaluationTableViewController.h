//
//  GZEvaluationTableViewController.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-9.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZEvaluationTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic, retain) NSArray *courseArray;
@property (nonatomic, retain) NSMutableArray *searchResultArray;
- (IBAction)refreshPress:(UIButton *)sender;

@end
