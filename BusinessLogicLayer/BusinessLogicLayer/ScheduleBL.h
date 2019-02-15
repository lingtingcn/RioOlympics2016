//
//  ScheduleBL.h
//  BusinessLogicLayer
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PersistenceLayer/PersistenceLayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleBL : NSObject
- (NSMutableDictionary *)readData;
@end

NS_ASSUME_NONNULL_END
