//
//  PRAboutUsTableViewCell.h
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRAboutUsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *AppMessage;
@property (weak, nonatomic) IBOutlet UILabel *Message;

@end
