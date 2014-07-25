//
//  GZRate2Cell.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-10.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZRate2Cell.h"
#import "GZRateViewController.h"
#import <RNBlurModalView.h>

@interface GZRate2Cell ()
@property (retain, nonatomic) RNBlurModalView *modal;
@end

@implementation GZRate2Cell
@synthesize modal;

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

- (IBAction)ratePress:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDismiss) name:@"dismiss" object:nil];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GZRateViewController *vc = [sb instantiateViewControllerWithIdentifier:@"rate"];
    vc.view.frame = CGRectMake(0, 0 , 280, 350);
    vc.view.layer.borderColor = [UIColor colorWithRed:220./255. green:220./255. blue:220./255. alpha:1.].CGColor;
    vc.view.layer.borderWidth = 2.;
    vc.view.layer.cornerRadius = 10.;
    
    modal = [[RNBlurModalView alloc] initWithView:vc.view];
    vc.courseName = self.courseName;
    vc.courseID = self.courseID;
    vc.comment = self.comment;
    if (vc.comment != nil) {
        vc.content.text = [_comment objectForKey:@"content"];
        vc.name.text = [_comment objectForKey:@"stuName"];
        vc.rate = [[_comment objectForKey:@"rate"] integerValue];
        [vc.starView displayRating:vc.rate];
    }
    
    
//    modal.frame = CGRectMake(0, 0, 280, 350);
    [modal show];
}

- (void)viewDismiss
{
    [modal hide];
}

-(void)drawLineWithStar1:(int)s1 Star2:(int)s2 Star3:(int)s3 Star4:(int)s4 andStar5:(int)s5
{
    int total = s1 + s2 + s3 + s4 + s5;
    if (total == 0) {
        total = 1;
    }
    [self drawLine:CGRectMake(84., 16., 210., 3.) andPercent:(double)s5 / total];
    [self drawLine:CGRectMake(84., 27., 210., 3.) andPercent:(double)s4 / total];
    [self drawLine:CGRectMake(84., 39., 210., 3.) andPercent:(double)s3 / total];
    [self drawLine:CGRectMake(84., 50., 210., 3.) andPercent:(double)s2 / total];
    [self drawLine:CGRectMake(84., 61., 210., 3.) andPercent:(double)s1 / total];

}

- (void)drawLine:(CGRect)rect andPercent:(CGFloat)percent
{
    CALayer *l = [CALayer layer];
    l.backgroundColor = [UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1.].CGColor;
    l.cornerRadius = 1.5;
    l.frame = rect;
    [self.contentView.layer addSublayer:l];
    
    CALayer *r = [CALayer layer];
    r.backgroundColor = [UIColor colorWithRed:225./255. green:130./255. blue:34./255. alpha:.8].CGColor;
//    r.backgroundColor = [UIColor lightGrayColor].CGColor;
    r.cornerRadius = 1.5;
    r.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * percent, rect.size.height);
    [self.contentView.layer addSublayer:r];
}

@end
