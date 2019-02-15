//
//  ScheduleBL.m
//  BusinessLogicLayer
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "ScheduleBL.h"

@implementation ScheduleBL
// 查询所有数据的方法
- (NSMutableDictionary *)readData {
    ScheduleDAO *scheduleDao = [ScheduleDAO sharedInstance];
    NSMutableArray *schedules = [scheduleDao findAll];
    NSMutableDictionary *resDict = [[NSMutableDictionary alloc] init];
    EventsDAO *eventsDao = [EventsDAO sharedInstance];
    // 延迟加载Events数据
    for (Schedule *schedule in schedules) {
        Events *event = [eventsDao findById:schedule.event];
        schedule.event = event;
        NSArray *allKey = [resDict allKeys];
        // 把NSMutableArray结构转化为NSMutableDictonary结构
        if ([allKey containsObject:schedule.gameDate]) {
            NSMutableArray *value = resDict[schedule.gameDate];
            [value addObject:schedule];
        } else {
            NSMutableArray *value = [[NSMutableArray alloc] init];
            [value addObject:schedule];
            resDict[schedule.gameDate] = value;
        }
    }
    return resDict;
}
@end
