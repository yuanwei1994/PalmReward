//
//  PRHomeAllCollectionViewCell.m
//  PalmReward
//
//  Created by rimi on 16/12/8.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRHomeAllCollectionViewCell.h"

@implementation PRHomeAllCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _wantedTextView.userInteractionEnabled = NO;
}

- (void)setTaskModel:(PRTaskModel *)TaskModel{
    _TaskModel = TaskModel;
    [self setSomeThing];
}

-(void)setSomeThing{
    _timerLabel.text = _TaskModel.reward_commit_time;
    _titleLabel.text = _TaskModel.reward_title;
    _wantedTextView.text = _TaskModel.reward_content;
    _prickLabel.text = [NSString stringWithFormat:@"%@C币",_TaskModel.reward_coin];
    _nicknameLabel.text = _TaskModel.user_nickname;
}

@end
