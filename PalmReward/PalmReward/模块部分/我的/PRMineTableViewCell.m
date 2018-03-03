//
//  PRMineTableViewCell.m
//  PalmReward
//
//  Created by Candy on 16/12/15.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMineTableViewCell.h"

@implementation PRMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.font = AAFont(18);
}

- (void)setNameString:(NSString *)nameString {
    _nameString = nameString;
    _titleLabel.text = _nameString;
    _iconImageView.image = [UIImage imageNamed:_nameString];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
