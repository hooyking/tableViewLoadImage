//
//  HKTableViewController.m
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import "HKTableViewController.h"
#import "HKTableViewCell.h"
#import "PersonModel.h"

static NSString *const kTableViewCellId = @"HKTableViewCell";

@interface HKTableViewController ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation HKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeholderImage = [[UIImage imageNamed:@"placeholder"] drawImageWithSize:CGSizeMake(kSCREEN_WIDTH, 600)];
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewCellId bundle:nil] forCellReuseIdentifier:kTableViewCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSArray *pictureArr = @[@"https://tse4-mm.cn.bing.net/th?id=OIP.whIPuxYLj3wVLfCcSIz6HAHaLI&w=199&h=300&c=7&o=5&pid=1.7",
                            @"https://tse4-mm.cn.bing.net/th?id=OIP.RvOnGHKVlVmhf_0JQrwWnQHaI8&w=200&h=241&c=7&o=5&pid=1.7",
                            @"https://tse1-mm.cn.bing.net/th?id=OIP.zN8w4bxvQ-cNa59dt1JsgQHaFh&w=199&h=148&c=7&o=5&pid=1.7",
                            @"https://tse3-mm.cn.bing.net/th?id=OIP.pPc_1sB4frtbmMJvyjDDDwAAAA&w=199&h=279&c=7&o=5&pid=1.7",
                            @"https://tse4-mm.cn.bing.net/th?id=OIP.US-zhj5AOFoo4UCkmFb0ogHaI7&w=199&h=240&c=7&o=5&pid=1.7",
                            @"https://tse4-mm.cn.bing.net/th?id=OIP.Vy2pNOvQbFmbgw73t43HzgHaKQ&w=199&h=276&c=7&o=5&pid=1.7",
                            @"https://tse4-mm.cn.bing.net/th?id=OIP.V9fc8r5RyI0CNiSDLv9vdgHaLH&w=199&h=298&c=7&o=5&pid=1.7"];
    NSArray *nameArr = @[@"江疏影",@"赵丽颖",@"朱茵",@"张佳宁",@"许晴",@"热巴",@"陈钰琪"];
    NSMutableArray *dataMArr = [NSMutableArray array];
    
    for (int i = 0; i<pictureArr.count; i++) {
        PersonModel *personModel = [PersonModel new];
        personModel.picture = pictureArr[i];
        personModel.name = nameArr[i];
        [dataMArr addObject:personModel];
    }
    self.dataArr = [dataMArr copy];
    
    NSLog(@"缓存地址%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"/com.hackemist.SDImageCache/default"]);
    
    //SDWebImage会先从内存中找，找不到就下载，下次显示同前，
    //可在模拟器上跑，然后打开缓存地址(点击Finder然后快捷键Common+Shift+G)，看图片实时下载,注意自定义cell中使用了prepareForReuse方法，这个是当单元格重用时的回调，取消当前下载与给图片先给一个值，避免还未下载图片重用单元格出现的刹那显示错乱。
    /**<第一种为：视图出现时就会下载图片，若是此图片还未下载成功将此单元格滑出屏幕，会取消滑出图片的下载转而下载此时出现的单元格的图片>*/
    /**<第二种为：视图首次出现、停止拖拽、停止减速时就会下载图片，若是此图片还未下载成功将此单元格滑出屏幕，会取消滑出图片的下载转而下载此时出现的单元格的图片>*/
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"第一种(推荐)",@"第二种"]];
    self.segmentControl.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 40);
    self.segmentControl.selectedSegmentIndex = 1;
    [self.segmentControl addTarget:self action:@selector(segmentControlChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:^{
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId forIndexPath:indexPath];
    cell.placeholderImage = self.placeholderImage;
    PersonModel *model = self.dataArr[indexPath.row];
    if (self.segmentControl.selectedSegmentIndex == 0) {//第一种
        cell.tableView = tableView;
        cell.indexPath = indexPath;
        cell.model = model;
    } else {//第二种
        cell.titleLabel.text = model.name;
        cell.imageVi.image = self.placeholderImage;
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.picture];
        if (cacheImage) {
            NSLog(@"图片尺寸%@",NSStringFromCGSize(cacheImage.size));
            cell.imageVi.image = cacheImage;
        } else {
            if (!tableView.isDragging && !tableView.isDecelerating) {
                [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    image = [image drawImageWithSize:CGSizeMake(kSCREEN_WIDTH, 600)];
                    cell.imageVi.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:model.picture completion:nil];
                }];
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

#pragma mark - 下载图片
- (void)loadImageForCellRows {
    NSArray *cells = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath * indexPath in cells) {
        HKTableViewCell *cell = (HKTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        PersonModel *model = self.dataArr[indexPath.row];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.picture];
        if (!cacheImage) {
            [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                image = [image drawImageWithSize:CGSizeMake(kSCREEN_WIDTH, 600)];
                cell.imageVi.image = image;
                [[SDImageCache sharedImageCache] storeImage:image forKey:model.picture completion:nil];
            }];
        }
    }
}

- (void)segmentControlChangeValue:(UISegmentedControl *)segmentControl {
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self.tableView reloadData];
    }];
}



@end
