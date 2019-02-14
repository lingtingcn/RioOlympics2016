//
//  DBHelper.m
//  PersistenceLayer
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper

+ (const char *)applicationDocumentsDirectoryFile:(NSString *)fileName {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    const char *cpath = [path UTF8String];
    return cpath;
}

// 初始化数据
+ (void)initDB {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[DBHelper class]];
    NSString *configTablePath = [frameworkBundle pathForResource:@"DBConfig" ofType:@"plist"];
    NSDictionary *configTable = [[NSDictionary alloc] initWithContentsOfFile:configTablePath];
    // 从配置文件中获得数据库的版本号
    NSNumber *dbConfigVersion = configTable[@"DB_VERSION"];
    if (dbConfigVersion == nil) {
        dbConfigVersion = 0;
    }
    // 从数据库的DBVersionInfo表记录返回的数据库版本号
    int versionNumber = [DBHelper dbVersionNumber];
    // 版本号不一致
    if ([dbConfigVersion intValue] != versionNumber) {
        const char *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
        if (sqlite3_open(dbFilePath, &db) == SQLITE_OK) {
            // 加载数据到业务表中
            NSLog(@"数据库升级...");
            NSString *createtablePath = [frameworkBundle pathForResource:@"create_load" ofType:@"sql"];
            NSString *sql = [[NSString alloc] initWithContentsOfFile:createtablePath encoding:NSUTF8StringEncoding error:nil];
            sqlite3_exec(db, [sql UTF8String], nil, nil, nil);
            // 把当前版本号写回到文件中
            NSString *usql = [[NSString alloc] initWithFormat:@"update DBVersionInfo set version_number = %i", [dbConfigVersion intValue]];
            sqlite3_exec(db, [usql UTF8String], nil, nil, nil);
        } else {
            NSLog(@"数据库打开失败");
        }
        sqlite3_close(db);
    }
}

+ (int)dbVersionNumber {
    int versionNumber = -1;
    const char *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
    if (sqlite3_open(dbFilePath, &db) == SQLITE_OK) {
        NSString *sql = @"create table if not exists DBVersionInfo(version_number int)";
        sqlite3_exec(db, [sql UTF8String], nil, nil, nil);
        NSString *qsql = @"select version_number from DBVersionInfo";
        const char *cqsql = [qsql UTF8String];
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, cqsql, -1, &statement, nil) == SQLITE_OK) {
            // 执行查询
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSLog(@"有数据情况");
                versionNumber = sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"无数据情况");
                NSString *insertSql = @"insert into DBVersionInfo(version_number) values(-1)";
                const char *cInsertSql = [insertSql UTF8String];
                sqlite3_exec(db, cInsertSql, nil, nil, nil);
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    } else {
        sqlite3_close(db);
    }
    return versionNumber;
}

@end
