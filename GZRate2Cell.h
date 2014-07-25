//
//  GZRate2Cell.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-10.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud.h>

@interface GZRate2Cell : UITableViewCell
@property (nonatomic, retain) NSString *courseName;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, retain) NSString *courseID;
@property (nonatomic, retain) AVObject *comment;
- (IBAction)ratePress:(UIButton *)sender;
- (void)drawLineWithStar1:(int)s1 Star2:(int)s2 Star3:(int)s3 Star4:(int)s4 andStar5:(int)s5;
@end
