//
//  GZExamViewController.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZExamViewController.h"
#import "GZExamTableViewController.h"
#import <SSKeychain.h>
#import <ASIHTTPRequest.h>
#import <ASIFormDataRequest.h>
#import <JDStatusBarNotification.h>
#import <TFHpple.h>
#import <TFHppleElement.h>
#import <XPathQuery.h>
#import "GZExamDetail.h"
#import <AVOSCloud/AVOSCloud.h>

//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:19./255. green:133./255. blue:254./255. alpha:1.]
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:15./255. green:149./255. blue:216./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:36./255. green:70./255. blue:105./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:62./255. green:195./255. blue:129./255. alpha:1.]
//#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:75./255. green:186./255. blue:228./255. alpha:1.]
#define GB2312_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
#define LOGIN_SITE_STRING @"http://jwbinfosys.zju.edu.cn/default2.aspx"

@interface GZExamViewController ()
@end

@implementation GZExamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignViewController) name:@"resignViewController" object:nil];
    
    NSMutableArray *indexOfExam = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfExam"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == YES && [indexOfExam count] == 0) {
        [self setActiveContentIndex:0];
        [self setActiveTabIndex:0];
        [self loginFirst];
    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == NO){
        [self setActiveContentIndex:0];
        [self setActiveTabIndex:0];
        [self reloadData];
    }
}

- (void)resignViewController
{
    [self setActiveContentIndex:0];
    [self setActiveTabIndex:0];
    [self reloadData];
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    NSMutableArray *indexOfExam = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfExam"];
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"] == YES && [indexOfExam count] != 0){
//        if (_page ==0) {
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//            [dateFormat setDateFormat:@"MM"];//这里写你想要的东西,月份,年分,日期啥的
//            NSInteger month = [[dateFormat stringFromDate:[NSData data]] integerValue];
//            NSInteger total = [self getTotalTabIndex];
//            switch (total) {
//                case 1:
//                    _page = 1;
//                    break;
//                case 2:case 3:
//                    if (month <= 11) {
//                        _page = 1;
//                    }else {
//                        _page = 2;
//                    }
//                    break;
//                case 4:
//                    if (month <= 5 && month >= 2) {
//                        _page = 3;
//                    }else if (month >=12 || month < 2) {
//                        _page = 2;
//                    }else {
//                        _page = 4;
//                    }
//                    break;
//                case 5:case 6:
//                    if (month <= 5 && month >= 2) {
//                        _page = 4;
//                    }else if (month >= 12 || month <2) {
//                        _page = 2;
//                    }else {
//                        _page = 5;
//                    }
//                    break;
//
//                default:
//                    _page = 1;
//                    break;
//            }
//            if (_page > [self getTotalTabIndex]) {
//                _page = [self getTotalTabIndex];
//            }
//        }
//            [self setActiveContentIndex:_page - 1];
//            [self setActiveTabIndex:_page - 1];
//        
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.delegate =self;
    self.dataSource = self;
    [self setIndexOfExam];
    [self reloadData];
    [self goToCurrentPage];
	// Do any additional setup after loading the view.
}

- (void)goToCurrentPage
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM"];
    NSInteger month = [[dateFormat stringFromDate:[NSDate date]] integerValue];
    NSMutableArray *indexOfExam = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfExam"];
    NSInteger total = [self getTotalTabIndex];
    NSInteger page;
    if (month >= 3 && month <=5) {
        if ([indexOfExam indexOfObject:@"exam4"] != NSNotFound) {
            page = [indexOfExam indexOfObject:@"exam4"];
        }else {
            page = 0;
        }
    }else if (month >= 6 && month <=7) {
        if ([indexOfExam indexOfObject:@"exam5"] != NSNotFound) {
            page = [indexOfExam indexOfObject:@"exam5"];
        }else {
            page = 0;
        }
    }else if (month >= 8 && month <= 11) {
        if ([indexOfExam indexOfObject:@"exam1"] != NSNotFound) {
            page = [indexOfExam indexOfObject:@"exam1"];
        }else {
            page = 0;
        }
    }else {
        if ([indexOfExam indexOfObject:@"exam2"] != NSNotFound) {
            page = [indexOfExam indexOfObject:@"exam2"];
        }else {
            page = 0;
        }
    }
    [self setActiveContentIndex:page];
    [self setActiveTabIndex:page];
}


