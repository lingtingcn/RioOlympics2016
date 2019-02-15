//
//  EventsBLTests.m
//  EventsBLTests
//
//  Created by 李超 on 2019/2/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EventsBL.h"
#import <PersistenceLayer/PersistenceLayer.h>

@interface EventsBLTests : XCTestCase
@property (strong, nonatomic) EventsBL *bl;
@property (strong, nonatomic) Events *theEvents;
@end

@implementation EventsBLTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.bl = [[EventsBL alloc] init];
    self.theEvents = [[Events alloc] init];
    self.theEvents.EventName = @"test EventName";
    self.theEvents.EventIcon = @"test EventIcon";
    self.theEvents.KeyInfo = @"test KeyInfo";
    self.theEvents.BasicsInfo = @"test BasicsInfo";
    self.theEvents.OlympicInfo = @"test OlympicInfo";
    // 插入数据测试
    EventsDAO *dao = [EventsDAO sharedInstance];
    [dao create:self.theEvents];
}



- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    // 删除测试数据
    self.theEvents.EventID = 41;
    EventsDAO *dao = [EventsDAO sharedInstance];
    [dao remove:self.theEvents];
    self.bl = nil;
}

// 测试按照主键查询数据的方法
- (void)testFindAll {
    NSArray *list = [self.bl readData];
    // 断言查询记录数为42
    XCTAssertEqual(list.count, 42);
    Events *resEvent = list[40];
    // 断言
    XCTAssertEqualObjects(self.theEvents.EventName, resEvent.EventName, @"比赛项目名测试失败");
    XCTAssertEqualObjects(self.theEvents.EventIcon, resEvent.EventIcon, @"比赛项目图标测试失败");
    XCTAssertEqualObjects(self.theEvents.KeyInfo, resEvent.KeyInfo, @"项目关键信息测试失败");
    XCTAssertEqualObjects(self.theEvents.BasicsInfo, resEvent.BasicsInfo, @"项目基本信息测试失败");
    XCTAssertEqualObjects(self.theEvents.OlympicInfo, resEvent.OlympicInfo, @"项目奥运会历史信息测试失败");
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
