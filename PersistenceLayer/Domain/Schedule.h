//
//  Schedule.h
//  PersistenceLayer
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Events.h"

NS_ASSUME_NONNULL_BEGIN

// 比赛日程表实体类
@interface Schedule : NSObject

// 编号
@property (assign, nonatomic) int scheduleID;

// 比赛日期
@property (strong, nonatomic) NSString *gameDate;

// 比赛时间
@property (strong, nonatomic) NSString *gameTime;

// 比赛描述
@property (strong, nonatomic) NSString *gameInfo;

// 比赛项目
@property (strong, nonatomic) Events *event;

@end

NS_ASSUME_NONNULL_END
