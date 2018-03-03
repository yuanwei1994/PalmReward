//
//  PRHomeAllCollectionViewCell.h
//  PalmReward
//
//  Created by rimi on 16/12/8.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRHomeAllCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bacaImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *wantedTextView;
@property (weak, nonatomic) IBOutlet UILabel *prickLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic ,strong) PRTaskModel  *  TaskModel;

@end
