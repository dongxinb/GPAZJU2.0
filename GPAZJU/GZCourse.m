//
//  GZCourse.m
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-9.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GZCourse.h"

@implementation GZCourse
@synthesize courseName, courseID, voteNumber, commentNumber;
-(void)encodeWithCoder:(NSCoder *)aCoder//要一一对应
{
    [aCoder encodeObject:courseName forKey:@"courseName"];
    [aCoder encodeObject:courseID forKey:@"courseID"];
    [aCoder encodeInteger:voteNumber forKey:@"voteNumber"];
    [aCoder encodeInteger:commentNumber forKey:@"commentNumber"];

}

-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self = [super init]) {
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        self.courseID = [aDecoder decodeObjectForKey:@"courseID"];
        self.voteNumber = [aDecoder decodeIntegerForKey:@"voteNumber"];
        self.commentNumber = [aDecoder decodeIntegerForKey:@"commentNumber"];
    }
    return self;
}
@end
