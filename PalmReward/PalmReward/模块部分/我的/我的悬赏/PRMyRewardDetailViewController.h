//
//  PRMyRewardDetailViewController.h
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/22.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRMyRewardDetailViewController : UIViewController
@property (nonatomic, strong) PRTaskModel *taskModel;
@property (nonatomic, strong) NSString    *statusString;        //状态(已接受, 待接受, 已完成)
@end
