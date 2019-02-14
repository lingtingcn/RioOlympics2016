//
//  BaseDAO.m
//  PersistenceLayer
//
//  Created by 李超 on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import "BaseDAO.h"

@implementation BaseDAO

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化数据
        [DBHelper initDB];
    }
    return self;
}

- (BOOL)openDB {
    const char *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
    NSLog(@"DBFilePath = %s", dbFilePath);
    if (sqlite3_open(dbFilePath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败。");
        return NO;
    }
    return YES;
}

@end
