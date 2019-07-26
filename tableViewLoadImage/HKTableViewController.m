//
//  HKTableViewController.m
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import "HKTableViewController.h"
#import "HKTableViewCell.h"
#import <UIImageView+WebCache.h>

#define kSCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height

static NSString *const kTableViewCellId = @"HKTableViewCell";

@interface HKTableViewController ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation HKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewCellId bundle:nil] forCellReuseIdentifier:kTableViewCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArr = @[@"https://tse4-mm.cn.bing.net/th?id=OIP.whIPuxYLj3wVLfCcSIz6HAHaLI&w=199&h=300&c=7&o=5&pid=1.7",@"https://tse4-mm.cn.bing.net/th?id=OIP.RvOnGHKVlVmhf_0JQrwWnQHaI8&w=200&h=241&c=7&o=5&pid=1.7",@"https://tse1-mm.cn.bing.net/th?id=OIP.zN8w4bxvQ-cNa59dt1JsgQHaFh&w=199&h=148&c=7&o=5&pid=1.7",@"https://tse3-mm.cn.bing.net/th?id=OIP.pPc_1sB4frtbmMJvyjDDDwAAAA&w=199&h=279&c=7&o=5&pid=1.7",@"https://tse4-mm.cn.bing.net/th?id=OIP.US-zhj5AOFoo4UCkmFb0ogHaI7&w=199&h=240&c=7&o=5&pid=1.7",@"https://tse4-mm.cn.bing.net/th?id=OIP.Vy2pNOvQbFmbgw73t43HzgHaKQ&w=199&h=276&c=7&o=5&pid=1.7",@"https://tse4-mm.cn.bing.net/th?id=OIP.V9fc8r5RyI0CNiSDLv9vdgHaLH&w=199&h=298&c=7&o=5&pid=1.7"];
    
    NSLog(@"缓存地址%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"/default"]);
    
    //SDWebImage会先从内存中找，找不到就下载，下次显示同前，可在模拟器上跑，然后打开缓存地址(点击Finder然后快捷键Common+Shift+G)，看图片实时下载,注意自定义cell中使用了prepareForReuse方法，这个是当单元格重用时的回调，取消当前下载与给图片先给一个值，避免还未下载图片重用单元格出现的刹那显示错乱。
    /**<第一种为：视图出现时就会下载图片，若是此图片还未下载成功将此单元格滑出屏幕，会取消滑出图片的下载转而下载此时出现的单元格的图片>**/
    /**<第二种为：视图首次出现、停止拖拽、停止减速时就会下载图片，若是此图片还未下载成功将此单元格滑出屏幕，会取消滑出图片的下载转而下载此时出现的单元格的图片>**/
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"第一种",@"第二种"]];
    self.segmentControl.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 40);
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(segmentControlChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
}

#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *nameArr = @[@"江疏影",@"赵丽颖",@"朱茵",@"张佳宁",@"许晴",@"热巴",@"陈钰琪"];
    HKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId forIndexPath:indexPath];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.dataArr[indexPath.row]];
    cell.titleLabel.text = nameArr[indexPath.row];
    if (cacheImage) {
        cell.imageVi.image = cacheImage;
    } else {
        if (self.segmentControl.selectedSegmentIndex == 0) {
            NSArray *cells = [self.tableView indexPathsForVisibleRows];
            if ([cells containsObject:indexPath]) {
                [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        } else {
            if (!tableView.isDragging && !tableView.isDecelerating) {
                [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 600;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (self.segmentControl.selectedSegmentIndex == 1) {//适用于第二种
            [self loadImageForCellRows];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.segmentControl.selectedSegmentIndex == 1) {//适用于第二种
        [self loadImageForCellRows];
    }
}

#pragma mark - 加载图片
- (void)loadImageForCellRows {
    NSArray *cells = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath * indexPath in cells) {
        HKTableViewCell *cell = (HKTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.dataArr[indexPath.row]];
        if (cacheImage) {
            cell.imageVi.image = cacheImage;
        } else {
            [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
    }
}

- (void)segmentControlChangeValue:(UISegmentedControl *)segmentControl {
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
}

@end
