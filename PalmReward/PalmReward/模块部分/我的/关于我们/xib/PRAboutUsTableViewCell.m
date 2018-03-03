//
//  PRAboutUsTableViewCell.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRAboutUsTableViewCell.h"

@implementation PRAboutUsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftConstraint.constant *= AAdaptionWidth();
    _rightConstraint.constant *= AAdaptionWidth();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

@end
