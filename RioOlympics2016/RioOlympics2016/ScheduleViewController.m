//
//  ScheduleViewController.m
//  RioOlympics2016
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "ScheduleViewController.h"
#import "EventsDetailController.h"
#import <PersistenceLayer/PersistenceLayer.h>
#import <BusinessLogicLayer/BusinessLogicLayer.h>

@interface ScheduleViewController ()
// 表视图使用数据
@property (strong, nonatomic) NSDictionary *data;
// 比赛日期列表
@property (strong, nonatomic) NSArray *arrayGameDateList;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.data == nil || [self.data count] == 0) {
        ScheduleBL *bl = [[ScheduleBL alloc] init];
        self.data = [bl readData];
        NSArray *keys = [self.data allKeys];
        // 对key进行排序
        self.arrayGameDateList = [keys sortedArrayUsingSelector:@selector(compare:)];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSArray *keys = [self.data allKeys];
//    NSLog(@"字典总数：%ld", keys.count);
//    NSLog(@"字典总数2：%ld", self.arrayGameDateList.count);
//    return [keys count];
    return self.arrayGameDateList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 比赛日期
    NSString *strGameDate = self.arrayGameDateList[section];
    // 比赛日期下的比赛日程表
    NSArray *schedules = self.data[strGameDate];
    return schedules.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 比赛日期
    NSString *strGameDate = self.arrayGameDateList[section];
    return strGameDate;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    // 比赛日期
    NSString *strGameDate = self.arrayGameDateList[indexPath.section];
    // 比赛日期下的比赛日程表
    NSArray *schedules = self.data[strGameDate];
    Schedule *schedule = schedules[indexPath.row];
    NSString *subtitle = [[NSString alloc] initWithFormat:@"%@ | %@", schedule.gameInfo, schedule.event.EventName];
    cell.textLabel.text = schedule.gameTime;
    cell.detailTextLabel.text = subtitle;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *listTitles = [[NSMutableArray alloc] init];
    // 2016-08-09 -> 08-09
    for (NSString *item in self.arrayGameDateList) {
        NSString *title = [item substringFromIndex:5];
        [listTitles addObject:title];
    }
    return listTitles;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
