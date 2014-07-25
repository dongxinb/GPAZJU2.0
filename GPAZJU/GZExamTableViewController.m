//
//  GZExamTableViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZExamTableViewController.h"
#import "GZExamDetailViewController.h"
#import "GZExamDetail.h"
#import "GZExamCell.h"

@interface GZExamTableViewController ()

@end

@implementation GZExamTableViewController
@synthesize exam, indexOfExam;

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
    [self addFootview];
    [self setExtraCellLineHidden:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)addFootview
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
}

- (void)buildArrayOfExam:(NSString *)examIndex
{
    NSMutableArray *examArray = [[NSUserDefaults standardUserDefaults] objectForKey:examIndex];
    //exam = examArray;
    exam = [[NSMutableArray alloc] init];
    for (NSData *examDetailData in examArray) {
        GZExamDetail *examDetail = [NSKeyedUnarchiver unarchiveObjectWithData:examDetailData];
        [exam addObject:examDetail];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [exam count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GZExamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    GZExamDetail *examDetail = [exam objectAtIndex:indexPath.row];
    cell.courseName.text = examDetail.courseName;
    cell.courseDate.text = examDetail.courseDate;
    cell.courseLocation.text = examDetail.courseLocation;
    //NSLog(@"%@", cell.courseLocation.text);
    if ([cell.courseLocation.text isEqualToString:@" "] && (![cell.courseDate.text isEqualToString:@" "])) {
        cell.courseLocation.text = @"暂无信息";
    }
    if ([cell.courseDate.text isEqualToString:@" "]) {
        cell.courseLocation.text = @"无需考试";
    }
    cell.courseSeat.text = examDetail.courseSeat;
    cell.courseCredit.text = examDetail.courseCredit;
    
    
    NSString *str = @"";
    if ([cell.courseDate.text length] >= 11) {
        str = [examDetail.courseDate substringToIndex:10];
    }
    UILabel *label = [self getCountDownLabel:str];
    [cell addSubview:label];
    
    
    
    
    return cell;
}

- (UILabel *)getCountDownLabel: (NSString *)str
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(270, 26, 77, 25)];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textAlignment = UITextAlignmentCenter;
    label.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    
    if ([str length] == 0) {
        label.text = @"无需考试";
        label.backgroundColor = [UIColor lightGrayColor];
        return label;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    NSDate *dest = [dateFormatter dateFromString:str];
//    label.text = @"12";
    NSDate *current = [NSDate date];
    NSString *cstr = [dateFormatter stringFromDate:current];
    current = [dateFormatter dateFromString:cstr];
    int ti = dest.timeIntervalSince1970 - current.timeIntervalSince1970;
    if (ti < 0) {
        label.text = @"已结束";
        label.backgroundColor = [UIColor lightGrayColor];
        return label;
    }
//    ti = -ti;
    ti = ti / 60 / 60 / 24;
    
    if (ti < 1) {
        label.text = @"今天";
        label.backgroundColor = [UIColor colorWithRed:247./255. green:22./255. blue:46./255. alpha:1.];
        return label;
    }
    
    label.text = [NSString stringWithFormat:@"%d天后", ti];
    
    if (ti <= 2) {
        label.backgroundColor = [UIColor colorWithRed:247./255. green:95./255. blue:115./255. alpha:1.];
    }else if (ti <= 3) {
        label.backgroundColor = [UIColor colorWithRed:254./255. green:155./255. blue:50./255. alpha:1.];
    }else if (ti <= 10) {
        label.backgroundColor = [UIColor colorWithRed:253./255. green:217./255. blue:43./255. alpha:1.];
        
    }else {
        label.backgroundColor = [UIColor colorWithRed:109./255. green:198/255. blue:85./255. alpha:1.];
    }
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZExamCell *cell = (GZExamCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    GZExamDetail *courseDetail = [exam objectAtIndex:indexPath.row];
    GZExamDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GZExamDetailViewController"];
    detailViewController.view.backgroundColor = [UIColor whiteColor];
    detailViewController.courseName.text = courseDetail.courseName;
    detailViewController.courseNumber.text = courseDetail.courseNumber;
    detailViewController.courseCredit.text = courseDetail.courseCredit;
    detailViewController.courseSeat.text = courseDetail.courseSeat;
    detailViewController.courseLocation.text = courseDetail.courseLocation;
    detailViewController.courseDate.text = courseDetail.courseDate;
    if ([courseDetail.courseDate isEqualToString:@" "]) {
        detailViewController.courseDate.text = @"无需考试";
    }else {
        if ([courseDetail.courseLocation isEqualToString:@" "]) {
            detailViewController.courseLocation.text = @"暂无信息";
        }
    }
    detailViewController.submissionCheckResult.text = @"";
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
