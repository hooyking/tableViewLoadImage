//
//  HKTableViewCell.m
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import "HKTableViewCell.h"
#import "PersonModel.h"

@implementation HKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageVi.image = self.placeholderImage;//占位图需要，不然网络很差时可看到显示错乱
    [self.imageVi sd_cancelCurrentImageLoad];//此方法作用是取消imageView以前关联的url的下载
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PersonModel *)model {
    _model = model;
    if (self.tableView && self.indexPath) {
        self.titleLabel.text = model.name;
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.picture];
        if (cacheImage) {
            self.imageVi.image = cacheImage;
            NSLog(@"图片尺寸%@",NSStringFromCGSize(cacheImage.size));
        } else {
            NSArray *cells = [self.tableView indexPathsForVisibleRows];
            if ([cells containsObject:self.indexPath]) {
                [self.imageVi sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    image = [image drawImageWithSize:CGSizeMake(kSCREEN_WIDTH, 600)];
                    self.imageVi.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:model.picture completion:nil];
                }];
            }
        }
    }
}

@end
