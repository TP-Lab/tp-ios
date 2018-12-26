//
//  NSDate+TPOS.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/27.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "NSDate+TPOS.h"
#import "TPOSLocalizedHelper.h"

@implementation NSDate (TPOS)

+ (NSString *)dateDescriptionFrom:(NSInteger)timestamp {
    NSDate *inBegin = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [[self class] dateDescriptionFromDate:inBegin];
}

+ (NSString *)dateDescriptionFromUTC:(NSString *)utc {
    NSDate *date = [[self class] dateFromUTC:utc];
    return [[self class] dateDescriptionFromDate:date];
}

+ (NSString *)dateDescriptionFromDate:(NSDate *)date {
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
//    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"just_now"]];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld %@",temp,[[TPOSLocalizedHelper standardHelper] stringWithKey:temp>1?@"n_min_ago":@"one_min_ago"]];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld %@",temp,[[TPOSLocalizedHelper standardHelper] stringWithKey:temp>1?@"n_h_ago":@"one_h_ago"]];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld %@",temp,[[TPOSLocalizedHelper standardHelper] stringWithKey:temp>1?@"n_day_ago":@"one_day_ago"]];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld %@",temp,[[TPOSLocalizedHelper standardHelper] stringWithKey:temp>1?@"n_m_ago":@"one_m_ago"]];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld %@",temp,[[TPOSLocalizedHelper standardHelper] stringWithKey:temp>1?@"n_y_ago":@"one_y_ago"]];
    }
    
    return  [result copy];

}

+ (NSString *)tb_timeFormat:(NSInteger)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return [NSString stringWithFormat:@"%ld/%ld",comps.month,comps.day];
}

+ (NSDate *)dateFromUTC:(NSString *)utc {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *date = [formatter dateFromString:utc];
    return date;
}

@end
