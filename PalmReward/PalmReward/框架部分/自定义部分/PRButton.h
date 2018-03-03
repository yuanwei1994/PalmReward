//
//  PRButton.h
//  PalmReward
//
//  Created by rimi on 16/12/8.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRButton : UIButton

@property (nonatomic, copy) PRButtonBlock BtnBlock;
/*
 初始化方法
 位置          frame
 按钮标签       title
 按钮标签颜色    titleColor
 按钮背景颜色    backColor
 按钮tag值      tag
 按钮圆角       radius
 按钮点击Block         radius
 */
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title TitleColor:(UIColor*)titleColor titleFont:(CGFloat)titleFont backColor:(UIColor*)backColor BackImage:(UIImage*)backimage Tag:(NSInteger)tag radius:(CGFloat)radius BorderWidth:(CGFloat)BorderWidth BorderColor:(UIColor *)BorderColor Block:(PRButtonBlock)block ;

@end
