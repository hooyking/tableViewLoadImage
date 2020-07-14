//
//  HKTableViewCell.h
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PersonModel;

@interface HKTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageVi;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) PersonModel *model;

@end

NS_ASSUME_NONNULL_END
