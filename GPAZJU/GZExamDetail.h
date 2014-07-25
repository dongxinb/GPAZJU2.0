//
//  GZExamDetail.h
//  GPAZJU
//
//  Created by 董鑫宝 on 13-12-2.
//  Copyright (c) 2013年 Xinbao Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZExamDetail : NSObject<NSCoding>{
    NSString *courseNumber;
    NSString *courseDate;
    NSString *courseLocation;
    NSString *courseSeat;
    NSString *courseName;
    NSString *courseCredit;
}
@property (nonatomic, retain)NSString *courseName;
@property (nonatomic, retain)NSString *courseNumber;
@property (nonatomic, retain)NSString *courseDate;
@property (nonatomic, retain)NSString *courseLocation;
@property (nonatomic, retain)NSString *courseSeat;
@property (nonatomic, retain)NSString *courseCredit;
@end
