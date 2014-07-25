//
//  GZCourse.h
//  GPAZJU
//
//  Created by Xinbao Dong on 14-4-9.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZCourse : NSObject<NSCoding>{
    NSString *courseName;
    NSString *courseID;
    NSInteger voteNumber;
    NSInteger commentNumber;
}
@property (nonatomic, retain) NSString *courseName;
@property (nonatomic, retain) NSString *courseID;
@property (nonatomic, assign) NSInteger voteNumber;
@property (nonatomic, assign) NSInteger commentNumber;
@end
