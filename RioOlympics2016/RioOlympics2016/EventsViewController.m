//
//  EventsViewController.m
//  RioOlympics2016
//
//  Created by 李超 on 2019/2/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsViewCell.h"
#import "EventsDetailController.h"
#import <PersistenceLayer/PersistenceLayer.h>
#import <BusinessLogicLayer/BusinessLogicLayer.h>

@interface EventsViewController () {
    // 一行中的列数
    NSUInteger COL_COUNT;
}
@property (strong, nonatomic) NSArray *events;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // 如果是iPhone设备，列数为2
        COL_COUNT = 2;
    } else {
        // 如果是iPad设备，列数为5
        COL_COUNT = 5;
    }
    
    if (self.events == nil || [self.events count] == 0) {
        EventsBL *bl = [[EventsBL alloc] init];
        // 获取全部数据
        NSMutableArray *array = [bl readData];
        self.events = array;
        [self.collectionView reloadData];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = indexPaths[0];
        Events *event = self.events[indexPath.section * COL_COUNT + indexPath.row];
        EventsDetailController *detailVC = [segue destinationViewController];
        detailVC.event = event;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.events count] / COL_COUNT;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return COL_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell
    Events *event = [self.events objectAtIndex:(indexPath.section * COL_COUNT + indexPath.row)];
    cell.img.image = [UIImage imageNamed:event.EventIcon];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
