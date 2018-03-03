//
//  PRFinishRewardTableViewCell.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRFinishRewardTableViewCell.h"

@implementation PRFinishRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTask:(PRUserTaksModel *)task{
    _task = task;
    [self setSomeThing];
}

-(void)setSomeThing{
    _titleLabel.text = _task.reward_title;
    if ([_task.reward_task_stauts  isEqual: @"0"]) {
        _isFinishLabel.textColor = [UIColor redColor];
        _isFinishLabel.text = @"待 接 受";
    }
    else{
        _isFinishLabel.textColor = [UIColor blackColor];
        _isFinishLabel.text = @"已 接 受";
    }
    
    _timerLabel.text = _task.reward_commit_time;
}



@end
