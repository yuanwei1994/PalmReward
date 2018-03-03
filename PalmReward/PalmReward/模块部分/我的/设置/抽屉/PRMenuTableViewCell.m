//
//  PRMenuTableViewCell.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMenuTableViewCell.h"

@implementation PRMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = AAFont(18);
    
    _spaceX.constant *= AAdaptionWidth();
    _spaceImage.constant *= AAdaptionWidth();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNameString:(NSString *)nameString {
    _nameString = nameString;
    _iconImageView.image = [UIImage imageNamed:nameString];
    _titleLabel.text = nameString;
}


@end
