//
//  GZGPADetail.m
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-29.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import "GZGPADetail.h"

@implementation GZGPADetail

@synthesize courseName, credit, grade, courseNumber, GPA, isSummary;

-(void)encodeWithCoder:(NSCoder *)aCoder//要一一对应
{
    [aCoder encodeObject:courseName forKey:@"courseName"];
    [aCoder encodeObject:grade forKey:@"grade"];
    [aCoder encodeDouble:GPA forKey:@"GPA"];
    [aCoder encodeDouble:credit forKey:@"credit"];
    [aCoder encodeObject:courseNumber forKey:@"courseNumber"];
    [aCoder encodeBool:isSummary forKey:@"isSummary"];
}

-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self = [super init]) {
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.GPA = [aDecoder decodeDoubleForKey:@"GPA"];
        self.credit = [aDecoder decodeDoubleForKey:@"credit"];
        self.courseNumber = [aDecoder decodeObjectForKey:@"courseNumber"];
        self.isSummary = [aDecoder decodeBoolForKey:@"isSummary"];
        
    }
    return self;
}

@end
