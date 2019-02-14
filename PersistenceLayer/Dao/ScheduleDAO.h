//
//  ScheduleDAO.h
//  PersistenceLayer
//
//  Created by lee on 2019/2/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import "BaseDAO.h"
#import "Schedule.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleDAO : BaseDAO

+ (instancetype)sharedInstance;
// 插入Events方法
- (int)create:(Schedule *)model;
// 删除Events方法
- (int)remove:(Schedule *)model;
// 修改Events方法
- (int)modify:(Schedule *)model;
// 查询所有数据的方法
- (NSMutableArray *)findAll;
// 根据id进行查询
- (Schedule *)findById:(Schedule *)schedule;

@end

NS_ASSUME_NONNULL_END
