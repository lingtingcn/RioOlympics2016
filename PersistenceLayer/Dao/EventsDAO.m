//
//  EventsDAO.m
//  PersistenceLayer
//
//  Created by lee on 2019/2/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import "EventsDAO.h"

@implementation EventsDAO

static EventsDAO *sharedSingleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
        NSLog(@"执行了初始化操作");
    });
    return sharedSingleton;
}

// 插入Events方法
- (int)create:(Events *)model {
    if ([self openDB]) {
        NSString *sqlStr = @"INSERT INTO Events (EventName, EventIcon, keyInfo, BasicsInfo, OlympicInfo) VALUES (?,?,?,?,?)";
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            // 绑定参数开始
            sqlite3_bind_text(statement, 1, [model.EventName UTF8String], -1, nil);
            sqlite3_bind_text(statement, 2, [model.EventIcon UTF8String], -1, nil);
            sqlite3_bind_text(statement, 3, [model.KeyInfo UTF8String], -1, nil);
            sqlite3_bind_text(statement, 4, [model.BasicsInfo UTF8String], -1, nil);
            sqlite3_bind_text(statement, 5, [model.OlympicInfo UTF8String], -1, nil);
            // 执行插入
            if (sqlite3_step(statement) != SQLITE_DONE) {
                sqlite3_finalize(statement);
                sqlite3_close(db);
                NSAssert(NO, @"插入数据失败。");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    NSLog(@"总数为：%ld", [[self findAll] count]);
    return 0;
}

// 删除方法
- (int)remove:(Events *)model {
    if ([self openDB]) {
        // 先删从表（比赛日程表）相关数据
        NSString *sqlScheduleStr = [[NSString alloc] initWithFormat:@"DELETE FROM Schedule WHERE EventID=%i", model.EventID];
        // 开启事务，立刻提交之前事务
        sqlite3_exec(db, "BEGIN IMMEDIATE TRANSACTION", nil, nil, nil);
        char *err;
        if (sqlite3_exec(db, [sqlScheduleStr UTF8String], nil, nil, &err) != SQLITE_OK) {
            //回滚事务
            sqlite3_exec(db, "ROLLBACK TRANSACTION", nil, nil, nil);
            NSAssert(NO, @"删除比赛日程数据失败...");
        }
        // 先删除主表（比赛项目数据）
        NSString *sqlEventStr = [[NSString alloc] initWithFormat:@"DELETE FROM Events WHERE EventID = %i", model.EventID];
        if (sqlite3_exec(db, [sqlEventStr UTF8String], nil, nil, nil) != SQLITE_OK) {
            // 回滚事务
            sqlite3_exec(db, "ROLLBACK TRANSACTION", nil, nil, nil);
            NSAssert(NO, @"删除比赛项目数据失败");
        }
        // 提交事务
        sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil);
        sqlite3_close(db);
    }
    return 0;
}

// 修改方法
- (int)modify:(Events *)model {
    if ([self openDB]) {
        NSString *sql = @"UPDATE Events SET EventName=?, EventIcon=?, keyInfo=?, BasicsInfo=?, OlympicInfo=? where EventID=?";
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            NSString *eventName = model.EventName;
            const char *cEventName = [eventName UTF8String];
            NSString *eventIcon = model.EventIcon;
            const char *cEventIcon = [eventIcon UTF8String];
            NSString *keyInfo = model.KeyInfo;
            const char *cKeyInfo = [keyInfo UTF8String];
            NSString *basicsInfo = model.BasicsInfo;
            const char *cBasicsInfo = [basicsInfo UTF8String];
            NSString *olympicInfo = model.OlympicInfo;
            const char *cOlympicInfo = [olympicInfo UTF8String];
            sqlite3_bind_text(statement, 1, cEventName, -1, nil);
            sqlite3_bind_text(statement, 2, cEventIcon, -1, nil);
            sqlite3_bind_text(statement, 3, cKeyInfo, -1, nil);
            sqlite3_bind_text(statement, 4, cBasicsInfo, -1, nil);
            sqlite3_bind_text(statement, 5, cOlympicInfo, -1, nil);
            sqlite3_bind_int(statement, 6, model.EventID);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                sqlite3_finalize(statement);
                sqlite3_close(db);
                NSAssert(NO, @"更新数据失败。");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

// 查询所有数据方法
- (NSMutableArray *)findAll {
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    if ([self openDB]) {
        NSString *qsql = @"SELECT EventName, EventIcon, KeyInfo, BasicsInfo, OlympicInfo, EventID FROM Events";
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            // 执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Events *events = [[Events alloc] init];
                
                char *cEventName = (char *)sqlite3_column_text(statement, 0);
                events.EventName = [[NSString alloc] initWithUTF8String:cEventName];
                
                char *cEventIcon = (char *)sqlite3_column_text(statement, 1);
                events.EventIcon = [[NSString alloc] initWithUTF8String:cEventIcon];
                
                char *cKeyInfo = (char *)sqlite3_column_text(statement, 2);
                events.KeyInfo = [[NSString alloc] initWithUTF8String:cKeyInfo];
                
                char *cBasicsInfo = (char *)sqlite3_column_text(statement, 3);
                events.BasicsInfo = [[NSString alloc] initWithUTF8String:cBasicsInfo];
                
                char *cOlympicInfo = (char *)sqlite3_column_text(statement, 4);
                events.OlympicInfo = [[NSString alloc] initWithUTF8String:cOlympicInfo];
                
                events.EventID = sqlite3_column_int(statement, 5);
                
                [listData addObject:events];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return listData;
}

// 根据id进行查询
- (Events *)findById:(Events *)event {
    if ([self openDB]) {
//        NSLog(@"ID值3:%d", event.EventID);
        NSString *sql = [NSString stringWithFormat:@"SELECT EventName, EventIcon, KeyInfo, BasicsInfo, OlympicInfo, EventID FROM Events WHERE EventID = %d", event.EventID];
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            // 执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Events *events = [[Events alloc] init];
                
                char *cEventName = (char *)sqlite3_column_text(statement, 0);
                events.EventName = [[NSString alloc] initWithUTF8String:cEventName];
                
                char *cEventIcon = (char *)sqlite3_column_text(statement, 1);
                events.EventIcon = [[NSString alloc] initWithUTF8String:cEventIcon];
                
                char *cKeyInfo = (char *)sqlite3_column_text(statement, 2);
                events.KeyInfo = [[NSString alloc] initWithUTF8String:cKeyInfo];
                
                char *cBasicsInfo = (char *)sqlite3_column_text(statement, 3);
                events.BasicsInfo = [[NSString alloc] initWithUTF8String:cBasicsInfo];
                
                char *cOlympicInfo = (char *)sqlite3_column_text(statement, 4);
                events.OlympicInfo = [[NSString alloc] initWithUTF8String:cOlympicInfo];
                
                events.EventID = sqlite3_column_int(statement, 5);
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return events;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

@end
