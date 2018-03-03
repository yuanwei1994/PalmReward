//
//  PRMineTableViewCell.h
//  PalmReward
//
//  Created by Candy on 16/12/15.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRMineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;

@property (nonatomic, copy) NSString                *nameString; //图标名字  与  标题名字 (相同)


@end
