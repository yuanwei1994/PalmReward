//
//  PRMyFinishTableViewCell.m
//  PalmReward
//
//  Created by Candy on 16/12/27.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMyFinishTableViewCell.h"

@implementation PRMyFinishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTask:(PRUserTaksModel *)task{
    _task = task;
    [self setSomeThing];
}

-(void)setSomeThing{
    _titleLabel.text = _task.reward_title;
    _isFinishLabel.textColor = [UIColor redColor];
    _isFinishLabel.text = @"已 完 成";
    _timerLabel.text = _task.reward_commit_time;
}

@end
