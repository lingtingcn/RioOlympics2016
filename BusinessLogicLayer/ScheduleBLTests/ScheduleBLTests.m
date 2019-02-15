//
//  ScheduleBLTests.m
//  ScheduleBLTests
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PersistenceLayer/PersistenceLayer.h>
#import "ScheduleBL.h"

@interface ScheduleBLTests : XCTestCase
@property (strong, nonatomic) ScheduleBL *bl;
@property (strong, nonatomic) Schedule *theSchedule;
@end

@implementation ScheduleBLTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.bl = [[ScheduleBL alloc] init];
    self.theSchedule = [[Schedule alloc] init];
    self.theSchedule.gameDate = @"test GameDate";
    self.theSchedule.gameTime = @"test GameTime";
    self.theSchedule.gameInfo = @"test GameInfo";
    Events *event = [Events new];
    event.EventName = @"Cycling Mountain Bike";
    event.EventID = 10;
    self.theSchedule.event = event;
    // 插入数据测试
    ScheduleDAO *dao = [ScheduleDAO sharedInstance];
    [dao create:self.theSchedule];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    // 删除测试数据
    self.theSchedule.scheduleID = 502;
    ScheduleDAO *dao = [ScheduleDAO sharedInstance];
    [dao remove:self.theSchedule];
    self.bl = nil;
    [super tearDown];
}

// 测试按照主键查询数据的方法
- (void)testFindAll {
    NSMutableDictionary *dict = [self.bl readData];
    NSArray *allKey = [dict allKeys];
    // 断言查询记录数为18
    XCTAssertEqual(allKey.count, 18);
    NSArray *schedules = dict[self.theSchedule.gameDate];
    NSLog(@"字典数据：%@", schedules[0]);
    Schedule *resSchedule = schedules[0];
    // 断言
    XCTAssertEqualObjects(self.theSchedule.gameDate, resSchedule.gameDate);
    XCTAssertEqualObjects(self.theSchedule.gameTime, resSchedule.gameTime);
    XCTAssertEqualObjects(self.theSchedule.gameInfo, resSchedule.gameInfo);
    XCTAssertEqual(self.theSchedule.event.EventID, resSchedule.event.EventID);
    XCTAssertEqualObjects(self.theSchedule.event.EventName, resSchedule.event.EventName);
}

/*
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
 */

@end
