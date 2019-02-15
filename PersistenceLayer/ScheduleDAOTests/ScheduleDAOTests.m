//
//  ScheduleDAOTests.m
//  ScheduleDAOTests
//
//  Created by lee on 2019/2/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Events.h"
#import "Schedule.h"
#import "ScheduleDAO.h"

@interface ScheduleDAOTests : XCTestCase

@property (strong, nonatomic) ScheduleDAO *dao;

@property (strong, nonatomic) Schedule *theSchedule;

@end

@implementation ScheduleDAOTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.dao = [ScheduleDAO sharedInstance];
    self.theSchedule = [[Schedule alloc] init];
    self.theSchedule.gameDate = @"test GameDate";
    self.theSchedule.gameTime = @"test GameTime";
    self.theSchedule.gameInfo = @"test GameInfo";
    Events *event = [[Events alloc] init];
    event.EventID = 1;
    self.theSchedule.event = event;
//    self.continueAfterFailure = NO; // 当出错后是否继续向下执行
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.dao = nil;
    [super tearDown];
}

// 测试添加方法
// 测试插入Events的方法
- (void)test_1_Create {
    int res = [self.dao create:self.theSchedule];
    // 断言无异常，返回值为0
    XCTAssertEqual(res, 0);
}

// 测试按照主键查询数据的方法
- (void)test_2_FindById {
    self.theSchedule.scheduleID = 502;
    Schedule *resSchedule = [self.dao findById:self.theSchedule];
    NSLog(@"数据1：%@", resSchedule.gameDate);
    NSLog(@"数据2：%@", resSchedule.gameTime);
    NSLog(@"数据3：%@", resSchedule.gameInfo);
    NSLog(@"数据4：%d", resSchedule.event.EventID);
    // 断言查询结果非nil
    XCTAssertNotNil(resSchedule, @"查询记录为空");
    // 断言
    XCTAssertEqualObjects(self.theSchedule.gameDate, resSchedule.gameDate);
    XCTAssertEqualObjects(self.theSchedule.gameTime, resSchedule.gameTime);
    XCTAssertEqualObjects(self.theSchedule.gameInfo, resSchedule.gameInfo);
    XCTAssertEqual(self.theSchedule.event.EventID, resSchedule.event.EventID);
}

// 测试查询所有数据的方法
- (void)test_3_FindAll {
    NSArray *list = [self.dao findAll];
    NSLog(@"list的总数:%ld", [list count]);
    
    // 断言查询记录数为501
    XCTAssertEqual([list count], 502);
    Schedule *resSchedule = list[501];
    // 断言
    XCTAssertEqualObjects(self.theSchedule.gameDate, resSchedule.gameDate);
    XCTAssertEqualObjects(self.theSchedule.gameTime, resSchedule.gameTime);
    XCTAssertEqualObjects(self.theSchedule.gameInfo, resSchedule.gameInfo);
    XCTAssertEqual(self.theSchedule.event.EventID, resSchedule.event.EventID);
    
    for (Schedule *s in list) {
        NSLog(@"%d-%@-%d", s.scheduleID, s.gameInfo, s.event.EventID);
    }
}

// 测试修改Events的方法
- (void)test_4_Modify {
    self.theSchedule.scheduleID = 502;
    self.theSchedule.gameInfo = @"test modify GameInfo";
    int res = [self.dao modify:self.theSchedule];
    // 断言无异常，返回值为0
    XCTAssertEqual(res, 0);
    Schedule *resSchedule = [self.dao findById:self.theSchedule];
    // 断言查询结果为非nil
    XCTAssertNotNil(resSchedule, @"查询记录为空");
    // 断言
    XCTAssertEqualObjects(self.theSchedule.gameDate, resSchedule.gameDate);
    XCTAssertEqualObjects(self.theSchedule.gameTime, resSchedule.gameTime);
    XCTAssertEqualObjects(self.theSchedule.gameInfo, resSchedule.gameInfo);
    XCTAssertEqual(self.theSchedule.event.EventID, resSchedule.event.EventID);
}

// 测试删除方法
- (void)test_5_Remove {
    self.theSchedule.scheduleID = 502;
    int res = [self.dao remove:self.theSchedule];
    // 断言无异常，返回值为0
    XCTAssertEqual(res, 0);
    //    Events *resEvent = [self.dao findById:self.theEvents];
    //    // 断言查询结果为nil
    //    XCTAssertNil(resEvent, @"记录删除失败");
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
