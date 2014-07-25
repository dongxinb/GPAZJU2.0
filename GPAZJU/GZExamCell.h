//
//  GZExamCell.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZExamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseLocation;
@property (weak, nonatomic) IBOutlet UILabel *courseSeat;
@property (weak, nonatomic) IBOutlet UILabel *courseDate;
@property (weak, nonatomic) IBOutlet UILabel *courseCredit;

@end
