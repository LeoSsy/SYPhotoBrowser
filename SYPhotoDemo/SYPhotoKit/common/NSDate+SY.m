//
//  NSData+SY.m
//  Tianmushan
//
//  Created by shushaoyong on 2016/10/28.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import "NSDate+SY.h"

@implementation NSDate (SY)

+ (long)dateDifferStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    return [d hour]*3600+[d minute]*60+[d second];
}


- (NSString*)dateFormatterYMD;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}

@end
