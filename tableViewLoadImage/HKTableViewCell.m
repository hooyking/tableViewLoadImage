//
//  HKTableViewCell.m
//  tableViewLoadImage
//
//  Created by hooyking on 2019/7/25.
//  Copyright © 2019年 hooyking. All rights reserved.
//

#import "HKTableViewCell.h"
#import <UIView+WebCache.h>

@implementation HKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageVi.image = [UIImage imageNamed:@"placeholder"];//这样用是为了重用单元格时，避免出现的刹那图片的错乱，你可以注释之后试试效果
    [self.imageVi sd_cancelCurrentImageLoad];//取消当前下载
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
