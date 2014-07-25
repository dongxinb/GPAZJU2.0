//
//  GZMyTableViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-28.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZMyTableViewController.h"
#import "GZGPACell.h"
#import "GZGPADetail.h"
#import "GZGPADetailViewController.h"

@interface GZMyTableViewController ()

@end

@implementation GZMyTableViewController
@synthesize gradeYear, season;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    gradeYear = 0;
    [self setExtraCellLineHidden:self.tableView];
    [self addFootview];
    //self.tableView.scrollsToTop=YES;
    
    //[self setExtraCellLineHidden:self.tableView];
    

    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //self.tableView.frame = CGRectMake(0, 0, 100, 100);
    //self.automaticallyAdjustsScrollViewInsets = YES;
    //NSLog(@"viewDidLoad");
    //self.view.frame = CGRectMake(0, -40, 320, 568);
    //NSLog(@"%lf %lf %lf %lf", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
    //self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)addFootview
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)buildArrayOfGradeYear:(int)year
{
    //NSLog(@"build");
    season = [[NSMutableArray alloc] init];
    gradeYear = year;
    NSArray *season1 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d-%d-1", gradeYear, gradeYear + 1]];
    NSArray *season2 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d-%d-2", gradeYear, gradeYear + 1]];
    GZGPADetail *season1Summary = [GZGPADetail new];
    GZGPADetail *season2Summary = [GZGPADetail new];
    GZGPADetail *summary = [GZGPADetail new];
    summary.isSummary = season1Summary.isSummary = season2Summary.isSummary = YES;
    season1Summary.credit = season2Summary.credit = 0.;
    season1Summary.GPA = season2Summary.GPA = 0.;
    for (NSData *courseDetailData in season1) {
        GZGPADetail *courseDetail = [GZGPADetail new];
        courseDetail = [NSKeyedUnarchiver unarchiveObjectWithData:courseDetailData];
        season1Summary.credit += courseDetail.credit;
        season1Summary.GPA += courseDetail.credit * courseDetail.GPA;
    }
    for (NSData *courseDetailData in season2) {
        GZGPADetail *courseDetail = [GZGPADetail new];
        courseDetail = [NSKeyedUnarchiver unarchiveObjectWithData:courseDetailData];
        season2Summary.credit += courseDetail.credit;
        season2Summary.GPA += courseDetail.credit * courseDetail.GPA;
    }
    season1Summary.courseName = @"秋冬学期";
    season2Summary.courseName = @"春夏学期";
    summary.courseName = @"学年成绩";
    summary.credit = season1Summary.credit + season2Summary.credit;
    summary.GPA = (summary.credit == 0)? 0. :((season1Summary.GPA + season2Summary.GPA) / summary.credit);
    season1Summary.GPA = (season1Summary.credit == 0)? 0. :(season1Summary.GPA / season1Summary.credit);
    season2Summary.GPA = (season2Summary.credit == 0)? 0. :(season2Summary.GPA / season2Summary.credit);
    //NSLog(@"%.2lf", summary.GPA);
    [season addObject:summary];
    [season addObject:season1Summary];
    for (NSData *courseDetailData in season1) {
        GZGPADetail *courseDetail = [GZGPADetail new];
        courseDetail = [NSKeyedUnarchiver unarchiveObjectWithData:courseDetailData];
        [season addObject:courseDetail];
    }
    [season addObject:season2Summary];
    for (NSData *courseDetailData in season2) {
        GZGPADetail *courseDetail = [GZGPADetail new];
        courseDetail = [NSKeyedUnarchiver unarchiveObjectWithData:courseDetailData];
        [season addObject:courseDetail];
    }
//    if ([season count] >= 13) {
//        GZGPADetail *whiteCell = [GZGPADetail new];
//        whiteCell.isSummary = YES;
//        [season addObject:whiteCell];
//    }
}

- (void)setFrame:(CGRect)myFrame
{
    self.tableView.frame = myFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZGPADetail *detail = [season objectAtIndex:indexPath.row];
    if (detail.isSummary == NO) {
        return 36;
    }else {
        return 40;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [season count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZGPACell *cell;
    GZGPADetail *courseDetail = [season objectAtIndex:indexPath.row];
    if (courseDetail.isSummary == NO) {
        NSString *CellIdentifier = @"Grade";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.courseName.text = courseDetail.courseName;
        cell.GPA.text = [NSString stringWithFormat:@"%.1f", courseDetail.GPA];
        cell.credit.text = [NSString stringWithFormat:@"× %.1f", courseDetail.credit];
    }else {
        NSString *CellIdentifier = @"Summary";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.courseName.text = courseDetail.courseName;
        cell.GPA.text = [NSString stringWithFormat:@"%.2f", courseDetail.GPA];
        cell.credit.text = [NSString stringWithFormat:@"× %.1f", courseDetail.credit];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZGPACell *cell = (GZGPACell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    GZGPADetail *courseDetail = [season objectAtIndex:indexPath.row];
    if (courseDetail.isSummary == NO) {
        GZGPADetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GZGPADetailViewController"];
        detailViewController.view.backgroundColor = [UIColor whiteColor];
        detailViewController.courseCredit.text = [NSString stringWithFormat:@"%.1lf", courseDetail.credit];
        detailViewController.courseGPA.text = [NSString stringWithFormat:@"%.1lf", courseDetail.GPA];
        detailViewController.courseGrade.text = courseDetail.grade;
        detailViewController.couseNumber.text = courseDetail.courseNumber;
        detailViewController.courseName.text = courseDetail.courseName;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
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
