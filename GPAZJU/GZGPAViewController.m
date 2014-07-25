//
//  GZGPAViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-28.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZGPAViewController.h"
#import <SSKeychain.h>
#import <ASINetworkQueue.h>
#import <ASIFormDataRequest.h>
#import <JDStatusBarNotification.h>
#import <TFHpple.h>
#import <TFHppleElement.h>
#import <XPathQuery.h>
#import "GZGPADetail.h"
#import "GZMyTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>


//#define NAVIGATIONBAR_COLOR [UIColor whiteColor]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:52./255. green:152./255. blue:219./255. alpha:1.]
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:36./255. green:70./255. blue:105./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:19./255. green:133./255. blue:254./255. alpha:1.]
#define GB2312_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
#define LOGIN_SITE_STRING @"http://jwbinfosys.zju.edu.cn/default2.aspx"

@interface GZGPAViewController () <ViewPagerDataSource, ViewPagerDelegate>
//@property (nonatomic, retain) NSMutableArray *indexOfYear;
@property (nonatomic, assign) NSInteger page;
@end

@implementation GZGPAViewController
@synthesize queue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignViewController) name:@"resignViewController" object:nil];
    
    NSMutableArray *indexOfYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfYear"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == YES && [indexOfYear count] == 0) {
        [self setActiveContentIndex:0];
        [self setActiveTabIndex:0];
        [self loginFirst];
    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO){
        [self setActiveContentIndex:0];
        [self setActiveTabIndex:0];
        [self reloadData];
    }
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    NSMutableArray *indexOfYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfYear"];
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] && [indexOfYear count] != 0){
//        if (_page == 0) {
//            
//        }else {
//            [self setActiveTabIndex:_page - 1];
//            [self setActiveContentIndex:_page - 1];
//        }
//    }
//}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    _page = [self getCurrentTabIndex] + 1;
//    [self setActiveContentIndex:0];
//    [self setActiveTabIndex:0];
//    [self reloadData];
//}


- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    self.dataSource = self;
    self.delegate = self;
    [self setIndexOfYear];
    [self reloadData];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO) {
        [self.tabBarController setSelectedIndex:4];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    }
    
    
    
    
}

- (void)resignViewController
{
    [self setActiveContentIndex:0];
    [self setActiveTabIndex:0];
    [self reloadData];
}

//- (IBAction)refreshButton:(UIButton *)sender
//{
//    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"https://passport.meituan.com/account/login"]];
//    [req setDelegate:self];
//    [req setPostValue:@"358604588@qq.com" forKey:@"email"];
//    [req setPostValue:@"123456" forKey:@"password"];
//    [req setPostValue:@"1" forKey:@"remember_username"];
//    [req startSynchronous];
//    NSString *result = [req responseString];
//    NSLog(@"%@", result);
//}
- (IBAction)refreshButton:(UIButton *)sender
{
//    NSURL *url = [NSURL URLWithString:LOGIN_SITE_STRING];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
////        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:GB2312_ENCODING]];
//        
//        
////        block(today, allResult, nil);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        block(nil, nil, error);
//    }];
//    [operation start];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        [self setActiveContentIndex:0];
        [self setActiveTabIndex:0];
        [self loginFirst];
    }else {
        [self showNotification:@"error" andMessage:@"你还没登录呢. :("];
    }
}

//- (IBAction)refreshButton:(UIButton *)sender
//{
//    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:@"http://www.meituan.com/api/v2/hangzhou/deals"]];
////    AeSIHTTPRequest *req = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    //[req setDefaultResponseEncoding:NSUTF8StringEncoding];
//    [req setRequestMethod:@"GET"];
//    [req startSynchronous];
//    [req setTimeOutSeconds:0];
//    NSString *res = [req responseString];
////    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////    NSString *doc = [NSString stringWithFormat:@"%@/11.plist",documentDir];
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * documentDirectory = [paths objectAtIndex:0];
//    NSString * file = [documentDirectory stringByAppendingPathComponent:@"file1.txt"];
//    NSLog(@"%@", file);
//    [res writeToFile:file atomically:YES encoding:[req responseEncoding] error:nil];
//}

