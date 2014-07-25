//
//  GZEvaluationDetailViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-9.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZEvaluationDetailViewController.h"
#import <AVOSCloud.h>
#import <JDStatusBarNotification.h>
#import "GZRate1Cell.h"
#import "GZRate2Cell.h"
#import "GZRate3Cell.h"
#import "GZRateViewController.h"
#import <RNBlurModalView.h>

@interface GZEvaluationDetailViewController ()
@property (nonatomic, retain) NSArray *evaluation;
@property (nonatomic, retain) NSMutableArray *eva;
@property (nonatomic, assign) double vote;
//@property (nonatomic, assign) BOOL modify;
@property (nonatomic, retain) AVObject *comment;

@end
@implementation GZEvaluationDetailViewController
@synthesize evaluation, vote, courseID, courseName, comment, eva;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    evaluation = [[NSArray alloc] init];
    
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"courseComment"];
    [query whereKey:@"courseID" equalTo:courseID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        evaluation = objects;
//        [self.tableView reloadData];
        eva = [[NSMutableArray alloc] init];
        for (AVObject *obj in evaluation) {
            if ([[obj objectForKey:@"content"] length] != 0) {
                [eva addObject:obj];
                
            }
        }
        [self.tableView reloadData];
        
        [self showNotification:@"success" andMessage:@"读取成功. :)"];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataInBackground) name:@"refreshCourse" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataInBackground
{
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"courseComment"];
    [query whereKey:@"courseID" equalTo:courseID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        evaluation = objects;
        eva = [[NSMutableArray alloc] init];
        for (AVObject *obj in evaluation) {
            if ([[obj objectForKey:@"content"] length] != 0) {
                [eva addObject:obj];
            }
        }
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }
    return [eva count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 110.;
        }else {
            return 120.;
        }
    }
    AVObject *obj = [eva objectAtIndex:indexPath.row];
    NSString *str = [obj objectForKey:@"content"];
   
//    NSDictionary *attribute = @{NSFontAttributeName: };
//    CGSize size = [str boundingRectWithSize:CGSizeMake(272, 0) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.], NSFontAttributeName, nil];
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(272, 999) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14.] constrainedToSize:CGSizeMake(272, 999) lineBreakMode:NSLineBreakByClipping];

//    return 100;
    return 36 + size.height;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"课程概况";
    }else
        return @"课程评论";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.;
}

- (void)showNotification:(NSString *)para andMessage:(NSString *)message
{
    if ([para isEqualToString:@"warning"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:1.5 styleName:JDStatusBarStyleWarning];
    }else if ([para isEqualToString:@"error"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:2. styleName:JDStatusBarStyleError];
    }else if ([para isEqualToString:@"success"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
    }else if ([para isEqualToString:@"normal"]) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:2. styleName:JDStatusBarStyleDefault];
    }else if ([para isEqualToString:@"process"]) {
        [JDStatusBarNotification showWithStatus:message styleName:JDStatusBarStyleDefault];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int s1, s2, s3, s4, s5;
    s1 = s2 = s3 = s4 = s5 = 0;
    for (AVObject *obj in evaluation) {
        int temp = [[obj objectForKey:@"rate"] intValue];
        switch (temp) {
            case 1:
                s1 ++;
                break;
            case 2:
                s2 ++;
                break;
            case 3:
                s3 ++;
                break;
            case 4:
                s4 ++;
                break;
            case 5:
                s5 ++;
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *stri = @"rate1";
            GZRate1Cell *cell = [tableView dequeueReusableCellWithIdentifier:stri forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[GZRate1Cell alloc] init];
            }
            
            cell.courseID.text = courseID;
            cell.courseName.text = courseName;
            double average;
            if (s1 + s2 + s3 + s4 + s5 != 0) {
                average = (double)(s1 + s2 * 2 + s3 * 3 + s4 * 4 + s5 * 5) / (s1 + s2 + s3 + s4 + s5);

            }else
                average = 0;
            
            [cell setStar:average];
            cell.rateLabel.text = [NSString stringWithFormat:@"%.1f", average];
            
            return cell;
        }else {
            
            
            static NSString *stri = @"rate2";
            GZRate2Cell *cell = [tableView dequeueReusableCellWithIdentifier:stri forIndexPath:indexPath];
            [cell drawLineWithStar1:s1 Star2:s2 Star3:s3 Star4:s4 andStar5:s5];
            cell.courseID = courseID;
            cell.courseName = courseName;
            
            for (AVObject *obj in evaluation) {
                if ([[obj objectForKey:@"stuID"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) {
                    comment = obj;
                    cell.comment = comment;
                    [cell.btn setTitle:@"修改评论" forState:UIControlStateNormal];
                    break;
                }
            }
            
            return cell;
        }
    }else {
        static NSString *stri = @"rate3";
        GZRate3Cell *cell = [tableView dequeueReusableCellWithIdentifier:stri forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[GZRate3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stri];
//        }
        AVObject *obj = [eva objectAtIndex:indexPath.row];
        cell.content.text = [obj objectForKey:@"content"];
        cell.nickName.text = [obj objectForKey:@"stuName"];
        NSLog(@"%@", [obj objectForKey:@"content"]);
//        cell.content.hidden = YES;
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
        
        CGSize size = [cell.content.text boundingRectWithSize:CGSizeMake(272, 999) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        CGSize size = [cell.content.text sizeWithFont:[UIFont systemFontOfSize:15.] constrainedToSize:CGSizeMake(272, 999) lineBreakMode:NSLineBreakByClipping];
        
        cell.content.frame = CGRectMake(28, 27, size.width, size.height);
        [cell setStar:[[obj objectForKey:@"rate"]intValue]];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, size.width, size.height)];
//        label.text = [obj objectForKey:@"content"];
//        label.numberOfLines = 0;//表示label可以多行显示
//        label.font = [UIFont systemFontOfSize:14.];
//        label.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
//        [cell.contentView addSubview:label];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        cell.creatTime.text = [dateFormatter stringFromDate:obj.createdAt];
        return cell;
    }

}


@end
