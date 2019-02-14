//
//  EventsDAO.h
//  PersistenceLayer
//
//  Created by 李超 on 2019/2/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Events.h"
#import "BaseDAO.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventsDAO : BaseDAO

+ (instancetype)sharedInstance;
// 插入Events方法
- (int)create:(Events *)model;
// 删除Events方法
- (int)remove:(Events *)model;
// 修改Events方法
- (int)modify:(Events *)model;
// 查询所有数据的方法
- (NSMutableArray *)findAll;
// 根据id进行查询
- (Events *)findById:(Events *)event;

@end

NS_ASSUME_NONNULL_END
