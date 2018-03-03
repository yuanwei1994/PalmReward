//
//  PRMenuTableViewCell.h
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceImage;
@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;

@property (nonatomic, copy) NSString                *nameString;
@end
