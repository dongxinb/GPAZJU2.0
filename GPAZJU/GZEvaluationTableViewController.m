//
//  GZEvaluationTableViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-9.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZEvaluationTableViewController.h"
#import <AVOSCloud.h>
#import "GZCourseCell.h"
#import "GZCourse.h"
#import <JDStatusBarNotification.h>
#import "GZEvaluationDetailViewController.h"


#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]

@interface GZEvaluationTableViewController ()

@end

@implementation GZEvaluationTableViewController
@synthesize searchResultArray, courseArray;

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
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
    courseArray = [[NSArray alloc] init];
    courseArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"courseList"];
    self.searchDisplayController.searchBar.tintColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == YES) {
        [self refreshDataInBackground];
    }
    
//    [self refreshDataInBackground];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataInBackground) name:@"refreshCourse" object:nil];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO) {
        courseArray = [[NSArray alloc] init];
        [self.tableView reloadData];
    }else {
        if ([courseArray count] == 0) {
            [self refreshDataInBackground];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [searchResultArray count];
    }
    return [courseArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"courseCell";
    GZCourseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    GZCourse *course;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        course = [NSKeyedUnarchiver unarchiveObjectWithData:[searchResultArray objectAtIndex:indexPath.row]];
    }else {
        course = [NSKeyedUnarchiver unarchiveObjectWithData:[courseArray objectAtIndex:indexPath.row]];
    }
    
    
    cell.courseName.text = course.courseName;
    cell.courseID.text = course.courseID;
    cell.voteNumber.text = [NSString stringWithFormat:@"%d", course.voteNumber];
    cell.commentNumber.text = [NSString stringWithFormat:@"%d", course.commentNumber];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZCourse *course;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        course = [NSKeyedUnarchiver unarchiveObjectWithData:[searchResultArray objectAtIndex:indexPath.row]];
    }else {
        course = [NSKeyedUnarchiver unarchiveObjectWithData:[courseArray objectAtIndex:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GZEvaluationDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
    vc.courseName = course.courseName;
    vc.courseID = course.courseID;
    vc.title = @"详情";
    [self.navigationController pushViewController:vc animated:YES];
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

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    searchResultArray = courseArray;
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    searchResultArray = [[NSMutableArray alloc] init];
    for (NSData *data in courseArray) {
        GZCourse *course = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSRange range = [course.courseName rangeOfString:searchString];
        if (range.location != NSNotFound) {
            [searchResultArray addObject:data];
        }
    }
//    searchResultArray = courseArray;
    return YES;
}

- (IBAction)refreshPress:(UIButton *)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO) {
        [self showNotification:@"error" andMessage:@"你还没登录呢. :("];
        return;
    }
    sender.enabled = NO;
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"course"];
    [query orderByDescending:@"vote"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            for (AVObject *object in objects) {
                GZCourse *course = [GZCourse new];
                course.courseName = [object objectForKey:@"courseName"];
                course.courseID = [object objectForKey:@"courseID"];
                NSNumber *number = [object objectForKey:@"vote"];
                course.voteNumber = [number integerValue];
                number = [object objectForKey:@"comment"];
                course.commentNumber = [number integerValue];
                [mArray addObject:[NSKeyedArchiver archivedDataWithRootObject:course]];
                
            }
            courseArray = [NSArray arrayWithArray:mArray];
            [self.tableView reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:courseArray forKey:@"courseList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showNotification:@"success" andMessage:@"获取课程列表成功! :)"];
        }else {
            [self showNotification:@"error" andMessage:@"连接网络失败! :("];
        }
        sender.enabled = YES;
    }];
}

- (void)refreshDataInBackground
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] ==  NO) {
        return ;
    }
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"course"];
    [query orderByDescending:@"vote"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            for (AVObject *object in objects) {
                GZCourse *course = [GZCourse new];
                course.courseName = [object objectForKey:@"courseName"];
                course.courseID = [object objectForKey:@"courseID"];
                NSNumber *number = [object objectForKey:@"vote"];
                course.voteNumber = [number integerValue];
                number = [object objectForKey:@"comment"];
                course.commentNumber = [number integerValue];
                [mArray addObject:[NSKeyedArchiver archivedDataWithRootObject:course]];
                
            }
            courseArray = [NSArray arrayWithArray:mArray];
            [self.tableView reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:courseArray forKey:@"courseList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self showNotification:@"success" andMessage:@"获取课程列表成功! :)"];
        }else {
//            [self showNotification:@"error" andMessage:@"连接网络失败! :("];
        }
//        sender.enabled = YES;
    }];
}


@end












