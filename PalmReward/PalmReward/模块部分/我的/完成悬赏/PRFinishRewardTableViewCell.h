//
//  PRFinishRewardTableViewCell.h
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRUserTaksModel.h"
@interface PRFinishRewardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *isFinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic,strong) PRUserTaksModel *task;
@end
