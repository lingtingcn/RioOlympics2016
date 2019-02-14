//
//  ScheduleDAO.m
//  PersistenceLayer
//
//  Created by lee on 2019/2/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import "ScheduleDAO.h"

@implementation ScheduleDAO

static ScheduleDAO *sharedSingleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
        NSLog(@"执行了初始化操作");
    });
    return sharedSingleton;
}

// 插入Events方法
- (int)create:(Schedule *)model {
    if ([self openDB]) {
        NSString *sqlStr = @"INSERT INTO Schedule (GameDate, GameTime, GameInfo, EventID) VALUES (?,?,?,?)";
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            // 绑定参数开始
            sqlite3_bind_text(statement, 1, [model.gameDate UTF8String], -1, nil);
            sqlite3_bind_text(statement, 2, [model.gameTime UTF8String], -1, nil);
            sqlite3_bind_text(statement, 3, [model.gameInfo UTF8String], -1, nil);
            sqlite3_bind_int(statement, 4, model.event.EventID);
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

// 删除Events方法
- (int)remove:(Schedule *)model {
    if ([self openDB]) {
        NSString *sql = @"DELETE FROM Schedule WHERE EventID = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, model.event.EventID);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"数据删除失败");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

// 修改Events方法
- (int)modify:(Schedule *)model {
    if ([self openDB]) {
        NSString *sql = @"UPDATE Schedule SET GameDate = ?, GameTime = ?, GameInfo = ?, EventID = ? WHERE ScheduleID = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.gameDate UTF8String], -1, nil);
            sqlite3_bind_text(statement, 2, [model.gameTime UTF8String], -1, nil);
            sqlite3_bind_text(statement, 3, [model.gameInfo UTF8String], -1, nil);
            sqlite3_bind_int(statement, 4, model.event.EventID);
            sqlite3_bind_int(statement, 5, model.scheduleID);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"数据修改失败");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

// 查询所有数据的方法
- (NSMutableArray *)findAll {
    if ([self openDB]) {
        NSMutableArray *listData = [[NSMutableArray alloc] init];
        NSString *sql = @"SELECT ScheduleID, GameDate, GameTime, GameInfo, EventID FROM Schedule";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Schedule *schedule = [[Schedule alloc] init];
                schedule.scheduleID = sqlite3_column_int(statement, 0);
                const char *cGameDate = (char *)sqlite3_column_text(statement, 1);
                schedule.gameDate = [[NSString alloc] initWithUTF8String:cGameDate];
                const char *cGameTime = (char *)sqlite3_column_text(statement, 2);
                schedule.gameTime = [[NSString alloc] initWithUTF8String:cGameTime];
                const char *cGameInfo = (char *)sqlite3_column_text(statement, 3);
                schedule.gameInfo = [[NSString alloc] initWithUTF8String:cGameInfo];
                schedule.event.EventID = sqlite3_column_int(statement, 4);
                [listData addObject:schedule];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return listData;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

// 根据id进行查询
- (Schedule *)findById:(Schedule *)schedule {
    if ([self openDB]) {
        NSString *sql = @"SELECT GameDate, GameTime, GameInfo, EventID FROM Schedule WHERE ScheduleID = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, schedule.scheduleID);
            while(sqlite3_step(statement) == SQLITE_ROW) {
                Schedule *schedule = [[Schedule alloc] init];
                const char *cGameDate = (char *)sqlite3_column_text(statement, 0);
                schedule.gameDate = [[NSString alloc] initWithUTF8String:cGameDate];
                const char *cGameTime = (char *)sqlite3_column_text(statement, 1);
                schedule.gameTime = [[NSString alloc] initWithUTF8String:cGameTime];
                const char *cGameInfo = (char *)sqlite3_column_text(statement, 2);
                schedule.gameInfo = [[NSString alloc] initWithUTF8String:cGameInfo];
                schedule.event.EventID = sqlite3_column_int(statement, 3);
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return schedule;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

@end
