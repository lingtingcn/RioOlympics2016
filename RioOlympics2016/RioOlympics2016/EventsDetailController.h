//
//  EventsDetailController.h
//  RioOlympics2016
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PersistenceLayer/PersistenceLayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventsDetailController : UIViewController
@property (strong, nonatomic) Events *event;
@property (weak, nonatomic) IBOutlet UIImageView *imgEventIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblBasicsInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblKeyInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblOlympicInfo;

@end

NS_ASSUME_NONNULL_END
