//
//  PRMyFinishTableViewCell.h
//  PalmReward
//
//  Created by Candy on 16/12/27.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRUserTaksModel.h"

@interface PRMyFinishTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *isFinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic,strong) PRUserTaksModel *task;
@end
