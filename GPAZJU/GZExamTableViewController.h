//
//  GZExamTableViewController.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZExamTableViewController : UITableViewController

@property (nonatomic, retain) NSString *indexOfExam;
@property (nonatomic, retain) NSMutableArray *exam;

- (void)buildArrayOfExam:(NSString *)examIndex;

@end
