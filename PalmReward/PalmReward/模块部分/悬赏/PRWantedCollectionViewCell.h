//
//  PRWantedCollectionViewCell.h
//  PalmReward
//
//  Created by rimi on 16/12/29.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isDelBlock)(BOOL isDel);

@interface PRWantedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (nonatomic,copy) isDelBlock isDel;
@end