//- (void)selectTabWithNumberFive
//{
//    [self selectTabAtIndex:5];
//}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    NSMutableArray *indexOfYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfYear"];
    if ([indexOfYear count] == 0) {
        return 1;
    }
    return [indexOfYear count];
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    NSMutableArray *indexOfYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfYear"];
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    //label.text = [NSString stringWithFormat:@"Tab #%i", index];
    if ([indexOfYear count] != 0) {
        int year = [[indexOfYear objectAtIndex:index]intValue];
        label.text = [NSString stringWithFormat:@"%d-%d", year, year + 1];
    }else {
        label.text = @"未登录";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    //GZMyTableViewController *cvc = [[GZMyTableViewController alloc] initWithYear:2012];
    NSMutableArray *indexOfYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfYear"];
    if ([indexOfYear count] == 0) {
        GZMyTableViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GZMyTableViewController"];
        return cvc;
    }
    
    NSString *year = [indexOfYear objectAtIndex:index];
    GZMyTableViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GZMyTableViewController"];
    [cvc buildArrayOfGradeYear:[year intValue]];
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 30.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            //return [[UIColor redColor] colorWithAlphaComponent:0.64];
            return [UIColor orangeColor];
        case ViewPagerTabsView:
//            return [UIColor whiteColor];
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginFirst
{
    [self setAllInteractionEnabled:NO];
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    queue = [[ASINetworkQueue alloc] init];
    [queue setDelegate:self];
    [queue setShowAccurateProgress:YES];
    [queue setQueueDidFinishSelector:@selector(allYearsCompleted)];
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [SSKeychain passwordForService:@"com.dongxinbao.GPAZJU" account:xuehao];
    NSURL *url = [NSURL URLWithString:LOGIN_SITE_STRING];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    //requestForm.useCookiePersistence = NO;
    [requestForm setPostValue:@"Button1" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"" forKey:@"__EVENTARGUMENT"];
    [requestForm setPostValue:@"dDwxNTc0MzA5MTU4Ozs+RGE82+DpWCQpVjFtEpHZ1UJYg8w=" forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:xuehao forKey:@"TextBox1"];
    [requestForm setPostValue:password forKey:@"TextBox2"];
    [requestForm setPostValue:@"学生" forKey:@"RadioButtonList1"];
    [requestForm setPostValue:@"submit" forKey:@"_eventId"];
    [requestForm setPostValue:@"" forKey:@"Text1"];
    [requestForm setDelegate:self];
    [requestForm setDidFinishSelector:@selector(loginFinished:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm startAsynchronous];
}

- (void)loginFinished:(ASIFormDataRequest *)requestForm
{
    NSData *data = [requestForm responseData];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:GB2312_ENCODING];
//    NSString *responseString = [requestForm responseString];
//    NSLog(@"%@", responseString);
    if ([responseString length] == 0) {
        [self showNotification:@"error" andMessage:@"教务网出问题了？ :("];
        [queue cancelAllOperations];
        [self setAllInteractionEnabled:YES];
        return;
    }
    NSRange range1 = [responseString rangeOfString:@"用户名不存在"];
    NSRange range2 = [responseString rangeOfString:@"密码错误"];
    NSRange range3 = [responseString rangeOfString:@"控制学号访问"];
    NSRange range4 = [responseString rangeOfString:@"学籍"];
    NSRange range5 = [responseString rangeOfString:@"欠费"];
    NSRange range6 = [responseString rangeOfString:@"个人信息"];
    NSRange range7 = [responseString rangeOfString:@"mobile.html"];
    if (range1.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"学号不存在啊! :("];
    }else if (range2.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"密码错了，快检查一下密码! :("];
    }else if (range3.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"学校正控制学号访问呢,等一下吧! :("];
    }else if (range4.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"学籍状态不正确，快去检查一下! :("];
    }else if (range5.location != NSNotFound) {
        [self showNotification:@"error" andMessage:@"你是不是欠费了? :("];
    }else if (range6.location != NSNotFound) {
        NSLog(@"Login Success!");
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"statistics"];
        NSArray *temp = [[NSArray alloc] initWithObjects:@"J", @"H", @"I", @"L", @"K", @"M", @"S", @"X", nil];
        for (NSString *class in temp) {
            [[NSUserDefaults standardUserDefaults] setDouble:0. forKey:class];
        }
        [self setGPAQueue];
    }else if (range7.location != NSNotFound){
        [self showNotification:@"error" andMessage:@"ZJUWLAN还没登录呢! :("];
    }else {
        [self showNotification:@"error" andMessage:@"我也不知道哪里出错了... :("];
    }
    if (range6.location == NSNotFound) {
        [queue cancelAllOperations];
        [self setAllInteractionEnabled:YES];
        return;
    }
}


