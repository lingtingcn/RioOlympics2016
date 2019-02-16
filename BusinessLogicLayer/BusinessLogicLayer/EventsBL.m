//
//  EventsBL.m
//  BusinessLogicLayer
//
//  Created by lee on 2019/2/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "EventsBL.h"

@implementation EventsBL
- (NSMutableArray *)readData {
    EventsDAO *dao = [EventsDAO sharedInstance];
    NSMutableArray *list = [dao findAll];
    return list;
}
@end
