//
//  GZExamDetail.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZExamDetail.h"

@implementation GZExamDetail
@synthesize courseDate, courseSeat, courseNumber, courseLocation, courseName, courseCredit;

-(void)encodeWithCoder:(NSCoder *)aCoder//要一一对应
{
    [aCoder encodeObject:courseNumber forKey:@"courseNumber"];
    [aCoder encodeObject:courseDate forKey:@"courseDate"];
    [aCoder encodeObject:courseLocation forKey:@"courseLocation"];
    [aCoder encodeObject:courseSeat forKey:@"courseSeat"];
    [aCoder encodeObject:courseName forKey:@"courseName"];
    [aCoder encodeObject:courseCredit forKey:@"courseCredit"];
}

-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self = [super init]) {
        self.courseNumber = [aDecoder decodeObjectForKey:@"courseNumber"];
        self.courseDate = [aDecoder decodeObjectForKey:@"courseDate"];
        self.courseSeat = [aDecoder decodeObjectForKey:@"courseSeat"];
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        self.courseLocation = [aDecoder decodeObjectForKey:@"courseLocation"];
        self.courseCredit = [aDecoder decodeObjectForKey:@"courseCredit"];
    }
    return self;
}

@end
