//
//  EventsBL.h
//  BusinessLogicLayer
//
//  Created by 李超 on 2019/2/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PersistenceLayer/PersistenceLayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventsBL : NSObject
// 查询所有数据的方法
- (NSMutableArray *)readData;
@end

NS_ASSUME_NONNULL_END
