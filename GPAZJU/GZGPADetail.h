//
//  GZGPADetail.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-11-29.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZGPADetail : NSObject <NSCoding>{
    NSString *courseName;
    NSString *grade;
    double credit;
    NSString *courseNumber;
    double GPA;
    BOOL isSummary;
}

@property (nonatomic, retain) NSString *courseName;
@property (nonatomic, retain) NSString *grade;
@property (nonatomic, assign) double credit;
@property (nonatomic, retain) NSString *courseNumber;
@property (nonatomic, assign) double GPA;
@property (nonatomic, assign) BOOL isSummary;

@end
