//
//  DBHelper.h
//  PersistenceLayer
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define DB_FILE_NAME @"app.db"

static sqlite3 *db;

NS_ASSUME_NONNULL_BEGIN

@interface DBHelper : NSObject

// 获得沙箱Document目录下的全路径
+ (const char *)applicationDocumentsDirectoryFile:(NSString *)fileName;

// 初始化并加载数据
+ (void)initDB;

// 从数据库获得当前数据库的版本号
+ (int)dbVersionNumber;

@end

NS_ASSUME_NONNULL_END
