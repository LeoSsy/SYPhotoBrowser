//
//  NSData+SY.h
//  Tianmushan
//
//  Created by shushaoyong on 2016/10/28.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SY)

/**
 *  计算两个时间的相差的秒数
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return 差值
 */
+ (long)dateDifferStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;


/**
 *  返回一个格式化好的年月日的格式时间字符串
 *
 *  @return 返回格式化的时间字符串
 */
- (NSString*)dateFormatterYMD;

@end
