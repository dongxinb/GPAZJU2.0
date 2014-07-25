//
//  GZRate1Cell.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-10.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZRate1Cell.h"

@implementation GZRate1Cell
@synthesize star1, star2, star3, star4, star5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStar:(CGFloat)number
{
    if (number <= 0 || number >5) {
        return ;
    }
    int i;
    NSArray *array = [[NSArray alloc] initWithObjects:star1, star2, star3, star4, star5, nil];
    
    for (i = 0; i < 5; i ++) {
        ((UIImageView *)array[i]).image = [UIImage imageNamed:@"r0"];
    }
    for (i = 0; i < (int)number; i ++) {
        ((UIImageView *)array[i]).image = [UIImage imageNamed:@"r2"];
    }
    if (number != (int)number) {
        ((UIImageView *)array[(int)number]).image = [UIImage imageNamed:@"r1"];
    }
    
    
}
@end
