//
//  CountDownViewController.m
//  RioOlympics2016
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "CountDownViewController.h"

@interface CountDownViewController ()

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建NSDateComponents日期
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // 设置日期
    [comps setDay:5];
    // 设置月
    [comps setMonth:8];
    // 设置年
    [comps setYear:2016];
    
    // 创建日历对象
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获得2016-8-5的NSDate日期对象
    NSDate *destinationDate = [calendar dateFromComponents:comps];
    // 获得当前日期到2018-8-5的NSDateComponets对象
    NSDateComponents *componets = [calendar components:NSCalendarUnitDay fromDate:[NSDate date] toDate:destinationDate options:NSCalendarWrapComponents];
    // 获得当前日期到2018-8-5相差的天数
    NSInteger days = [componets day];
    NSMutableAttributedString *strLabel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li天", (long)days]];
    [strLabel addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:NSMakeRange(strLabel.length - 1, 1)];
    self.strLabel.attributedText = strLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