#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    NSMutableArray *indexOfExam = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfExam"];
    if ([indexOfExam count] == 0) {
        return 1;
    }
    return [indexOfExam count];
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    NSMutableArray *indexOfExam = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfExam"];
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    //label.text = [NSString stringWithFormat:@"Tab #%i", index];
    if ([indexOfExam count] != 0) {
        int i = [[[indexOfExam objectAtIndex:index] substringWithRange:NSMakeRange(4, 1)] intValue];
        switch (i) {
            case 1:
                label.text = @"秋学期";
                break;
            case 2:
                label.text = @"冬学期";
                break;
            case 3:
                label.text = @"短学期I";
                break;
            case 4:
                label.text = @"春学期";
                break;
            case 5:
                label.text = @"夏学期";
                break;
            case 6:
                label.text = @"短学期II";
                break;
            default:
                break;
        }
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
    NSMutableArray *indexOfExam = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexOfExam"];
    if ([indexOfExam count] == 0) {
        GZExamTableViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GZExamTableViewController"];
        return cvc;
    }
    GZExamTableViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GZExamTableViewController"];
    [cvc buildArrayOfExam:[indexOfExam objectAtIndex:index]];
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
    
    [self showNotification:@"process" andMessage:@"正在连接……"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
}

- (void)loginFinished:(ASIFormDataRequest *)requestForm
{
    NSString *responseString = [[NSString alloc] initWithData:[requestForm responseData] encoding:GB2312_ENCODING];
//    NSString *responseString = [requestForm responseString];
    //NSLog(@"%@", responseString);
    if ([responseString length] == 0) {
        [self showNotification:@"error" andMessage:@"教务网出问题了？ :("];
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
        [self step1];
    }else if (range7.location != NSNotFound){
        [self showNotification:@"error" andMessage:@"ZJUWLAN还没登录呢! :("];
    }else {
        [self showNotification:@"error" andMessage:@"我也不知道哪里出错了... :("];
    }
    if (range6.location == NSNotFound) {
        [self setAllInteractionEnabled:YES];
    }
}

- (void)step1
{
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [request setResponseEncoding:kCFStringEncodingUTF8];
    [request setDidFinishSelector:@selector(step1_5:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)step1_5:(ASIHTTPRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setPostValue:viewstate forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:@"xqd" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"1|秋" forKey:@"xqd"];
    int year = [self getCurrentYear];
    if ([self getCurrentMonth] < 9) {
        year --;
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d", year, year + 1] forKey:@"xnd"];
    [requestForm setDelegate:self];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm setDidFinishSelector:@selector(step2:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)step2:(ASIFormDataRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        GZExamDetail *examDetail = [[GZExamDetail alloc] init];
        examDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        examDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        examDetail.courseCredit = [[[course objectAtIndex:3] firstChild] content];
        examDetail.courseDate = [[[course objectAtIndex:7] firstChild] content];
        examDetail.courseLocation = [[[course objectAtIndex:8] firstChild] content];
        examDetail.courseSeat = [[[course objectAtIndex:9] firstChild] content];
        NSData *examDetailData = [[NSData alloc] init];
        examDetailData = [NSKeyedArchiver archivedDataWithRootObject:examDetail];
        [sum addObject:examDetailData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sum forKey:@"exam1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setPostValue:viewstate forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:@"xqd" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"1|冬" forKey:@"xqd"];
    int year = [self getCurrentYear];
    if ([self getCurrentMonth] < 9) {
        year --;
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d", year, year + 1] forKey:@"xnd"];
    [requestForm setDelegate:self];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm setDidFinishSelector:@selector(step3:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)step3:(ASIFormDataRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        GZExamDetail *examDetail = [[GZExamDetail alloc] init];
        examDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        examDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        examDetail.courseCredit = [[[course objectAtIndex:3] firstChild] content];
        examDetail.courseDate = [[[course objectAtIndex:7] firstChild] content];
        examDetail.courseLocation = [[[course objectAtIndex:8] firstChild] content];
        examDetail.courseSeat = [[[course objectAtIndex:9] firstChild] content];
        NSData *examDetailData = [[NSData alloc] init];
        examDetailData = [NSKeyedArchiver archivedDataWithRootObject:examDetail];
        [sum addObject:examDetailData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sum forKey:@"exam2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setPostValue:viewstate forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:@"xqd" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"1|短" forKey:@"xqd"];
    int year = [self getCurrentYear];
    if ([self getCurrentMonth] < 9) {
        year --;
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d", year, year + 1] forKey:@"xnd"];
    [requestForm setDelegate:self];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm setDidFinishSelector:@selector(step4:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)step4:(ASIFormDataRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        GZExamDetail *examDetail = [[GZExamDetail alloc] init];
        examDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        examDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        examDetail.courseCredit = [[[course objectAtIndex:3] firstChild] content];
        examDetail.courseDate = [[[course objectAtIndex:7] firstChild] content];
        examDetail.courseLocation = [[[course objectAtIndex:8] firstChild] content];
        examDetail.courseSeat = [[[course objectAtIndex:9] firstChild] content];
        NSData *examDetailData = [[NSData alloc] init];
        examDetailData = [NSKeyedArchiver archivedDataWithRootObject:examDetail];
        [sum addObject:examDetailData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sum forKey:@"exam3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setPostValue:viewstate forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:@"xqd" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"2|春" forKey:@"xqd"];
    int year = [self getCurrentYear];
    if ([self getCurrentMonth] < 9) {
        year --;
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d", year, year + 1] forKey:@"xnd"];
    [requestForm setDelegate:self];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm setDidFinishSelector:@selector(step5:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)step5:(ASIFormDataRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        GZExamDetail *examDetail = [[GZExamDetail alloc] init];
        examDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        examDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        examDetail.courseCredit = [[[course objectAtIndex:3] firstChild] content];
        examDetail.courseDate = [[[course objectAtIndex:7] firstChild] content];
        examDetail.courseLocation = [[[course objectAtIndex:8] firstChild] content];
        examDetail.courseSeat = [[[course objectAtIndex:9] firstChild] content];
        NSData *examDetailData = [[NSData alloc] init];
        examDetailData = [NSKeyedArchiver archivedDataWithRootObject:examDetail];
        [sum addObject:examDetailData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sum forKey:@"exam4"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setPostValue:viewstate forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:@"xqd" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"2|夏" forKey:@"xqd"];
    int year = [self getCurrentYear];
    if ([self getCurrentMonth] < 9) {
        year --;
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d", year, year + 1] forKey:@"xnd"];
    [requestForm setDelegate:self];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm setDidFinishSelector:@selector(step6:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)step6:(ASIFormDataRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        GZExamDetail *examDetail = [[GZExamDetail alloc] init];
        examDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        examDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        examDetail.courseCredit = [[[course objectAtIndex:3] firstChild] content];
        examDetail.courseDate = [[[course objectAtIndex:7] firstChild] content];
        examDetail.courseLocation = [[[course objectAtIndex:8] firstChild] content];
        examDetail.courseSeat = [[[course objectAtIndex:9] firstChild] content];
        NSData *examDetailData = [[NSData alloc] init];
        examDetailData = [NSKeyedArchiver archivedDataWithRootObject:examDetail];
        [sum addObject:examDetailData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sum forKey:@"exam5"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *xuehao = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xskscx.aspx?xh=%@", xuehao]];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setPostValue:viewstate forKey:@"__VIEWSTATE"];
    [requestForm setPostValue:@"xqd" forKey:@"__EVENTTARGET"];
    [requestForm setPostValue:@"2|短" forKey:@"xqd"];
    int year = [self getCurrentYear];
    if ([self getCurrentMonth] < 9) {
        year --;
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d", year, year + 1] forKey:@"xnd"];
    [requestForm setDelegate:self];
    [requestForm setDefaultResponseEncoding:kCFStringEncodingUTF8];
    [requestForm setDidFinishSelector:@selector(step7:)];
    [requestForm setDidFailSelector:@selector(requestError:)];
    [requestForm startAsynchronous];
}

- (void)step7:(ASIFormDataRequest *)request
{
    NSString *temp = [[NSString alloc] initWithData:[request responseData] encoding:GB2312_ENCODING];
    temp = [temp stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
    NSData *parserData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    temp = [[NSString alloc] initWithData:parserData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", temp);
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:parserData];
    //NSArray *tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *tableNode = [parser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
    //TFHppleElement *childNode = [tableNode objectAtIndex:0];
//    NSString *viewstate = [[tableNode objectAtIndex:0] objectForKey:@"value"];
    tableNode = [parser searchWithXPathQuery:@"//table[@id='DataGrid1']"];
    NSArray *childNode = [[tableNode firstObject] children];
    int count = [childNode count] - 3;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    for (int i = 2; i < count + 2; i ++) {
        TFHppleElement *element = [childNode objectAtIndex:i];
        NSArray *course = [element children];
        GZExamDetail *examDetail = [[GZExamDetail alloc] init];
        examDetail.courseNumber = [[[course objectAtIndex:1] firstChild] content];
        examDetail.courseName = [[[course objectAtIndex:2] firstChild] content];
        examDetail.courseCredit = [[[course objectAtIndex:3] firstChild] content];
        examDetail.courseDate = [[[course objectAtIndex:7] firstChild] content];
        examDetail.courseLocation = [[[course objectAtIndex:8] firstChild] content];
        examDetail.courseSeat = [[[course objectAtIndex:9] firstChild] content];
        NSData *examDetailData = [[NSData alloc] init];
        examDetailData = [NSKeyedArchiver archivedDataWithRootObject:examDetail];
        [sum addObject:examDetailData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sum forKey:@"exam6"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showNotification:@"success" andMessage:@"所有考试信息刷新成功啦! :)"];
    [self setIndexOfExam];
//    [self setActiveContentIndex:0];
//    [self setActiveTabIndex:0];
    [self reloadData];
    NSLog(@"ALL YEARS COMPLETED!!!");
    [self goToCurrentPage];
    [self setAllInteractionEnabled:YES];
}

- (void)setIndexOfExam
{
    NSMutableArray *indexOfExam = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 6; i ++) {
        NSMutableArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"exam%d", i]];
        if ([temp count] > 0) {
            [indexOfExam addObject:[NSString stringWithFormat:@"exam%d", i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:indexOfExam forKey:@"indexOfExam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)requestError:(ASIFormDataRequest *)requestForm
{
    NSLog(@"%@", [requestForm error]);
    [self showNotification:@"error" andMessage:@"连接网络失败! :("];
    //[examQueue cancelAllOperations];
//    [self setIndexOfExam];
//    [self setActiveContentIndex:0];
//    [self setActiveTabIndex:0];
    [self reloadData];
    [self setAllInteractionEnabled:YES];
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

- (IBAction)resfreshButton:(UIButton *)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        [self setActiveContentIndex:0];
        [self setActiveTabIndex:0];
        [self loginFirst];
    }else {
        [self showNotification:@"error" andMessage:@"你还没登录呢. :("];
    }
}

- (NSInteger)getCurrentYear
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    return [components year];
}

- (NSInteger)getCurrentMonth
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    return [components month];
}
@end
