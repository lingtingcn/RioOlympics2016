//
//  Events.h
//  PersistenceLayer
//
//  Created by 李超 on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 比赛项目实体类
@interface Events : NSObject

// 编号
@property (assign, nonatomic) int EventID;

// 项目名
@property (strong, nonatomic) NSString *EventName;

// 项目图标
@property (strong, nonatomic) NSString *EventIcon;

// 项目关键信息
@property (strong, nonatomic) NSString *KeyInfo;

// 项目基本信息
@property (strong, nonatomic) NSString *BasicsInfo;

// 项目奥运会历史信息
@property (strong, nonatomic) NSString *OlympicInfo;

@end

NS_ASSUME_NONNULL_END
