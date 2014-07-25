//
//  GZRate3Cell.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-10.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZRate3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UILabel *content;
- (void)setStar:(CGFloat)number;
@end
