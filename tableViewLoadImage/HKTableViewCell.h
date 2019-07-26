//
//  HKTableViewCell.h
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageVi;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
