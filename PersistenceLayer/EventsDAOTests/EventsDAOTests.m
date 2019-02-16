//
//  EventsDAOTests.m
//  EventsDAOTests
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "DBHelper.h"
#import "Events.h"
#import "EventsDAO.h"

@interface EventsDAOTests : XCTestCase

@property (nonatomic, strong) EventsDAO *dao;

@property (nonatomic, strong) Events *theEvents;

@end

@implementation EventsDAOTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    // 创建EventsDAO对象
    self.dao = [EventsDAO sharedInstance];
    // 创建Event对象
    self.theEvents = [[Events alloc] init];
    self.theEvents.EventName = @"test EventName";
    self.theEvents.EventIcon = @"test EventIcon";
    self.theEvents.KeyInfo = @"test KeyInfo";
    self.theEvents.BasicsInfo = @"test BasicsInfo";
    self.theEvents.OlympicInfo = @"test OlympicInfo";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.dao = nil;
    [super tearDown];
}

// 测试插入Events的方法
- (void)test_1_Create {
    int res = [self.dao create:self.theEvents];
    // 断言无异常，返回值为0
    XCTAssertEqual(res, 0);
}

// 测试按照主键查询数据的方法
- (void)test_2_FindById {
    self.theEvents.EventID = 41;
    Events *resEvent = [self.dao findById:self.theEvents];
    // 断言查询结果非nil
    XCTAssertNotNil(resEvent, @"查询记录为空");
    // 断言
    XCTAssertEqualObjects(self.theEvents.EventName, resEvent.EventName);
    XCTAssertEqualObjects(self.theEvents.EventIcon, resEvent.EventIcon);
    XCTAssertEqualObjects(self.theEvents.KeyInfo, resEvent.KeyInfo);
    XCTAssertEqualObjects(self.theEvents.BasicsInfo, resEvent.BasicsInfo);
    XCTAssertEqualObjects(self.theEvents.OlympicInfo, resEvent.OlympicInfo);
}

// 测试查询所有数据的方法
- (void)test_3_FindAll {
    NSArray *list = [self.dao findAll];
    NSLog(@"list的总数:%ld", [list count]);
    
    // 断言查询记录数为41
    XCTAssertEqual([list count], 41);
    Events *resEvent = list[40];
    // 断言
    XCTAssertEqualObjects(self.theEvents.EventName, resEvent.EventName);
    XCTAssertEqualObjects(self.theEvents.EventIcon, resEvent.EventIcon);
    XCTAssertEqualObjects(self.theEvents.KeyInfo, resEvent.KeyInfo);
    XCTAssertEqualObjects(self.theEvents.BasicsInfo, resEvent.BasicsInfo);
    XCTAssertEqualObjects(self.theEvents.OlympicInfo, resEvent.OlympicInfo);
    
    for (Events *e in list) {
        NSLog(@"%d-%@", e.EventID, e.EventName);
    }
    
}

// 测试修改Events的方法
- (void)test_4_Modify {
    self.theEvents.EventID = 41;
    self.theEvents.EventName = @"test modify EventName";
    int res = [self.dao modify:self.theEvents];
    // 断言无异常，返回值为0
    XCTAssertEqual(res, 0);
    Events *resEvents = [self.dao findById:self.theEvents];
    // 断言查询结果为非nil
    XCTAssertNotNil(resEvents, @"查询记录为空");
    // 断言
    XCTAssertEqualObjects(self.theEvents.EventName, resEvents.EventName);
    XCTAssertEqualObjects(self.theEvents.EventIcon, resEvents.EventIcon);
    XCTAssertEqualObjects(self.theEvents.KeyInfo, resEvents.KeyInfo);
    XCTAssertEqualObjects(self.theEvents.BasicsInfo, resEvents.BasicsInfo);
    XCTAssertEqualObjects(self.theEvents.OlympicInfo, resEvents.OlympicInfo);
}

// 测试删除方法
- (void)test_5_Remove {
    self.theEvents.EventID = 42;
    int res = [self.dao remove:self.theEvents];
    // 断言无异常，返回值为0
    XCTAssertEqual(res, 0);
//    Events *resEvent = [self.dao findById:self.theEvents];
//    // 断言查询结果为nil
//    XCTAssertNil(resEvent, @"记录删除失败");
}

// 测试数据库版本号
- (void)test_6_sqlVersion {
    NSLog(@"数据库版本：%d", [DBHelper dbVersionNumber]);
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
