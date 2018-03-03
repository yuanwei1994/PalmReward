//
//  PRMenuView.h
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PushViewDelegate <NSObject>

- (void)pushViewController:(NSInteger)index;

@end

@interface PRMenuView : UIView

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, weak) id <PushViewDelegate> pushViewDelegate;
-(instancetype)initWithFrame:(CGRect)frame;

@end
