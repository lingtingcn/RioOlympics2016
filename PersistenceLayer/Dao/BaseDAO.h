//
//  BaseDAO.h
//  PersistenceLayer
//
//  Created by 李超 on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DBHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseDAO : NSObject {
    sqlite3 *db;
}

// 打开SQlite数据库，如果返回值为true，表示打开成功，如果为false，表示打开失败
- (BOOL)openDB;

@end

NS_ASSUME_NONNULL_END