- (void)setGPAQueue
{
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //    NSDictionary *cookiesDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookies"];
    //    NSHTTPCookie *firstCookie = [[NSHTTPCookie alloc] initWithProperties:cookiesDic];
    //    NSMutableArray *cookies = [[NSMutableArray alloc] initWithObjects:firstCookie, nil];
    //add the login operation
    NSInteger year = [self getCurrentYear];
    NSInteger enterYear = [self getEnterYear];
    while (enterYear != year + 1) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xscj.aspx?xh=%@", xuehao]];
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
        //[ASIFormDataRequest setSessionCookies:cookies];
        [requestForm setPostValue:@"dDwyMTQ0OTczMjA5O3Q8O2w8aTwxPjs+O2w8dDw7bDxpPDI+O2k8NT47aTwyMT47aTwyMz47aTwzNz47aTwzOT47aTw0MT47aTw0Mz47PjtsPHQ8dDw7dDxpPDE0PjtAPFxlOzIwMDEtMjAwMjsyMDAyLTIwMDM7MjAwMy0yMDA0OzIwMDQtMjAwNTsyMDA1LTIwMDY7MjAwNi0yMDA3OzIwMDctMjAwODsyMDA4LTIwMDk7MjAwOS0yMDEwOzIwMTAtMjAxMTsyMDExLTIwMTI7MjAxMi0yMDEzOzIwMTMtMjAxNDs+O0A8XGU7MjAwMS0yMDAyOzIwMDItMjAwMzsyMDAzLTIwMDQ7MjAwNC0yMDA1OzIwMDUtMjAwNjsyMDA2LTIwMDc7MjAwNy0yMDA4OzIwMDgtMjAwOTsyMDA5LTIwMTA7MjAxMC0yMDExOzIwMTEtMjAxMjsyMDEyLTIwMTM7MjAxMy0yMDE0Oz4+Oz47Oz47dDx0PHA8cDxsPERhdGFUZXh0RmllbGQ7RGF0YVZhbHVlRmllbGQ7PjtsPHh4cTt4cTE7Pj47Pjt0PGk8Nz47QDxcZTvnp4s75YasO+efrTvmmKU75aSPO+efrTs+O0A8XGU7MXznp4s7MXzlhqw7MXznn607MnzmmKU7MnzlpI87Mnznn607Pj47Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cucHJpbnQoKVw7Oz4+Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cuY2xvc2UoKVw7Oz4+Pjs7Pjt0PEAwPDs7Ozs7Ozs7Ozs+Ozs+O3Q8QDA8Ozs7Ozs7Ozs7Oz47Oz47dDxAMDw7Ozs7Ozs7Ozs7Pjs7Pjt0PHA8cDxsPFRleHQ7PjtsPFpKRFg7Pj47Pjs7Pjs+Pjs+Pjs+y0ElZ9Hn+SlXToKugoUwAneDL5w=" forKey:@"__VIEWSTATE"];
        [requestForm setPostValue:[NSString stringWithFormat:@"%ld-%ld", enterYear, enterYear + 1] forKey:@"ddlXN"];
        [requestForm setPostValue:@"按学年查询" forKey:@"Button5"];//Button1为学期 Button5为学年
        [requestForm setDelegate:self];
        [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
        //[requestForm setUseCookiePersistence:NO];
        //[requestForm setRequestCookies:cookies];
        [requestForm setDidFinishSelector:@selector(oneYearCompleted:)];
        [requestForm setDidFailSelector:@selector(requestError:)];
        [queue addOperation:requestForm];
        
        enterYear ++;
    }
    
    [queue go];
}

