//
//  EventsDetailController.m
//  RioOlympics2016
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "EventsDetailController.h"

@interface EventsDetailController ()

@end

@implementation EventsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imgEventIcon.image = [UIImage imageNamed:self.event.EventIcon];
    self.lblEventName.text = self.event.EventName;
    self.lblBasicsInfo.text = self.event.BasicsInfo;
    self.lblKeyInfo.text = self.event.KeyInfo;
    self.lblOlympicInfo.text = self.event.OlympicInfo;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clickDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
