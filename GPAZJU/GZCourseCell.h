//
//  GZCourseCell.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-9.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseID;
@property (weak, nonatomic) IBOutlet UILabel *voteNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;

@end