- (void)oneYearCompleted:(ASIFormDataRequest *)requestForm
{
   // NSLog(@"------------1-----------");
//    NSLog(@"%@", [requestForm responseString]);
    NSData *data = [requestForm responseData];
    NSString *temp = [[NSString alloc] initWithData:data encoding:GB2312_ENCODING];
    
//    NSString *temp = [[NSString alloc] initWithData:[requestForm responseData] encoding:[requestForm responseEncoding]];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
//    NSArray *elements = [parser searchWithXPathQuery:@"//span[@id='lblxm']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    
    NSMutableArray *season1 = [[NSMutableArray alloc] init];
    NSMutableArray *season2 = [[NSMutableArray alloc] init];
    int xueqi;
    NSString *xuenian = [[NSString alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        
        GZGPADetail *courseDetail = [[GZGPADetail alloc] init];
        courseDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        courseDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        if ([[[[course objectAtIndex:3] firstChild] content] isEqualToString:@"&nbsp;"]) {
            courseDetail.grade = @"0";
        }else {
            courseDetail.grade = [[[course objectAtIndex:3] firstChild] content];
        }
        courseDetail.credit = [[[[course objectAtIndex:4] firstChild] content] doubleValue];
        if ([[[[course objectAtIndex:5] firstChild] content] isEqualToString:@"&nbsp;"]) {
            courseDetail.GPA = 0.;
        }else {
            courseDetail.GPA = [[[[course objectAtIndex:5] firstChild] content] doubleValue];
        }
        NSString *class = [courseDetail.courseNumber substringWithRange:NSMakeRange(17, 1)];
        NSArray *array = [[NSArray alloc] initWithObjects:@"J", @"H", @"I", @"L", @"K", @"M", @"S", @"X", nil];
        if ([array containsObject:class]) {
            [[NSUserDefaults standardUserDefaults] setDouble:[[NSUserDefaults standardUserDefaults] doubleForKey:class] + courseDetail.credit forKey:class];
        }
        courseDetail.isSummary = NO;
        NSData *courseDetailData = [[NSData alloc] init];
        courseDetailData = [NSKeyedArchiver archivedDataWithRootObject:courseDetail];
        
        //GZGPADetail *temp = [NSKeyedUnarchiver unarchiveObjectWithData:courseDetail];
        
        xueqi = [[courseDetail.courseNumber substringWithRange:NSMakeRange(11, 1)] intValue];
        xuenian = [courseDetail.courseNumber substringWithRange:NSMakeRange(1, 9)];
        if (xueqi == 1) {
            [season1 addObject:courseDetailData];
            //[season1 setObject:courseDetailData forKey:courseDetail.courseName];
        }else {
            [season2 addObject:courseDetailData];
            //[season2 setObject:courseDetailData forKey:courseDetail.courseName];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:season1 forKey:[NSString stringWithFormat:@"%@-1", xuenian]];
    [[NSUserDefaults standardUserDefaults] setObject:season2 forKey:[NSString stringWithFormat:@"%@-2", xuenian]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
    NSLog(@"%@", [requestForm error]);
    [self showNotification:@"error" andMessage:@"连接网络失败! :("];
    [queue cancelAllOperations];
    [self setActiveContentIndex:0];
    [self setActiveTabIndex:0];
    [self reloadData];
    [self setAllInteractionEnabled:YES];
}

- (void)allYearsCompleted
{
    [self showNotification:@"success" andMessage:@"所有成绩刷新成功啦! :)"];
    [self setIndexOfYear];
//    [self setActiveContentIndex:0];
//    [self setActiveTabIndex:0];
    [self reloadData];
    //GZGPAViewController *new = [[GZGPAViewController alloc] init];
    //[self removeFromParentViewController];
    //[self.parentViewController addChildViewController:new];
    //[self presentViewController:new animated:NO completion:nil];
    NSLog(@"ALL YEARS COMPLETED!!!");
    [self setAllInteractionEnabled:YES];
}

- (void)setIndexOfYear
{
    NSMutableArray *indexOfYear = [[NSMutableArray alloc] init];
    int i;
    for (i = [self getCurrentYear]; i >= [self getEnterYear]; i --) {
        NSMutableArray *temp1 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d-%d-1", i, i + 1]];
        NSMutableArray *temp2 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d-%d-2", i, i + 1]];
        if (([temp1 count] + [temp2 count]) != 0) {
            [indexOfYear addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:indexOfYear forKey:@"indexOfYear"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//get the current year
- (NSInteger)getCurrentYear
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    return year;
}

//get the year of entering school
- (NSInteger)getEnterYear
{
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *temp = [xuehao substringWithRange:NSMakeRange(1, 2)];
    NSInteger year = 2000 + [temp integerValue];
    return year;
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

@end
