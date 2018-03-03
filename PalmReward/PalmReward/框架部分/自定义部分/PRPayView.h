//
//  PRPayView.h
//  PalmReward
//
//  Created by rimi on 16/12/19.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRPayView;
//代理
@protocol PRPayViewDelegate <NSObject>

-(void)onPayViewAction:(PRPayView*)PRPayView;

@end
@interface PRPayView : UIView
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,assign) BOOL selected;
@property(nonatomic, weak) id <PRPayViewDelegate> deleagte;


@end
